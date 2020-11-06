// @flow strict
import React from 'react';
import { DiscussionEmbed } from 'disqus-react';
import { useSiteMetadata } from '../../../hooks';

type Props = {
  postTitle: string,
  postSlug: string
};

const Comments = ({ postTitle, postSlug }: Props) => {
  const { url, disqusShortname } = useSiteMetadata();

  if (!disqusShortname) {
    return null;
  }
  
  const disqusConfig = {
    shortname: disqusShortname,
    config: {
      url: url + postSlug,
      identifier: postTitle,
      title: postTitle,
      language: 'en'
    }
  }
  
  return (
    <DiscussionEmbed {...disqusConfig}/>
  );
};

export default Comments;
