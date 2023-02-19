// import os from 'os';

function getHostName() {
  var os = require('os');
  const networkInterfaces: { [key: string]: [{ address: string; family: string; internal: boolean }] } =
    os.networkInterfaces();
  const hostname = os.hostname();
  const addresses: string[] = [hostname];
  for (const [key, val] of Object.entries(networkInterfaces)) {
    addresses.push(...val.filter((v) => v.internal === false && v.family === 'IPv4').map((v) => v.address));
  }
  console.log(addresses);
  return addresses.length > 0 ? addresses[0] : undefined;
}

export default getHostName;
