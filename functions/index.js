const {setGlobalOptions} = require("firebase-functions");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");

admin.initializeApp();

setGlobalOptions({
  maxInstances: 10,
});

exports.sendChatNotification = onDocumentCreated(
    "chatroom/{chatId}/messages/{messageId}",
    async (event) => {
      const snapshot = event.data;

      if (!snapshot) {
        console.log("Message snapshot is missing");
        return null;
      }

      const messageData = snapshot.data();

      // Your Flutter MessageModel uses fromId and toId
      const senderId = messageData.fromId;
      const receiverId = messageData.toId;

      if (!senderId) {
        console.log("senderId (fromId) is missing");
        return null;
      }

      if (!receiverId) {
        console.log("receiverId (toId) is missing");
        return null;
      }

      console.log("Sender ID:", senderId);
      console.log("Receiver ID:", receiverId);

      const userDoc = await admin
          .firestore()
          .collection("users")
          .doc(receiverId)
          .get();

      if (!userDoc.exists) {
        console.log(
            "Receiver user not found:",
            receiverId,
        );
        return null;
      }

      const userData = userDoc.data();
      const fcmToken = userData && userData.fcmToken;

      if (!fcmToken) {
        console.log(
            `FCM token not found for receiverId: ${receiverId}. ` +
            "Ensure client app saves 'fcmToken' field in Firestore user doc.",
        );
        return null;
      }

      // Fetch sender details to display sender's name in notification
      let senderName = "New Message";
      try {
        const senderDoc = await admin
            .firestore()
            .collection("users")
            .doc(senderId)
            .get();
        if (senderDoc.exists && senderDoc.data() && senderDoc.data().name) {
          senderName = senderDoc.data().name;
        }
      } catch (err) {
        console.log("Error fetching sender profile:", err);
      }

      const payload = {
        notification: {
          title: senderName,
          body: messageData.msg || "Sent an attachment",
        },

        data: {
          chatId: String(event.params.chatId),
          senderId: String(senderId),
          receiverId: String(receiverId),
        },

        token: fcmToken,
      };

      try {
        const response = await admin
            .messaging()
            .send(payload);

        console.log(
            "Notification sent successfully:",
            response,
        );

        return response;
      } catch (error) {
        console.error(
            "Error sending notification:",
            error,
        );

        // Clean up invalid or expired FCM registration tokens
        if (
          error.code === "messaging/registration-token-not-registered" ||
          error.code === "messaging/invalid-registration-token"
        ) {
          console.log(`Removing stale FCM token for user: ${receiverId}`);
          await admin
              .firestore()
              .collection("users")
              .doc(receiverId)
              .update({
                fcmToken: admin.firestore.FieldValue.delete(),
              });
        }

        return null;
      }
    },
);
