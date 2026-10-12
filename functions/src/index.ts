import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

admin.initializeApp();

export const sendNotification =
functions.https.onCall(
  async (data: any, context: any) => {

    try {

      await admin.messaging().send({

        token: data.token,

        notification: {
          title: data.title,
          body: data.body,
        },

        android: {
          priority: "high",
        },
      });

      return {
        success: true,
      };

    } catch (e) {

      console.error(
        "NOTIFICATION ERROR",
        e,
      );

      return {
        success: false,
      };
    }
  },
);