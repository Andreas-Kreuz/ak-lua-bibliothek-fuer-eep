import { useState } from 'react';

const useDebug = () => {
  const [debug] = useState(process.env.NODE_ENV !== 'production');

  return debug;
};

export default useDebug;
