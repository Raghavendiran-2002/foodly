const PDFDocument = require("pdfkit");
const docs = new PDFDocument();
const fs = require("fs");
var admin = require("firebase-admin");
var serviceAccount = require("/Users/raghavendiran/Development/Foodly/CloudFunctions/Test-Deploy/AutomationScripts/Foodly.json");

docs.pipe(fs.createWriteStream("reciept.pdf"));
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function makeBill() {
  let doc1 = new PDFDocument({ margin: 50 });
  generateHeader(doc1);
  generateFooter(doc1);
  generateTableRow(doc1, 2, "gfdh", "piou9", "cl3;guer", "h5yij", "jkiumy");
  doc1.end();
}

// var completed = false;
async function getAllDoc(db) {
  const activeOrders = db.collection("activeOrders");
  const snapshot = await activeOrders.get();
  snapshot.forEach((doc) => {
    const myJSON = JSON.stringify(doc.data());
    console.log(myJSON);
  });
}

async function getSpecficDoc(db, tokenNumber) {
  const activeOrders = db
    .collection("activeOrders")
    .where("tokenNumber", "==", tokenNumber);
  const snapshot = await activeOrders.get();
  const data = "";
  snapshot.forEach((doc) => {
    const myJSON = JSON.stringify(doc.data());
    // console.log(myJSON);
    // console.log(doc.data()["orderItem"]);
    // data = doc.data();
    return doc.data();
  });
}

function generateHeader(doc) {
  doc
    .image("logo.png", 50, 45, { width: 50 })
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
function generateTableRow(docs, y, c1, c2, c3, c4, c5) {
  docs
    .fontSize(10)
    .text(c1, 50, y)
    .text(c2, 150, y)
    .text(c3, 280, y, { width: 90, align: "right" })
    .text(c4, 370, y, { width: 90, align: "right" })
    .text(c5, 0, y, { align: "right" });
}
// getAllDoc(db);
console.log(getSpecficDoc(db, 1)).then();
