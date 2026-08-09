const assert = require("assert");

function calculateLeaderboard(docs, targetLegId, oneWeekAgo) {
  const userStats = {};
  const legId = (typeof targetLegId === 'string' && !isNaN(targetLegId)) 
    ? parseInt(targetLegId) 
    : targetLegId;

  docs.forEach(data => {
    // Strict Legislature isolation (e.g. House of Commons ID 1 vs Alberta ID 2)
    if (data.legislatureId != legId && String(data.legislatureId) !== String(legId)) return;

    // Filter by percentage (>= 20%)
    if (data.filterPercentage < 0.2) return;
    
    // Filter by timestamp (last 7 days)
    if (data.timestamp) {
      if (data.timestamp < oneWeekAgo) return;
    }

    const rawName = (data.userName || "").trim();
    const nameKey = rawName ? rawName.toLowerCase() : (data.userUuid || "anonymous");
    const displayName = rawName || "Anonymous";

    if (!userStats[nameKey]) {
      userStats[nameKey] = { name: displayName, totalScore: 0, count: 0 };
    } else {
      if (userStats[nameKey].name === userStats[nameKey].name.toLowerCase() && displayName !== displayName.toLowerCase()) {
        userStats[nameKey].name = displayName;
      }
    }
    userStats[nameKey].totalScore += data.scorePercentage;
    userStats[nameKey].count += 1;
  });

  return Object.values(userStats)
    .map(stats => ({
      name: stats.name,
      averageScore: stats.totalScore / stats.count
    }))
    .sort((a, b) => b.averageScore - a.averageScore)
    .slice(0, 10);
}

// Test 1: Grouping results from phone and laptop with same name "Gavin"
const now = new Date();
const docs1 = [
  { userUuid: "phone-uuid", userName: "Gavin", legislatureId: 1, filterPercentage: 1.0, scorePercentage: 0.8, timestamp: now },
  { userUuid: "laptop-uuid", userName: "Gavin", legislatureId: 1, filterPercentage: 1.0, scorePercentage: 1.0, timestamp: now },
  { userUuid: "other-uuid", userName: "Alice", legislatureId: 1, filterPercentage: 1.0, scorePercentage: 0.9, timestamp: now }
];

const result1 = calculateLeaderboard(docs1, 1, new Date(now - 7 * 86400 * 1000));
console.log("Test 1 Result:", result1);

assert.strictEqual(result1.length, 2, "Leaderboard should have 2 distinct users (Gavin and Alice)");
assert.strictEqual(result1[0].name, "Gavin");
assert.strictEqual(result1[0].averageScore, 0.9);
assert.strictEqual(result1[1].name, "Alice");
assert.strictEqual(result1[1].averageScore, 0.9);

// Test 2: Case insensitivity and whitespace trimming ("gavin", " Gavin ")
const docs2 = [
  { userUuid: "phone-uuid", userName: "gavin", legislatureId: 1, filterPercentage: 1.0, scorePercentage: 0.7, timestamp: now },
  { userUuid: "laptop-uuid", userName: " Gavin ", legislatureId: 1, filterPercentage: 1.0, scorePercentage: 0.9, timestamp: now },
];

const result2 = calculateLeaderboard(docs2, 1, new Date(now - 7 * 86400 * 1000));
console.log("Test 2 Result:", result2);

assert.strictEqual(result2.length, 1, "Leaderboard should have 1 entry for Gavin");
assert.strictEqual(result2[0].name, "Gavin", "Should prefer capitalized display name");
assert.strictEqual(result2[0].averageScore, 0.8);

// Test 3: Strict isolation across different legislatures (e.g. House of Commons ID 1 vs Alberta ID 2)
const docs3 = [
  { userUuid: "guy-pc", userName: "Guy", legislatureId: 1, filterPercentage: 1.0, scorePercentage: 1.0, timestamp: now }, // House of Commons
  { userUuid: "guy-phone", userName: "Guy", legislatureId: 1, filterPercentage: 1.0, scorePercentage: 0.9, timestamp: now }, // House of Commons
  { userUuid: "guy-ab", userName: "Guy", legislatureId: 2, filterPercentage: 1.0, scorePercentage: 0.2, timestamp: now }, // Alberta
];

const resultHouseOfCommons = calculateLeaderboard(docs3, 1, new Date(now - 7 * 86400 * 1000));
console.log("Test 3 Result (House of Commons ID 1):", resultHouseOfCommons);
assert.strictEqual(resultHouseOfCommons.length, 1);
assert.strictEqual(resultHouseOfCommons[0].name, "Guy");
assert.strictEqual(resultHouseOfCommons[0].averageScore, 0.95, "Guy's House of Commons score should be (1.0 + 0.9)/2 = 0.95 and NOT include Alberta score");

const resultAlberta = calculateLeaderboard(docs3, 2, new Date(now - 7 * 86400 * 1000));
console.log("Test 3 Result (Alberta ID 2):", resultAlberta);
assert.strictEqual(resultAlberta.length, 1);
assert.strictEqual(resultAlberta[0].name, "Guy");
assert.strictEqual(resultAlberta[0].averageScore, 0.2, "Guy's Alberta score should be 0.2 and NOT include House of Commons scores");

console.log("All leaderboard tests passed successfully!");
