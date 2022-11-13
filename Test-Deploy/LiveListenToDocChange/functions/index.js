const functions = require("firebase-functions");
const express = require("express");
const admin = require("firebase-admin");
const axios = require("axios");
const app = express();
admin.initializeApp();

app.get("/:id", async (req, res) => {
  const tokenNumbers = req.params["id"];
  const snapshot = await admin
      .firestore()
      .collection("activeOrders")
      .where("tokenNumber", "==", parseInt(tokenNumbers))
      .get();
  if (snapshot.empty) {
    console.log("No matching documents.");
    return res.status(200).send("Error");
  }

  snapshot.forEach((doc) => {
    console.log(doc.id, "=>", doc.data());
    res.status(200).send(JSON.stringify(doc.data()));
  });
});

app.post("/", async (req, res) => {
  const user = req.body;
  await admin.firestore().collection("activeOrders").add(user);
  res.status(201).send();
});

exports.createUser = functions.firestore
    .document("billingDetails/{userID}")
    .onCreate((snap, context) => {
      const newValue = snap.data();
      console.log(newValue);
      axios
          .post(
              "https://us-central1-cloudfunctionsrestapi.cloudfunctions.net/widgets",
              newValue,
          )
          .then((res) => {
            console.log(`Status: ${res.status}`);
            console.log("Body: ", res.data);
          })
          .catch((err) => {
            console.error(err);
          });

      // app.get("/", (req, res) => res.send(newValue));

    // app.get("/:id", (req, res) => res.send(Widgets.getById(req.params.id)));
    });

exports.widgets = functions.https.onRequest(app);
