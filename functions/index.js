const { onRequest } = require("firebase-functions/v2/https");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");
const { RecaptchaEnterpriseServiceClient } = require("@google-cloud/recaptcha-enterprise");
const admin = require("firebase-admin");
const axios = require("axios");
const cors = require("cors")({ origin: true });

admin.initializeApp();

// Explicitly connect to Firestore emulator if running in emulator environment
if (process.env.FUNCTIONS_EMULATOR && process.env.FIRESTORE_EMULATOR_HOST) {
  console.log(`Functions emulator detected. Connecting to Firestore emulator at ${process.env.FIRESTORE_EMULATOR_HOST}`);
}

const db = getFirestore("memreps");
let recaptchaClient;

async function verifyRecaptchaToken(token) {
  // If running in the Firebase Functions emulator, bypass reCAPTCHA verification.
  if (process.env.FUNCTIONS_EMULATOR) {
    console.log("Functions emulator detected. Bypassing reCAPTCHA verification.");
    return { valid: true, score: 1.0 };
  }

  if (!recaptchaClient) {
    recaptchaClient = new RecaptchaEnterpriseServiceClient();
  }

  const projectId = process.env.GCLOUD_PROJECT || process.env.GOOGLE_CLOUD_PROJECT;
  if (!projectId) {
    console.error("GCLOUD_PROJECT environment variable is not set.");
    return { valid: false, score: 0, reason: "Missing project ID on server" };
  }

  const siteKey = "6Lf07s4sAAAAALoVLAHH-cTu37py7XhutcCPsFUR";
  const projectPath = recaptchaClient.projectPath(projectId);

  const request = {
    assessment: {
      event: {
        token: token,
        siteKey: siteKey,
      },
    },
    parent: projectPath,
  };

  try {
    const [response] = await recaptchaClient.createAssessment(request);

    if (!response.tokenProperties || !response.tokenProperties.valid) {
      const reason = response.tokenProperties 
        ? response.tokenProperties.invalidReason 
        : "Unknown verification failure";
      console.warn(`reCAPTCHA token invalid. Reason: ${reason}`);
      return { valid: false, score: 0, reason };
    }

    if (response.tokenProperties.action !== 'onboarding') {
      console.warn(`reCAPTCHA action mismatch: expected 'onboarding', got '${response.tokenProperties.action}'`);
      return { valid: false, score: 0, reason: "Action mismatch" };
    }

    const score = response.riskAnalysis ? response.riskAnalysis.score : 0;
    console.log(`reCAPTCHA assessment success. Score: ${score}`);
    return { valid: true, score };
  } catch (error) {
    console.error("Error creating reCAPTCHA assessment:", error);
    return { valid: false, score: 0, reason: error.message };
  }
}

function parseRequestBody(req) {
  if (!req.body) return {};
  if (typeof req.body === "string") {
    try {
      return JSON.parse(req.body);
    } catch (e) {
      return {};
    }
  }
  if (Buffer.isBuffer(req.body)) {
    try {
      return JSON.parse(req.body.toString("utf8"));
    } catch (e) {
      return {};
    }
  }
  return req.body;
}

