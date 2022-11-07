const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendByeEmail = functions.auth.user().onCreate(async (user) => {
  console.log("Running The Function");
  const writeResult = await admin
    .firestore()
    .collection("usersCollection")
    .add({ UID: user.uid, phone: user.email, createOn: user.createOn });

  return writeResult.then(() => {
    console.log("Succesfully Created Document");
  });
});
