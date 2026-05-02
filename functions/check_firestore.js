const { getFirestore } = require("firebase-admin/firestore");
const admin = require("firebase-admin");

if (!admin.apps.length) {
  admin.initializeApp({
    projectId: 'openclaw-bot-486015'
  });
}

const db = getFirestore("memreps");

async function checkDoc() {
  try {
    const docRef = db.collection('quiz_results').doc('2uaz3z0x3HcyPbHaPGPf');
    const doc = await docRef.get();
    if (!doc.exists) {
      console.log('Document not found in memreps database.');
      // List a few documents to see what's there
      const list = await db.collection('quiz_results').limit(5).get();
      console.log('Listing 5 documents in quiz_results:');
      list.forEach(d => {
        console.log(d.id, '=>', JSON.stringify(d.data()));
      });
    } else {
      console.log('Document data:');
      const data = doc.data();
      console.log(JSON.stringify(data, null, 2));
      console.log('Type of legislatureId:', typeof data.legislatureId);
      console.log('Type of quizModeId:', typeof data.quizModeId);
      console.log('Type of filterPercentage:', typeof data.filterPercentage);
      console.log('Type of timestamp:', data.timestamp ? data.timestamp.constructor.name : 'null');
    }
  } catch (e) {
    console.error('Error:', e.message);
  }
}

checkDoc();
