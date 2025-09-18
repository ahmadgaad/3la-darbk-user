import 'package:ala_darbak_user/core/utils/notification/local_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotifications {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static init() async {
    
    await FirebaseMessaging.instance
        .requestPermission(sound: true, badge: true, alert: true)
        .then((settings) =>
            print("Settings registered: ${settings.authorizationStatus}"));
  }

  static listen() {
   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("On Message : ${message.data}");
      var id = message.data["id"];
      _showLocalNotification(id, message.notification);
    });
    firebaseMessaging.getInitialMessage().then((message) {
      print("Initial Message : ${message?.data}");
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("On Message Opened App : ${message.data}");
    });
  }
  static _showLocalNotification(
    id,
    RemoteNotification? message,
  ) async {
    if (message != null) {
      final title = message.title;
      final body = message.body;
      if ((title != null && title.isNotEmpty) ||
          (body != null && body.isNotEmpty)) {
        await LocalNotifications.show(
          id: int.tryParse(id.toString()) ?? 100,
          title: title ?? "",
          body: body ?? "",
        );
      }
    }
  }


  static Future<String?> token() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      print("FCM Token ===========>");
      print(token);
      return token;
    } catch (e) {
      print(e);
      return null;
    }
  }

}
