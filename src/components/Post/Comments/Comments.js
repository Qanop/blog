// @flow strict
import React from 'react';
import { useSiteMetadata } from '../../../hooks';

type Props = {
  postSlug: string
};

const Comments = ({ postSlug }: Props) => {
  const { url } = useSiteMetadata();

  return (
    <div style={{'text-align-last': 'center'}}>
      <a
        href={'https://twitter.com/search?q=' + url + postSlug}
        rel="noopener noreferrer"
        target="_blank"
      >
        Join discussion on <strong>Twitter</strong>
      </a>
    </div>
  )
};

export default Comments;
