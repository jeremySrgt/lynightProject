const functions = require('firebase-functions');
const admin = require('firebase-admin');
const algoliasearch = require('algoliasearch');

const ALGOLIA_APP_ID = "";
const ALGOLIA_ADMIN_KEY = "";
const ALGOLIA_INDEX_NAME = "";

admin.initializeApp(functions.config().firebase);

exports.addClubToAlgolia = functions.https.onRequest((req, res) => {

    var arr = [];

    admin.firestore().collection("club").get().then((docs) => {

        docs.forEach((doc) => {
            let club = doc.data();
            club.objectID = doc.id;
            arr.push(club);
        });

        var client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);
        var index = client.initIndex(ALGOLIA_INDEX_NAME);

        index.saveObjects(arr, function (err, content){
            res.status(200).send(content);
        });
    });

});



// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