exports.syncProfile = onRequest({ cors: true }, async (req, res) => {
  const body = parseRequestBody(req);
  const { uuid, firstName, language, legislatureId, legislatureName, recaptchaToken } = body;
  
  if (!uuid || !firstName) {
    res.status(400).send("Missing required fields");
    return;
  }

  try {
    const docRef = db.collection("users").doc(uuid);
    const docSnap = await docRef.get();

    // Enforce reCAPTCHA token verification only for new profiles
    if (!docSnap.exists) {
      if (!recaptchaToken) {
        console.warn(`Registration blocked: Missing reCAPTCHA token for new user ${uuid}`);
        res.status(400).send("Missing reCAPTCHA token verification");
        return;
      }

      const verification = await verifyRecaptchaToken(recaptchaToken);
      if (!verification.valid || verification.score < 0.5) {
        console.warn(`Registration blocked: reCAPTCHA verification failed for new user ${uuid}. Reason: ${verification.reason || 'Low score'}`);
        res.status(403).send("reCAPTCHA verification failed");
        return;
      }
    }

    await docRef.set({
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
  const body = parseRequestBody(req);
  const { userUuid, userName, legislatureId, legislatureName, quizModeId, filterPercentage, scorePercentage } = body;
  
  if (!userUuid || scorePercentage === undefined) {
    res.status(400).send("Missing required fields");
    return;
  }

  try {
    await db.collection("quiz_results").add({
      userUuid: userUuid || "",
      userName: userName || "Anonymous",
      legislatureId: legislatureId || 1,
      legislatureName: legislatureName || "",
      quizModeId: quizModeId || "final_test",
      filterPercentage: typeof filterPercentage === "number" ? filterPercentage : 1.0,
      scorePercentage: typeof scorePercentage === "number" ? scorePercentage : 0.0,
      timestamp: FieldValue.serverTimestamp(),
    });

    res.status(200).send({ success: true });
  } catch (error) {
    console.error("Error syncing quiz result:", error.message);
    res.status(500).send("Error syncing quiz result");
  }
});

exports.getLeaderboard = onRequest({ cors: true }, async (req, res) => {
  const body = parseRequestBody(req);
  const { legislatureId, quizModeId } = body;
  
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

    // Query by quizModeId and filter legislatureId in memory to handle numeric vs string IDs while strictly isolating per legislature
    const snapshot = await db.collection("quiz_results")
      .where("quizModeId", "==", quizModeId)
      .get();

    if (snapshot.empty) {
      res.status(200).send({ leaderboard: [] });
      return;
    }

    const userStats = {};

    snapshot.forEach(doc => {
      const data = doc.data();
      
      // Strict Legislature isolation (e.g. House of Commons ID 1 vs Alberta ID 2)
      if (data.legislatureId != legId && String(data.legislatureId) !== String(legId)) return;

      // Filter by percentage (>= 20%)
      if (data.filterPercentage < 0.2) return;
      
      // Filter by timestamp (last 7 days)
      if (data.timestamp) {
        const ts = data.timestamp.toDate();
        if (ts < oneWeekAgo) return;
      }

      const rawName = (data.userName || "").trim();
      const nameKey = rawName ? rawName.toLowerCase() : (data.userUuid || "anonymous");
      const displayName = rawName || "Anonymous";

      if (!userStats[nameKey]) {
        userStats[nameKey] = { name: displayName, totalScore: 0, count: 0 };
      } else {
        // If existing name is lowercase and new entry has proper casing, update display name
        if (userStats[nameKey].name === userStats[nameKey].name.toLowerCase() && displayName !== displayName.toLowerCase()) {
          userStats[nameKey].name = displayName;
        }
      }
      userStats[nameKey].totalScore += data.scorePercentage;
      userStats[nameKey].count += 1;
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

exports.getUsersSummary = onRequest({ cors: true }, async (req, res) => {
  try {
    const snapshot = await db.collection("quiz_results").get();
    
    if (snapshot.empty) {
      res.status(200).send({ users: [] });
      return;
    }

    const userLastSeen = {};

    snapshot.forEach(doc => {
      const data = doc.data();
      const rawName = (data.userName || "Anonymous").trim();
      const uuid = data.userUuid || "unknown";

      let tsIso = null;
      if (data.timestamp && typeof data.timestamp.toDate === "function") {
        tsIso = data.timestamp.toDate().toISOString();
      }

      if (!userLastSeen[rawName]) {
        userLastSeen[rawName] = {
          userName: rawName,
          userUuid: uuid,
          lastSubmitted: tsIso,
          quizModeId: data.quizModeId,
          totalSubmissions: 1
        };
      } else {
        userLastSeen[rawName].totalSubmissions += 1;
        if (tsIso && (!userLastSeen[rawName].lastSubmitted || tsIso > userLastSeen[rawName].lastSubmitted)) {
          userLastSeen[rawName].lastSubmitted = tsIso;
          userLastSeen[rawName].quizModeId = data.quizModeId;
        }
      }
    });

    const users = Object.values(userLastSeen).sort((a, b) => {
      if (!a.lastSubmitted) return 1;
      if (!b.lastSubmitted) return -1;
      return b.lastSubmitted.localeCompare(a.lastSubmitted);
    });

    res.status(200).send({ users });
  } catch (error) {
    console.error("Error fetching users summary:", error);
    res.status(500).send("Error fetching users summary");
  }
});

function removeAccents(str) {
  // Removes diacritics while preserving base characters
  return str.normalize("NFD").replace(/[\u0300-\u036f]/g, "");
}

exports.proxyImage = onRequest({ cors: true }, async (req, res) => {
  const imageUrl = req.query.url;
  if (!imageUrl) {
    res.status(400).send("Missing url parameter");
    return;
  }

  const fetchImage = async (url) => {
    return await axios.get(url, {
      responseType: "arraybuffer",
      headers: {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
      }
    });
  };

  try {
    let response;
    try {
      response = await fetchImage(imageUrl);
    } catch (error) {
      // If failed, try stripping accents as a fallback (common for Canadian govt sites)
      const nonAccentedUrl = removeAccents(imageUrl);
      if (nonAccentedUrl !== imageUrl) {
        console.log(`Retrying with non-accented URL: ${nonAccentedUrl}`);
        response = await fetchImage(nonAccentedUrl);
      } else {
        throw error;
      }
    }

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
