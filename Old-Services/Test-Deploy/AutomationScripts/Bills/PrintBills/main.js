const PDFDocument = require("pdfkit");
const fs = require("fs");
const axios = require("axios");

// Create a document
const doc = new PDFDocument({ size: "A5" });
count = 5;

// Pipe its output somewhere, like to a file or HTTP response
// See below for browser usage
doc.pipe(fs.createWriteStream(`${5}output.pdf`));

var p = new Promise((resolve, rejects) => {
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
        generateHeader(doc);
        lenBtw = 180;
        generateTableRow(
          doc,
          160,
          "OrderItem",
          "Quantity",
          "Rate",
          "Amount",
          "jkiumy",
          "tokenNumber"
        );
        for (i = 0; i <= 5; i++) {
          generateTableRow(
            doc,
            lenBtw,
            `${data1["OrderItem"]}`,
            `${data1["quantiuiy"]}`,
            "cl3;guer",
            "h5yij",
            "jkiumy",
            `${data1["tokenNumber"]}`
          );
          lenBtw += 20;
        }
        // generateTableRow(
        //   doc,
        //   300,
        //   "fhdhdf",
        //   ";dfhg",
        //   "cl3;guer",
        //   "h5yij",
        //   "jkiumy",
        //   "jfdhgdflgh"
        // );
        console.log(data1["OrderItem"]);
        // doc.fontSize(25).text(`${myJSON}`, 240, 240);
        generateFooter(doc);
        doc.end();
      }
    });
});

function generateHeader(doc) {
  doc
    .fillColor("#444444")
    .fontSize(20)
    .text("NEW KRISHNA CANTEEN", 100, 50, { align: "center" })
    .fontSize(10)
    .text("Institutional Food Court", 120, 70, { align: "center" })
    .text("SASTRA University", 120, 80, { align: "center" })
    .text("Thrirumalaisamudram, Thanjavur-613401", 120, 90, { align: "center" })
    .text("Phone No : 9003453105", 120, 100, { align: "center" })
    .text("GSTIN No : 33BDGL783456HFD", 120, 110, { align: "center" })
    .text(
      "-------------------------------------------------------------------------------",
      80,
      120,
      { align: "left" }
    )
    .moveDown();
}

function generateFooter(doc) {
  completed = false;
  doc
    .fillColor("#444444")
    .fontSize(10)
    .text("Thank You Visit Again", 70, 500, { align: "center" });
}

// var po = ["pqe", "t4yercv", "jvp043u", "f34fg5", "grt45fb";
function generateTableRow(doc, y, c1, c2, c3, c4, c5, tk) {
  doc.fontSize(20).text(`Token No : ${tk}`, 120, 130, { align: "center" });
  doc
    .fontSize(10)
    .text(c1, 50, y)
    .text(c2, 100, y)
    .text(c3, 150, y) // { width: 90, align: "right" })
    .text(c4, 200, y) //{ width: 90, align: "right" })
    .text(c5, 0, y, { align: "right" });
}

p.then((message) => {
  console.log("This is Then " + message);
  //   doc.end();
}).catch((message) => {
  console.log("This is catch " + message);
});
