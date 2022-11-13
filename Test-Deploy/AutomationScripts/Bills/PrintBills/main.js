const PDFDocument = require("pdfkit");
const fs = require("fs");
const axios = require("axios");
const { resolve } = require("path");
const { rejects } = require("assert");

// Create a document
const doc = new PDFDocument();
count = 5;

// Pipe its output somewhere, like to a file or HTTP response
// See below for browser usage
doc.pipe(fs.createWriteStream(`${5}output.pdf`));
doc.text("Hello world! dshdh", 150, 150);

var p = new Promise((resolve, rejects) => {
  //   data1 = "None";
  //   let doc1 = new PDFDocument({ margin: 50 });
  //   count = 1;

  axios
    .get(
      `https://us-central1-cloudfunctionsrestapi.cloudfunctions.net/widgets/${count}`
    )
    .then((resp) => {
      data1 = resp.data;
      const myJSON = JSON.stringify(data1);
      console.log(resp.data);
      if (myJSON == null) {
        rejects("Failed");
      } else {
        resolve("Success");
        doc.text("Hello world!", 200, 200);
        console.log(myJSON);
        doc.fontSize(25).text(`${myJSON}`, 240, 240);
        doc.end();
      }
      //   generateHeader(doc);

      console.log(data1);
      //   generateTableRow(
      //     doc,
      //     // data["tokenNumber"],

      //     3,
      //     "Dosa",
      //     "Dfd",
      //     "fdg",
      //     // data["OrderItem"],
      //     // data["quantity"],
      //     data1,
      //     "jkiumy"
      //   );
      //   generateFooter(doc);
    });
});

function generateHeader(doc) {
  doc
    // .image("logo.png", 50, 45, { width: 50 })
    .fillColor("#444444")
    .fontSize(20)
    .text("ACME Inc.", 110, 57)
    .fontSize(10)
    .text("123 Main Street", 200, 65, { align: "right" })
    .text("New York, NY, 10025", 200, 80, { align: "right" })
    .moveDown();
}

function generateFooter(doc) {
  completed = false;
  doc
    .fontSize(10)
    .text(
      "Payment is due within 15 days. Thank you for your business.",
      50,
      780,
      { align: "center", width: 500 }
    );
}

// var po = ["pqe", "t4yercv", "jvp043u", "f34fg5", "grt45fb";
function generateTableRow(doc, y, c1, c2, c3, c4, c5) {
  doc
    // .fontSize(10)
    .text(c1, 50, y)
    .text(c2, 150, y)
    .text(c3, 280, y, { width: 90, align: "right" })
    .text(c4, 370, y, { width: 90, align: "right" })
    .text(c5, 0, y, { align: "right" });
}

// while (count < 2) {

//   count++;
// }
p.then((message) => {
  console.log("This is Then " + message);
  //   doc.end();
}).catch((message) => {
  console.log("This is catch " + message);
});
// doc.end();
// doc.end();
