const { onRequest } = require("firebase-functions/v2/https");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");
const admin = require("firebase-admin");
const axios = require("axios");
const cors = require("cors")({ origin: true });

admin.initializeApp();
const db = getFirestore("memreps");

exports.syncProfile = onRequest({ cors: true }, async (req, res) => {
  const { uuid, firstName, language, lastLegislatureId } = req.body;
  
  if (!uuid || !firstName) {
    res.status(400).send("Missing required fields");
    return;
  }

  try {
    await db.collection("users").doc(uuid).set({
      firstName,
      language,
      lastLegislatureId,
      createdAt: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp(),
    }, { merge: true });

    res.status(200).send({ success: true });
  } catch (error) {
    console.error("Error syncing profile:", error.message);
    res.status(500).send("Error syncing profile");
  }
});

exports.syncQuizResult = onRequest({ cors: true }, async (req, res) => {
  const { userUuid, userName, legislatureName, quizModeId, filterPercentage, scorePercentage } = req.body;
  
  if (!userUuid || scorePercentage === undefined) {
    res.status(400).send("Missing required fields");
    return;
  }

  try {
    await db.collection("quiz_results").add({
      userUuid,
      userName,
      legislatureName,
      quizModeId,
      filterPercentage,
      scorePercentage,
      timestamp: FieldValue.serverTimestamp(),
    });

    res.status(200).send({ success: true });
  } catch (error) {
    console.error("Error syncing quiz result:", error.message);
    res.status(500).send("Error syncing quiz result");
  }
});

exports.proxyImage = onRequest({ cors: true }, async (req, res) => {
  const imageUrl = req.query.url;
  if (!imageUrl) {
    res.status(400).send("Missing url parameter");
    return;
  }

  try {
    const response = await axios.get(imageUrl, {
      responseType: "arraybuffer",
      headers: {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
      }
    });

    const contentType = response.headers["content-type"];
    res.setHeader("Content-Type", contentType);
    res.setHeader("Cache-Control", "public, max-age=86400"); // Cache for 24 hours
    res.send(response.data);
  } catch (error) {
    console.error("Error proxying image:", error.message);
    res.status(500).send("Error fetching image");
  }
});
