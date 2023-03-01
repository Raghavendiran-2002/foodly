const functions = require("firebase-functions");
const { cert } = require("firebase-admin/app");

const admin = require("firebase-admin");
const serviceAccount = require("./foodly.json");

admin.initializeApp({
  credential: cert(serviceAccount),
});

const db = admin.firestore();

exports.createUser = functions.firestore
  .document("users/{'qwe'}")
  .onCreate((snap, context) => {
    // Get an object representing the document
    // e.g. {'name': 'Marie', 'age': 66}
    const newValue = snap.data();
    console.log(newValue);
    // access a particular field as you would any JS property
    // const name = newValue.name;
    var tokenNo = 35;
    db.doc("users/{'qwe}").update({
      tokenNo: `${tokenNo}`,
    });
    // perform desired operations ...
  });

// exports.useMultipleWildcards = functions.firestore
//   .document("vendors/rew/poi")
//   .onCreate((snap, context) => {
//     // Get an object representing the document
//     // e.g. {'name': 'Marie', 'age': 66}
//     const newValue = snap.data();
//     console.log(snap.data());

//     // access a particular field as you would any JS property
//     const name = newValue.name;
//     db.doc("some/otherdoc").update({
//       tokenNo: `${tokenNo}`,
//     });
//     console.log("************************************");
//     console.log("Done");
//     // perform desired operations ...
//   });
