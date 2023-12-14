const { jsPDF } = require("jspdf");
const date = require("date-and-time");

function generateBill(tk_no, code, OrderItems, totalAmount) {
  const now = new Date();
  var dateNow = date.format(now, "YYYY/MM/DD HH:mm:ss");
  const doc = new jsPDF("p", "mm", [72, 80 + 3 * OrderItems.length]);
  doc
    .setFontSize(12)
    .setFont(undefined, "bold")
    .text(`Token No: ${tk_no}         Pin: ${code} `, 35, 6, {
      align: "center",
    });

  doc
    .setFontSize(12)
    .setFont(undefined, "bold")
    .text("NEW KRISHNA CANTEEN", 35, 14, { align: "center" })
    .setFontSize(7)
    .setFont(undefined, "normal")
    .text("Institutional Food Court", 35, 18, { align: "center" })
    .text("SASTRA University", 35, 21, { align: "center" })
    .text("Thrirumalaisamudram, Thanjavur-613401", 35, 24, { align: "center" })
    .text("Phone No : 9003453105", 35, 27, { align: "center" })
    .text("GSTIN No : 33BDGL783456HFD", 35, 30, { align: "center" })
    .text(`Bill No : 21324                ${dateNow}`, 35, 33, {
      align: "center",
    })
    .text(
      "-------------------------------------------------------------------------------",
      2,
      36,
      { align: "left" }
    );
  generateRow(doc, 39, "Product", "Qty", "Rate", "Amount");
  doc.text(
    "-------------------------------------------------------------------------------",
    2,
    41,
    { align: "left" }
  );
  var lenBtw = 45;
  for (i = 0; i < OrderItems.length; i++) {
    generateItems(
      doc,
      lenBtw,
      `${OrderItems[i]["foodItemName"]}`,
      `${OrderItems[i]["quantity"]}`,
      `${OrderItems[i]["rate"]}`,
      `${OrderItems[i]["rate"] * OrderItems[i]["quantity"]}`
    );
    lenBtw += 4;
  }
  doc.text(
    "-------------------------------------------------------------------------------",
    2,
    lenBtw,
    { align: "left" }
  );
  doc
    .text(
      `Qty : ${OrderItems.length}             STotal  : 124.34`,
      15,
      lenBtw + 3
    )
    .text("                       SGST   : 3.53", 15, lenBtw + 6)
    .text("                       CGST   : 4.34", 15, lenBtw + 9)
    .setFont(undefined, "bold")
    .setFontSize(10)
    .text(`Net : ${totalAmount}`, 35, lenBtw + 15, {
      align: "center",
    })
    .setFont(undefined, "normal");
  doc
    .setFontSize(10)
    .text("Thank You Visit Again", 35, lenBtw + 20, { align: "center" });
  console.log("****************");
  console.log(lenBtw + 30);
  doc.save(`./bills/${code}.pdf`);
}

function generateItems(doc, y, c1, c2, c3, c4) {
  doc
    .setFontSize(7)
    .setFont(undefined, "bold")
    .text(c1, 5, y)
    .setFont(undefined, "normal")
    .text(c2, 45, y)
    .text(c3, 50, y)
    .text(c4, 57, y);
}
function generateRow(doc, y, c1, c2, c3, c4) {
  doc
    .setFontSize(7)
    .setFont(undefined, "bold")
    .text(c1, 5, y)
    .text(c2, 43, y)
    .text(c3, 49, y)
    .text(c4, 58, y)
    .setFont(undefined, "normal");
}

module.exports = { generateBill };