const serverless = require("serverless-http");
const app = require("./app");

module.exports.handler = serverless(app);

app.use((req, res, next) => {
  console.log("REQ HEADERS:", req.headers);
  next();
});
