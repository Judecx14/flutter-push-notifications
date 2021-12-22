import 'package:flutter/material.dart';
import 'package:notificaciones/screens/home_screen.dart';
import 'package:notificaciones/screens/message_screen.dart';
import 'package:notificaciones/services/push_notifications_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationsService.initializeApp();
  runApp(MyApp());
}

//Convertimos el widget en un statefull porque necesitamos el
//init state
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  //Usamos el init state para poder obtener la informacion
  //de la notificacion antes de que inicie la primera pantalla
  @override
  void initState() {
    super.initState();
    //Aqui estamos escuchando la informacion que viene del stream
    //Que recibe de la notificacion
    PushNotificationsService.messagesStream.listen((message) {
      //print("MyApp: $message");
      final snackBar = SnackBar(content: Text(message));
      navigatorKey.currentState?.pushNamed('message', arguments: message);
      messengerKey.currentState?.showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      navigatorKey: navigatorKey, //Navegar
      scaffoldMessengerKey: messengerKey, //Snacks
      routes: {
        'home': (_) => HomeScreen(),
        'message': (_) => MessageScreen(),
      },
    );
  }
}
