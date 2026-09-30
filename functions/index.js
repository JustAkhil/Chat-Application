const {setGlobalOptions} = require("firebase-functions");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");

admin.initializeApp();

setGlobalOptions({maxInstances: 10});

exports.sendChatNotification = onDocumentCreated(
    "chatroom/{chatId}/messages/{messageId}",
    async (event) => {
      const snapshot = event.data;

      if (!snapshot) {
        return null;
      }

      const messageData = snapshot.data();
      const receiverId = messageData.receiverId;

      if (!receiverId) {
        console.log("receiverId is missing from message:", messageData);
        return null;
      }

      const userDoc = await admin
          .firestore()
          .collection("users")
          .doc(receiverId)
          .get();

      if (!userDoc.exists) {
        return null;
      }

      const fcmToken = userDoc.data().fcmToken;

      if (!fcmToken) {
        return null;
      }

      const payload = {
        notification: {
          title: messageData.senderName || "New Message",
          body: messageData.text || "Sent an attachment",
        },
        data: {
          chatId: event.params.chatId,
          senderId: messageData.senderId,
        },
        token: fcmToken,
      };

      return admin.messaging().send(payload);
    },
);
