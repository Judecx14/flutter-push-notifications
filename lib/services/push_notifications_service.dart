//SHA - 1: 73:F5:A0:50:EE:82:7F:B3:62:6B:BB:2B:5C:7E:08:86:AF:03:6C:43

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  //El stream es como un miniservicio
  static final StreamController<String> _messageStreamController =
      StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStreamController.stream;

  //Cuando se salio de la app pero no la cerro
  static Future<void> _backgroundHandler(RemoteMessage message) async {
    /* print("onbackground Handler ${message.messageId}"); */
    //El stream guarda el valor que viene del argumento message
    //que viene de la notificacion
    /*  _messageStreamController.add(message.notification?.title ?? "No title");
    _messageStreamController.add(message.notification?.body ?? "No body"); */
    _messageStreamController.add(message.data['producto'] ?? "No data");
  }

  //Cuando esta dentro de la app
  static Future<void> _onMessageHandler(RemoteMessage message) async {
    /* print("onMessage Handler ${message.messageId}"); */
    //print("on Message data  ${message.data}");

    /* _messageStreamController.add(message.notification?.title ?? "No title");
    _messageStreamController.add(message.notification?.body ?? "No body"); */
    _messageStreamController.add(message.data['producto'] ?? "No data");
  }

  //Cuando abre la notificacion
  static Future<void> _onMessageOpenApp(RemoteMessage message) async {
    //print("on Message Open App ${message.messageId}");
    /* _messageStreamController.add(message.notification?.title ?? "No title");
    _messageStreamController.add(message.notification?.body ?? "No body"); */
    _messageStreamController.add(message.data['producto'] ?? "No data");
  }

  static Future initializeApp() async {
    //Push notificaciones
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print("Token: $token");
    //Local notifiaciones
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  //Es necesario cerrar el stream
  static closeStreams() {
    _messageStreamController.close();
  }
}
