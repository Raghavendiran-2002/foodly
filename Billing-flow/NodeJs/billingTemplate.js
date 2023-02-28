const { jsPDF } = require("jspdf");
const date = require("date-and-time");

function generateBill(tk_no, code) {
  const now = new Date();
  var dateNow = date.format(now, "YYYY/MM/DD HH:mm:ss");
  const doc = new jsPDF("p", "mm", [72, 210]);
  // doc.text("Hello world!", 1, 1);
  doc
    .setFontSize(12)
    .setFont(undefined, "bold")
    .text(`Token No: ${tk_no}            Pin: ${code}`, 35, 6, {
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
  generateRow(doc, 39, "Product", "Quantity", "Rate", "Amount");
  doc.text(
    "-------------------------------------------------------------------------------",
    2,
    41,
    { align: "left" }
  );
  var lenBtw = 45;
  for (i = 0; i <= 5; i++) {
    generateItems(doc, lenBtw, `Dosa`, "4", "40.00", "244");
    lenBtw += 4;
  }
  doc.text(
    "-------------------------------------------------------------------------------",
    2,
    lenBtw,
    { align: "left" }
  );
  doc
    .text("Qty : 3             STotal  : 124.34", 15, lenBtw + 3)
    .text("                       SGST   : 3.53", 15, lenBtw + 6)
    .text("                       CGST   : 4.34", 15, lenBtw + 9)
    .setFont(undefined, "bold")
    .setFontSize(10)
    .text("Net : 135.00", 35, lenBtw + 15, { align: "center" })
    .setFont(undefined, "normal");
  doc
    // .fillColor("#444444")
    .setFontSize(10)
    .text("Thank You Visit Again", 35, lenBtw + 20, { align: "center" });
  doc.save("./two-by-four.pdf");
}

function generateItems(doc, y, c1, c2, c3, c4) {
  doc
    .setFontSize(7)
    .setFont(undefined, "bold")
    .text(c1, 5, y)
    .setFont(undefined, "normal")
    .text(c2, 28, y)
    .text(c3, 40, y)
    .text(c4, 55, y);
}
function generateRow(doc, y, c1, c2, c3, c4) {
  doc
    .setFontSize(7)
    .setFont(undefined, "bold")
    .text(c1, 5, y)
    .text(c2, 28, y)
    .text(c3, 40, y)
    .text(c4, 55, y)
    .setFont(undefined, "normal");
}
generateBill(1, "av23");
