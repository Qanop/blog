---
title: "How To Get Full HTTP Logs from Istio with Envoy and Lua Filters"
date: "2025-10-28T18:00:00.000Z"
template: "post"
draft: false
slug: "istio-envoy-full-http-logging-lua-filters"
category: "Technology"
tags:
  - "Observability"
  - "Kubernetes"
  - "Istio"
  - "Envoy"
description: "Envoy sidecars in Istio don't log request/response bodies by default. Here’s how to solve it with Lua filters."
socialImage: "media/bitnami-docker.jpg"
---

_Istio uses the `Envoy Proxy` as a sidecar for Kubernetes pods. This allows for transparent traffic routing and encryption. These proxies are predestined to generate a complete HTTP access log for your Kubernetes cluster. **However**, `Envoy` does not offer command operators to log the request or response body and there is no command operator to dynamically access all headers either. Let's see how we can retrofit this with `Envoy`'s on-board resources._

## Create a Lua Filter for Envoy
Envoy can be extended with custom filters written in Lua. Such filters have access to the HTTP context and can add temporarily data to this context with the **dynamicMetadata** object. The following Lua function retrieves the headers and the body of a HTTP request and stores both in the **dynamicMetadata** object with the keys **request_headers** and **request_body**.
```shell
function envoy_on_request(request_handle)
  local headers = request_handle:headers()
  local headersMap = {}
  for key, value in pairs(headers) do
    headersMap[key] = value
  end                
  request_handle:streamInfo():dynamicMetadata():set("envoy.lua","request_headers",headersMap)                    
  local requestBody = ""
  for chunk in request_handle:bodyChunks() do
    if (chunk:length() > 0) then
      requestBody = requestBody .. chunk:getBytes(0, chunk:length())
    end
  end
  request_handle:streamInfo():dynamicMetadata():set("envoy.lua","request_body",requestBody)                    
end
```
Note that the function must be named **envoy_on_request** to be invoked on every request. Envoy also supports **envoy_on_response** for a function to be invoked on every response.

## Configure the Filter and the Log Format for Istio
An `Istio EnvoyFilter` resource will be used to add the Lua filter to every `Envoy proxy` in your `Istio service mesh` (sidecars and gateways). Below is a working example which will add both functions **envoy_on_request** and **envoy_on_response** as filter. It will put the values **request_headers**, **request_body**, **response_headers** and **response_body** to the **dynamicMetadata** object.

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  name: request-response-filter
  namespace: istio-system
spec:
  configPatches:
  - applyTo: HTTP_FILTER
    match:
      context: ANY
      listener:
        filterChain:
          filter:
            name: "envoy.filters.network.http_connection_manager"
            subFilter:
              name: "envoy.filters.http.router"
    patch:
      operation: INSERT_BEFORE
      value:
        name: envoy.lua
        typed_config:
            "@type": "type.googleapis.com/envoy.extensions.filters.http.lua.v3.Lua"
            inlineCode: |
              function envoy_on_request(request_handle)
                local headers = request_handle:headers()
                local headersMap = {}
                for key, value in pairs(headers) do
                  headersMap[key] = value
                end                
                request_handle:streamInfo():dynamicMetadata():set("envoy.lua","request_headers",headersMap)                    
                local requestBody = ""
                for chunk in request_handle:bodyChunks() do
                  if (chunk:length() > 0) then
                    requestBody = requestBody .. chunk:getBytes(0, chunk:length())
                  end
                end
                request_handle:streamInfo():dynamicMetadata():set("envoy.lua","request_body",requestBody)                    
              end

              function envoy_on_response(response_handle)
                local headers = response_handle:headers()
                local headersMap = {}
                for key, value in pairs(headers) do
                  headersMap[key] = value
                end                
                response_handle:streamInfo():dynamicMetadata():set("envoy.lua","response_headers",headersMap)                    
                local responseBody = ""
                for chunk in response_handle:bodyChunks() do
                  if (chunk:length() > 0) then
                    responseBody = responseBody .. chunk:getBytes(0, chunk:length())
                  end
                end
                response_handle:streamInfo():dynamicMetadata():set("envoy.lua","response_body",responseBody)                    
              end
