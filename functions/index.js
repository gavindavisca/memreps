const { onRequest } = require("firebase-functions/v2/https");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");
const admin = require("firebase-admin");
const axios = require("axios");
const cors = require("cors")({ origin: true });

admin.initializeApp();

// Explicitly connect to Firestore emulator if running in emulator environment
if (process.env.FUNCTIONS_EMULATOR && process.env.FIRESTORE_EMULATOR_HOST) {
  console.log(`Functions emulator detected. Connecting to Firestore emulator at ${process.env.FIRESTORE_EMULATOR_HOST}`);
}

const db = getFirestore("memreps");

exports.syncProfile = onRequest({ cors: true }, async (req, res) => {
  const { uuid, firstName, language, legislatureId, legislatureName } = req.body;
  
  if (!uuid || !firstName) {
    res.status(400).send("Missing required fields");
    return;
  }

  try {
    await db.collection("users").doc(uuid).set({
      firstName,
      language,
      legislatureId,
      legislatureName,
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
  const { userUuid, userName, legislatureId, legislatureName, quizModeId, filterPercentage, scorePercentage } = req.body;
  
  if (!userUuid || scorePercentage === undefined) {
    res.status(400).send("Missing required fields");
    return;
  }

  try {
    await db.collection("quiz_results").add({
      userUuid,
      userName,
      legislatureId,
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

exports.getLeaderboard = onRequest({ cors: true }, async (req, res) => {
  const { legislatureId, quizModeId } = req.body;
  
  if (!legislatureId || !quizModeId) {
    res.status(400).send("Missing required filters");
    return;
  }

  try {
    const oneWeekAgo = new Date();
    oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);

    // Support both string and numeric IDs for legislatureId
    const legId = (typeof legislatureId === 'string' && !isNaN(legislatureId)) 
      ? parseInt(legislatureId) 
      : legislatureId;

    // Use only equality filters to avoid composite index requirements
    const snapshot = await db.collection("quiz_results")
      .where("legislatureId", "==", legId)
      .where("quizModeId", "==", quizModeId)
      .get();

    if (snapshot.empty) {
      res.status(200).send({ leaderboard: [] });
      return;
    }

    const userStats = {};

    snapshot.forEach(doc => {
      const data = doc.data();
      
      // Filter by percentage (>= 20%)
      if (data.filterPercentage < 0.2) return;
      
      // Filter by timestamp (last 7 days)
      if (data.timestamp) {
        const ts = data.timestamp.toDate();
        if (ts < oneWeekAgo) return;
      }

      const uuid = data.userUuid;
      if (!userStats[uuid]) {
        userStats[uuid] = { name: data.userName, totalScore: 0, count: 0 };
      }
      userStats[uuid].totalScore += data.scorePercentage;
      userStats[uuid].count += 1;
    });

    const leaderboard = Object.values(userStats)
      .map(stats => ({
        name: stats.name,
        averageScore: stats.totalScore / stats.count
      }))
      .sort((a, b) => b.averageScore - a.averageScore)
      .slice(0, 10);

    res.status(200).send({ leaderboard });
  } catch (error) {
    console.error("Error fetching leaderboard:", error);
    res.status(500).send("Error fetching leaderboard");
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
    res.setHeader("Cache-Control", "public, max-age=2592000, s-maxage=2592000"); // Cache for 30 days
    res.send(response.data);
  } catch (error) {
    console.error("Error proxying image:", error.message);
    res.status(500).send("Error fetching image");
  }
});

exports.proxyData = onRequest({ cors: true }, async (req, res) => {
  const url = req.query.url;
  if (!url) {
    res.status(400).send("Missing url parameter");
    return;
  }

  try {
    const response = await axios.get(url, {
      responseType: "arraybuffer",
      headers: {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
      }
    });

    const contentType = response.headers["content-type"];
    res.setHeader("Content-Type", contentType);
    res.send(response.data);
  } catch (error) {
    console.error("Error proxying data:", error.message);
    res.status(500).send("Error fetching data");
  }
});
