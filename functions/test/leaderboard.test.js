const assert = require("assert");

function calculateLeaderboard(docs, oneWeekAgo) {
  const userStats = {};

  docs.forEach(data => {
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
  { userUuid: "phone-uuid", userName: "Gavin", filterPercentage: 1.0, scorePercentage: 0.8, timestamp: now },
  { userUuid: "laptop-uuid", userName: "Gavin", filterPercentage: 1.0, scorePercentage: 1.0, timestamp: now },
  { userUuid: "other-uuid", userName: "Alice", filterPercentage: 1.0, scorePercentage: 0.9, timestamp: now }
];

const result1 = calculateLeaderboard(docs1, new Date(now - 7 * 86400 * 1000));
console.log("Test 1 Result:", result1);

assert.strictEqual(result1.length, 2, "Leaderboard should have 2 distinct users (Gavin and Alice)");
assert.strictEqual(result1[0].name, "Gavin");
assert.strictEqual(result1[0].averageScore, 0.9);
assert.strictEqual(result1[1].name, "Alice");
assert.strictEqual(result1[1].averageScore, 0.9);

// Test 2: Case insensitivity and whitespace trimming ("gavin", " Gavin ")
const docs2 = [
  { userUuid: "phone-uuid", userName: "gavin", filterPercentage: 1.0, scorePercentage: 0.7, timestamp: now },
  { userUuid: "laptop-uuid", userName: " Gavin ", filterPercentage: 1.0, scorePercentage: 0.9, timestamp: now },
];

const result2 = calculateLeaderboard(docs2, new Date(now - 7 * 86400 * 1000));
console.log("Test 2 Result:", result2);

assert.strictEqual(result2.length, 1, "Leaderboard should have 1 entry for Gavin");
assert.strictEqual(result2[0].name, "Gavin", "Should prefer capitalized display name");
assert.strictEqual(result2[0].averageScore, 0.8);

console.log("All leaderboard tests passed successfully!");
