const {
  initializeApp,
  applicationDefault,
  cert,
} = require("firebase-admin/app");
const {
  getFirestore,
  Timestamp,
  FieldValue,
} = require("firebase-admin/firestore");

const bill = require("./billingTemplate.js");
const { jsPDF } = require("jspdf");
const serviceAccount = require("./foodly.json");

initializeApp({
  credential: cert(serviceAccount),
});

const db = getFirestore();

// const doc = db
//   .collection("vendors")
//   .doc("U6FKmkY682MEy8LlDIiX")
//   .collection("activeOrders");
var i = 0;
db.collection("vendors")
  .doc("U6FKmkY682MEy8LlDIiX")
  .collection("activeOrders") // UuX6MIQIMe3shigJ0fbD
  .where("kitchens", "array-contains", {
    kitchenID: "UuX6MIQIMe3shigJ0fbD",
    receiptPrinted: false,
  })
  .orderBy("tokenNo")
  .onSnapshot((querySnapshot) => {
    querySnapshot.docChanges().forEach((change) => {
      var docID = change.doc.id;
      if (change.type === "added") {
        console.log(`Order ${i}: `, change.doc.data());
        bill.generateBill(
          change.doc.data()["tokenNo"],
          change.doc.data()["secretKey"],
          change.doc.data()["orderItems"],
          change.doc.data()["totalAmount"]
        );
        var kitchenArray = change.doc.data()["kitchens"];
        kitchenArray.forEach((element) => {
          if (element["kitchenID"] == "UuX6MIQIMe3shigJ0fbD") {
            element["receiptPrinted"] = true;
          }
        });
        db.collection("vendors")
          .doc("U6FKmkY682MEy8LlDIiX")
          .collection("activeOrders")
          .doc(`${docID}`)
          .update({
            kitchens: kitchenArray,
          });
        i++;
      }
    });
  });
