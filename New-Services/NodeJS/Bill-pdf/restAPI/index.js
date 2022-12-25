var express = require("express");
var ptp = require("pdf-to-printer");
var fs = require("fs");
var path = require("path");
const app = express();
const port = 3000;

app.post("", express.raw({ type: "application/pdf" }), async (req, res) => {
  const options = {};
  if (req.query.printer) {
    options.printer = req.query.printer;
    console.log("1");
  }
  const tmpFilePath = path.join(
    `./${Math.random().toString(36).substr(7)}.pdf`
  );
  console.log("2");

  //   fs.writeFileSync(tmpFilePath, req.body, "binary");
  await ptp.print(tmpFilePath);
  //   ptp.print(tmpFilePath);
  console.log("hi");
  fs.unlinkSync(tmpFilePath);

  res.status(204);
  res.send();
});

app.listen(port, () => {
  console.log(`PDF Printing Service listening on port ${port}`);
});
