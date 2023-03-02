const functions = require("firebase-functions");
const { cert } = require("firebase-admin/app");

const admin = require("firebase-admin");
const serviceAccount = require("./foodly.json");

admin.initializeApp({
  credential: cert(serviceAccount),
});

const db = admin.firestore();

exports.generateBillNumber = functions.firestore
  .document("vendors/{U6FKmkY682MEy8LlDIiX}/activeOrders/{qwe}")
  .onCreate(async (snap, context) => {
    const getOrderNo = db.collection("vendors").doc("U6FKmkY682MEy8LlDIiX");
    try {
      await db
        .runTransaction(async (transaction) => {
          const doc = await transaction.get(getOrderNo);
          const orderNo = doc.data().currentOrderCounter + 1;
          transaction.update(getOrderNo, { currentOrderCounter: orderNo });
          return orderNo;
        })
        .then((orderNo) => {
          var data = {
            tokenNo: `${orderNo}`,
          };
          db.collection("vendors")
            .doc("U6FKmkY682MEy8LlDIiX")
            .collection("activeOrders")
            .doc(`${snap.id}`)
            .set(data, { merge: true })
            .then((v) => {
              console.log(`Added Token ${orderNo}`);
            });
        });
      console.log("Transaction success!");
    } catch (e) {
      console.log("Transaction failure:", e);
    }
    return null;
  });

exports.billingCompleted = functions.firestore
  .document("vendors/{U6FKmkY682MEy8LlDIiX}/activeOrders/{qwe}")
  .onUpdate((change, context) => {
    const newValue = change.after.data();
    var res = false;
    newValue.kitchens.forEach((element) => {
      res = element.receiptPrinted;
    });
    if (res) {
      var data = {
        isAllOrdersPlaced: `${res}`,
      };
      db.collection("vendors")
        .doc("U6FKmkY682MEy8LlDIiX")
        .collection("activeOrders")
        .doc(`${change.after.id}`)
        .set(data, { merge: true })
        .then((v) => {
          console.log(`Printed Orders ${res}`);
        });
    }
    // if(newValue.kitchens[0].receiptPrinted == true){
    // }
    // console.log(newValue.kitchens[0].kitchenID);
    // const previousValue = change.before.data();
    return null;
  });

// exports.moveExpiredDocuments = functions.pubsub
//   .schedule("0 0 * * *") // https://crontab.guru/#*_*_*_*_*
//   .onRun(async (context) => {
//     tokenNo = 1;
//     return null;
//   });
