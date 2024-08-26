import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'screens/Splash.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set the background messaging handler early on
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Care Service',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Splash(),
    );
  }
}

// Colors
const primary = Color(0xFFEBE9FC);
const kWhiteColor = Color(0xFFEBE9FC);
const grey = Colors.grey;
const white = Color(0xFFFFFFFF);
const black = Color(0xFF000000);
const online = Color(0xFF66BB6A);
const pupple = Colors.purpleAccent;
const blue_story = Colors.blueAccent;
Color kPrimaryColor = Colors.blue.shade900;
Color kSecondaryColor = Color(0xFFF2F2F2);
Color kGreyColor = Color(0xFF888888);
