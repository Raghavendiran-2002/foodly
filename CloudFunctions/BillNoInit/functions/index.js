const functions = require("firebase-functions");
const { cert } = require("firebase-admin/app");

const admin = require("firebase-admin");
const serviceAccount = require("./foodly.json");

admin.initializeApp({
  credential: cert(serviceAccount),
});

const db = admin.firestore();
var tokenNo = 1;
exports.billNumber = functions.firestore
  .document("vendors/{U6FKmkY682MEy8LlDIiX}/activeOrders/{qwe}")
  .onCreate((snap, context) => {
    const newValue = snap.data();
    console.log("*****************************");
    console.log(snap.id);
    var data = {
      tokenNo: `${tokenNo}`,
    };
    db.collection("vendors")
      .doc("U6FKmkY682MEy8LlDIiX")
      .collection("activeOrders")
      .doc(`${snap.id}`)
      .set(data, { merge: true })
      .then((v) => {
        console.log(v);
        console.log("Added Token");
      });
    tokenNo++;
    return null;
  });

exports.moveExpiredDocuments = functions.pubsub
  .schedule("0 0 * * *") // https://crontab.guru/#*_*_*_*_*
  .onRun(async (context) => {
    tokenNo = 1;
    return null;
  });