```

With that filter in place, it is possible to add request_headers and **request_body** to the log output with the **DYNAMIC_METADATA** command operator. The desired log format can be applied either as part of an `IstioOperator` resource or passed as values file, when using the `Helm Istio discovery` chart. The relevant section which must be placed beneath the **meshConfig** key is shown below. Note the last four lines which refer to the data generated by Lua-filter above.
```yaml
meshConfig:
  accessLogFile: /dev/stdout
  accessLogEncoding: JSON
  accessLogFormat: |
    {
      "protocol": "%PROTOCOL%",
      "method": "%REQ(:METHOD)%",
      "path": "%REQ(X-ENVOY-ORIGINAL-PATH?:PATH)%",
      "responseCode": "%RESPONSE_CODE%",
      "clientDuration": "%DURATION%",
      "responseCodeDetails": "%RESPONSE_CODE_DETAILS%",
      "connectionTerminationDetails": "%CONNECTION_TERMINATION_DETAILS%",
      "targetDuration": "%RESPONSE_DURATION%",
      "upstreamName": "%UPSTREAM_CLUSTER%",
      "traceId": "%REQ(X-B3-Traceid)%",
      "responseFlags": "%RESPONSE_FLAGS%",
      "routeName": "%ROUTE_NAME%",
      "downstreamRemoteAddress": "%DOWNSTREAM_REMOTE_ADDRESS%",
      "upstreamHost": "%UPSTREAM_HOST%",
      "downstreamLocalURISan": "%DOWNSTREAM_LOCAL_URI_SAN%",
      "requestHeaders": "%DYNAMIC_METADATA(envoy.lua:request_headers)%",
      "requestBody": "%DYNAMIC_METADATA(envoy.lua:request_body)%",
      "responseHeaders": "%DYNAMIC_METADATA(envoy.lua:response_headers)%",
      "responseBody": "%DYNAMIC_METADATA(envoy.lua:response_body)%"
    }
```

# Observability results
After deploy this configuration to `Istio` and watch the log of a sidecar or a gateway, you will see a log output as shown below. This log can easily by forwarded to an `ElasticSearch stack`, which will parse the JSON output to dedicated fields. Now you have a fully fledged HTTP traffic log of your `Istio service mesh`.

_Have fun and keep logging!_
```yaml
{
    "requestBody": "{ \"request\": \"hi there\" }",
    "responseCodeDetails": "via_upstream",
    "downstreamRemoteAddress": "192.168.1.1:54321",
    "responseFlags": "-",
    "method": "POST",
    "routeName": null,
    "protocol": "HTTP/1.1",
    "upstreamHost": "10.1.0.1:80",
    "responseHeaders": {
        "content-type": "application/json",
        "server": "gunicorn/20.0.0",
        "x-envoy-upstream-service-time": "1",
        "access-control-allow-credentials": "true",
        "date": "Sat, 28 Jan 2025 21:36:59 GMT",
        "access-control-allow-origin": "*",
        ":status": "200",
        "connection": "keep-alive",
        "content-length": "1252"
    },
    "path": "/post",
    "connectionTerminationDetails": null,
    "responseCode": 200,
    "upstreamName": "outbound|8000||httpbin.httpbin.svc.cluster.local",
    "responseBody": "{ \"response\": \"you are welcome\" }",
    "clientDuration": 1,
    "requestHeaders": {
        "x-envoy-peer-metadata": "ChQKDkFQUF9DT05UQUlORVJTEgIaAAoaCgpDTFVTVEVSX0lEEgwaCkt1YmVybmV0ZXMK=",
        "content-type": "application/json",
        "x-envoy-decorator-operation": "httpbin.httpbin.svc.cluster.local:8000/*",
        "x-envoy-peer-metadata-id": "router~10.1.0.1~istio-ingress-najfe-kvqfl.istio-ingress~istio-ingress.svc.cluster.local",
        "postman-token": "3523-23523-5235-23523",
        ":authority": "httpbin.example.com",
        "x-forwarded-proto": "http",
        "x-request-id": "bafefe-24-42njq-jafeja32-jnajfenjn2",
        "accept-encoding": "gzip, deflate, br",
        "x-forwarded-for": "192.168.1.1",
        "accept": "*/*",
        ":method": "POST",
        "content-length": "26",
        "x-envoy-internal": "true",
        "user-agent": "PostmanRuntime/10.0.0",
        ":path": "/post",
        ":scheme": "http"
    },
    "traceId": "njain3jbr231kkn",
    "downstreamLocalURISan": null,
    "targetDuration": 1
}
```
_Check out more k8s solutions made by [oversees engineers](https://devpress.csdn.net/k8s)._