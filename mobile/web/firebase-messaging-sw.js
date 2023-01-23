importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

const firebaseConfig = {
    apiKey: "AIzaSyCUS7BPyBvhVRGB8gUsHYMOGkxqChLQZyQ",
    authDomain: "plantmonitor-ec8fe.firebaseapp.com",
    databaseURL: "https://plantmonitor-ec8fe-default-rtdb.firebaseio.com",
    projectId: "plantmonitor-ec8fe",
    storageBucket: "plantmonitor-ec8fe.appspot.com",
    messagingSenderId: "241290221299",
    appId: "1:241290221299:web:b0e3a93ff7f59810ebc986"
};

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});