const PDFDocument = require("pdfkit");
const fs = require("fs");
const axios = require("axios");
const date = require("date-and-time");
const now = new Date();

// Create a document
const doc = new PDFDocument({ size: "A5" });
count = 5;

var admin = require("firebase-admin");

var serviceAccount = require("./foodly.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "",
});

// Pipe its output somewhere, like to a file or HTTP response
// See below for browser usage
doc.pipe(fs.createWriteStream(`output.pdf`));

var db = admin.firestore();
// const db = firestore.initializeApp();
// const observer = db.collection('printTest').where('state', '==', 'CA')
const observer = db.collection("printTest").onSnapshot((querySnapshot) => {
  querySnapshot.docChanges().forEach((change) => {
    const datetime = date.format(now, "YYYY/MM/DD HH:mm:ss");
    if (change.type === "added") {
      data = change.doc.data();
      console.log(data);
      // console.log(data.itemsList[0].quantity);
      generateHeader(doc, data.tokenNo);
      BillNo(doc, 100, 200, "14543", datetime);
      lenBtw = 180;
      generateTableRow(doc, 160, "Product", "Quantity", "Rate", "Amount");
      dottedLine(doc, 170);
      for (i = 0; i <= data.itemsList.length - 1; i++) {
        generateTableRow(
          doc,
          lenBtw,
          `${data.itemsList[i].name}`, // prod
          `${data.itemsList[i].quantity}`, // qun
          `${data.itemsList[i].rate}`, // rate
          `${data.itemsList[i].amount}` // amout
        );
        lenBtw += 15;
      }
      dottedLine(doc, 140);
      totalAmount(
        doc,
        300,
        data.itemsList.length,
        data.Totalcost,
        data.cgst,
        data.sgst,
        data.Totalcost
      ); // doc, y, qty, stotal, sGST, cGST, netTotal
      generateFooter(doc);
      doc.end();
    }
  });
});

function generateHeader(doc, tk) {
  doc
    .fillColor("#444444")
    .fontSize(20)
    .font("Times-Bold")
    .fontSize(15)
    .text(`Token : ${tk}`, 10, 20, { align: "left" })
    .text("NEW KRISHNA CANTEEN", 100, 50, { align: "center" })
    .fontSize(10)
    .text("( Institutional Food Court )", 120, 70, { align: "center" })
    .text("SASTRA University", 120, 80, { align: "center" })
    .text("Thrirumalaisamudram, Thanjavur-613401", 120, 90, { align: "center" })
    .text("Phone No : 9003453105", 120, 100, { align: "center" })
    .text("GSTIN No : 33BDGL783456HFD", 120, 110, { align: "center" });
  dottedLine(doc, 140);

  // .text(
  //   "------------------------------------------------------------------------------------------------------------",
  //   10,
  //   120,
  //   { align: "center" }
  // )
  // .moveDown();
}
function dottedLine(doc, y) {
  doc
    .strokeColor("#444444")
    .lineWidth(1)
    .moveTo(5, y)
    .lineTo(550, y)
    .dash(5, { space: 2 })
    .stroke();
}
function generateFooter(doc) {
  dottedLine(doc, 480);
  doc
    .fillColor("#444444")
    .fontSize(10)
    .text("Thank You Visit Again", 70, 500, { align: "center" });
}

// var po = ["pqe", "t4yercv", "jvp043u", "f34fg5", "grt45fb";
function generateTableRow(doc, y, product, qty, rate, amount) {
  doc
    .fontSize(10)
    .font("Times-Bold")
    .text(product, 50, y, { align: "left" })
    .text(qty, 150, y)
    .text(rate, 250, y) // { width: 90, align: "right" })
    .text(amount, 300, y, { align: "right" }); //{ width: 90, align: "right" })
}

function BillNo(doc, x, y, billNo, datetime) {
  doc
    .fontSize(10)
    .font("Times-Bold")
    .text(`Bill No : ${billNo}`, x, y, { align: "left" })
    .text(datetime, x, y, { align: "right" })
    .text(`Waiter : Line`, x + 20, y, { align: "left" })
    .text("LINE", x + 20, y, { align: "center" });
}

function totalAmount(doc, y, qty, stotal, sGST, cGST, netTotal) {
  doc
    .fontSize(10)
    .font("Times-Bold")
    .text(`Qty : ${qty}`, 50, y, { align: "left" })
    .text(`STotal : ${stotal}`, 250, y, { align: "right" });
  // .text(qty, 180, y);

  doc
    .fontSize(10)
    .font("Times-Bold")
    .text(`SGST : ${sGST}`, 250, y + 15, { align: "right" }); // { width: 90, align: "right" })

  doc
    .fontSize(10)
    .font("Times-Bold")
    .text(`SGST : ${cGST}`, 300, y + 30, { align: "right" });
  doc
    .fontSize(20)
    .font("Times-Bold")
    .text(`Net : ${netTotal}`, 50, y + 40, { align: "center" });
}

// p.then((message) => {
//   console.log("This is Then " + message);
//   //   doc.end();
// }).catch((message) => {
//   console.log("This is catch " + message);
// });
