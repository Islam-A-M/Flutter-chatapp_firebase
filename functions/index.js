const functions = require('firebase-functions');
const admin = require('firebase-admin');
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
admin.initializeApp();
exports.myFunction= functions.firestore
.document('chat/{message}')
.onCreate((snapshot,context)=>{
    const check = admin.firestore().collection('users').doc(snapshot.data().userId).get();
    return check.then(user => {
        return admin.messaging().sendToTopic('chat',{notification:{title:user.data().username,body:snapshot.data().text,clickAction:'FLUTTER_NOTIFICATION_CLICK'}});
       
    }).catch(err => {
        console.log('Error getting document', err);
       // throw new functions.https.HttpsError('Error getting document', err);
    });



  
});
