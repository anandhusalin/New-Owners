import 'dart:convert';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_chat/firebase_chat.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fuodz/constants/app_routes.dart';
import 'package:fuodz/models/notification.dart';
import 'package:fuodz/models/order.dart';
import 'package:fuodz/services/app.service.dart';
import 'package:fuodz/services/notification.service.dart';
import 'package:singleton/singleton.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/translations/order_details.i18n.dart';

class FirebaseService {
  //
  /// Factory method that reuse same instance automatically
  factory FirebaseService() =>
      Singleton.lazy(() => FirebaseService._()).instance;

  /// Private constructor
  FirebaseService._() {}

  //
  NotificationModel notificationModel;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  dynamic notificationPayloadData;

  setUpFirebaseMessaging() async {
    //Request for notification permission
    /*NotificationSettings settings = */
    await firebaseMessaging.requestPermission();
    //subscribing to all topic
    firebaseMessaging.subscribeToTopic("all");

    //on notification tap tp bring app back to life
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      saveNewNotification(message);
      selectNotification("From onMessageOpenedApp");
    });

    //normal notification listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      saveNewNotification(message);
      showNotification(message);
    });
  }

  //write to notification list
  saveNewNotification(RemoteMessage message, {String title, String body}) {
    //
    notificationPayloadData = message != null ? message.data : null;
    if (message?.notification == null &&
        message?.data != null &&
        message?.data["title"] == null &&
        title == null) {
      return;
    }
    //Saving the notification
    notificationModel = NotificationModel();
    notificationModel.title =
        message?.notification?.title ?? title ?? message?.data["title"] ?? "";
    notificationModel.body =
        message?.notification?.body ?? body ?? message?.data["body"] ?? "";
    notificationModel.timeStamp = DateTime.now().millisecondsSinceEpoch;

    //add to database/shared pref
    NotificationService.addNotification(notificationModel);
  }

  //
  showNotification(RemoteMessage message) async {
    if (message.notification == null && message.data["title"] == null) {
      return;
    }

    //
    notificationPayloadData = message.data;

    //
    try {
      //
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: Random().nextInt(20),
          channelKey: NotificationService.appNotificationChannel().channelKey,
          title: message.data["title"] ?? message.notification.title,
          body: message.data["body"] ?? message.notification.body,
          icon: "resource://drawable/notification_icon",
          notificationLayout: NotificationLayout.Default,
          payload: Map<String,String>.from(message.data)
        ),
      );

      ///
    } catch (error) {
      print("Notification Show error ===> ${error}");
    }
  }

  //handle on notification selected
  Future selectNotification(String payload) async {
    if (payload == null) {
      return;
    }
    try {
      //
      final isChat = notificationPayloadData != null &&
          notificationPayloadData["is_chat"] != null;
      final isOrder = notificationPayloadData != null &&
          notificationPayloadData["is_order"] != null;
      //
      if (isChat) {
        //
        dynamic user = jsonDecode(notificationPayloadData['user']);
        dynamic peer = jsonDecode(notificationPayloadData['peer']);
        String chatPath = notificationPayloadData['path'];
        //
        Map<String, PeerUser> peers = {
          '${user['id']}': PeerUser(
            id: '${user['id']}',
            name: "${user['name']}",
            image: "${user['photo']}",
          ),
          '${peer['id']}': PeerUser(
            id: '${peer['id']}',
            name: "${peer['name']}",
            image: "${peer['photo']}",
          ),
        };
        //
        final peerRole = peer["role"];
        //
        final chatEntity = ChatEntity(
          mainUser: peers['${user['id']}'],
          peers: peers,
          //don't translate this
          path: chatPath,
          title: peer["role"] == null
              ? "Chat with".i18n + " ${peer['name']}"
              : peerRole == 'vendor'
                  ? "Chat with vendor".i18n
                  : "Chat with driver".i18n,
        );
        AppService().navigatorKey.currentContext.navigator.pushNamed(
              AppRoutes.chatRoute,
              arguments: chatEntity,
            );
      }
      //order
      else if (isOrder) {
        //
        final order = Order(
          id: int.parse(notificationPayloadData['order_id'].toString()),
        );
        //
        AppService().navigatorKey.currentContext.navigator.pushNamed(
              AppRoutes.orderDetailsRoute,
              arguments: order,
            );
      }
      //regular notifications
      else {
        AppService().navigatorKey.currentContext.navigator.pushNamed(
            AppRoutes.notificationDetailsRoute,
            arguments: notificationModel);
      }
    } catch (error) {
      print("Error opening Notification ==> $error");
    }
  }
}
