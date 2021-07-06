const { create } = require("ipfs-http-client");
const ipfs = create({
  url: "https://ipfs.infura.io:5001",
  port: 5001,
  headers: {},
});
export default ipfs;
