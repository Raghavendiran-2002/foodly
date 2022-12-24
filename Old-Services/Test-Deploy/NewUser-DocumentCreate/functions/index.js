const functions = require("firebase-functions");
const {Firestore} = require("@google-cloud/firestore");

const firestore = new Firestore();

exports.sendByeEmail = functions.auth.user().onCreate(async (user) => {
  console.log("Running The Function");
  const data = {UID: user.uid, email: user.email};
  await firestore.collection("usersCollection").add(data);
  console.log("Completed DB Upload");
  return "hI";
  // return writeResult.then(() => {
  //   console.log("Succesfully Created Document");
  // });
});
