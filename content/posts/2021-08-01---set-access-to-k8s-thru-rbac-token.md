---
title: Set access to k8s thru RBAC Token
date: "2021-08-01T20:28:38.000Z"
template: "post"
draft: false
slug: "set-access-to-k8s-thru-rbac-token"
category: "Technology"
tags:
  - "Technology"
  - "Ops / DevOps"
description: "How to give access only to logs to dev team on running k8s env? I finally found gist snippet that works"
socialImage: "media/server-2.jpg"
---
Recently, I was trying to find a suitable way to share the k8s logs with the development team. After searching the internet, I finally found a suitable and current solution for the new kuberentes versions. With a little help and a mini-customization of the code, I present the result for everyone who will need help. Let the code be with you!

(Just watch out for TLS auth... Soo... To be fixed later... )   (ó﹏ò｡)

```shell
#!/bin/bash
if [ -z ${CLUSTERNAME} ] || [ -z ${NAMESPACE} ] || [ -z ${USERNAME} ] || [ -z ${K8S_CONTEXT} ]; then echo Usage: K8S_CONTEXT=admin.context CLUSTERNAME=project.name NAMESPACE=default USERNAME=dev ./script.sh && exit 1; fi;

# Command with context to admin user
KUBE_COMMAND="kubectl --context $K8S_CONTEXT"

$KUBE_COMMAND delete serviceaccount/$USERNAME-sa
$KUBE_COMMAND delete clusterrole.rbac.authorization.k8s.io/$USERNAME-cr
$KUBE_COMMAND delete rolebinding.rbac.authorization.k8s.io/$USERNAME-rb

cat <<EOF | $KUBE_COMMAND apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: $USERNAME-sa
  namespace: $NAMESPACE
EOF

# Set here what resources are allowed to enter
cat <<EOF | $KUBE_COMMAND apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: $USERNAME-cr
rules:
- verbs: ["get", "list", "watch"]
  resources: 
  - pods
  - deployments
  - jobs
  - cronjobs
  - pods/log
  apiGroups: ["", "apps", "batch"]
EOF


cat <<EOF | $KUBE_COMMAND apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: $USERNAME-rb
  namespace: $NAMESPACE
subjects:
- kind: ServiceAccount
  name: $USERNAME-sa
  namespace: $NAMESPACE
roleRef:
  kind: ClusterRole
  name: $USERNAME-cr
  apiGroup: rbac.authorization.k8s.io
EOF

TOKEN=$($KUBE_COMMAND describe -n default secrets "$($KUBE_COMMAND describe -n default serviceaccount $USERNAME-sa | grep -i Tokens | awk '{print $2}')" | grep token: | awk '{print $2}')

kubectl --kubeconfig=kubeconfig-$CLUSTERNAME config set-cluster $CLUSTERNAME --server=$($KUBE_COMMAND config view -o jsonpath='{.clusters[0].cluster.server}')
kubectl --kubeconfig=kubeconfig-$CLUSTERNAME config set-credentials $CLUSTERNAME-$USERNAME --token=$TOKEN --kubeconfig=kubeconfig-$CLUSTERNAME
kubectl --kubeconfig=kubeconfig-$CLUSTERNAME config set-context $CLUSTERNAME --cluster=$CLUSTERNAME --user=$CLUSTERNAME-$USERNAME
kubectl --kubeconfig=kubeconfig-$CLUSTERNAME config use-context $CLUSTERNAME

kubectl --kubeconfig=kubeconfig-$CLUSTERNAME --insecure-skip-tls-verify auth can-i get pods --namespace $NAMESPACE
```