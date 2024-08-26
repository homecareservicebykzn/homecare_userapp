import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'Home.dart';
import 'package:shared_preferences/shared_preferences.dart'; // for caching token


class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  bool position = false;
  var opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Initialize Firebase Messaging
    // _initializeFirebaseMessaging();

    // Start the animation
    Future.delayed(Duration.zero, () {
      animator();
    });
  }

  // void _initializeFirebaseMessaging() async {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //
  //   // Request permission for iOS
  //   await messaging.requestPermission(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );
  //
  //   // Check if token is already cached
  //   String? token = await _getCachedToken();
  //   if (token == null) {
  //     try {
  //       // Get the device token and cache it
  //       token = await messaging.getToken();
  //       print("FirebaseMessaging token: $token");
  //       _cacheToken(token);
  //     } catch (e) {
  //       print("Error getting Firebase Messaging token: $e");
  //       // Optionally implement retry logic here with exponential backoff
  //     }
  //   } else {
  //     print("Using cached FirebaseMessaging token: $token");
  //   }
  //
  //   // Handle foreground messages
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     if (message.notification != null) {
  //       _showNotificationDialog(
  //         title: message.notification!.title,
  //         body: message.notification!.body,
  //       );
  //     }
  //   });
  //
  //   // Handle messages when the app is opened from a notification
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     print('A new onMessageOpenedApp event was published!');
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => HomePage()),
  //     );
  //   });
  // }

  Future<void> _cacheToken(String? token) async {
    // Save the token to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('firebase_token', token ?? '');
  }

  Future<String?> _getCachedToken() async {
    // Retrieve the token from local storage
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('firebase_token');
  }

  void _showNotificationDialog({String? title, String? body}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title ?? "Notification"),
        content: Text(body ?? "You have received a new message."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  animator() async {
    if (opacity == 0) {
      opacity = 1;
      position = true;
    } else {
      opacity = 0;
      position = false;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              top: position ? 60 : 150,
              left: 20,
              right: 20,
              child: AnimatedOpacity(
                opacity: opacity,
                duration: const Duration(milliseconds: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    TextWidget("Complete", 35, Colors.black, FontWeight.bold,
                        letterSpace: 5),
                    const SizedBox(height: 5),
                    TextWidget("Health", 35, Colors.black, FontWeight.bold,
                        letterSpace: 5),
                    const SizedBox(height: 5),
                    TextWidget("Solution", 35, Colors.black, FontWeight.bold,
                        letterSpace: 5),
                    const SizedBox(height: 20),
                    TextWidget("Early Protection for\nFamily Health", 18,
                        Colors.black.withOpacity(.7), FontWeight.bold),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              bottom: 0,
              left: position ? 50 : 150,
              duration: const Duration(milliseconds: 400),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: opacity,
                child: Container(
                  height: 510,
                  width: 405,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/nurseaid.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              bottom: 60,
              duration: const Duration(milliseconds: 400),
              left: position ? 20 : -100,
              child: InkWell(
                onTap: () {
                  position = false;
                  opacity = 0;
                  setState(() {});
                  Timer(const Duration(milliseconds: 400), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  });
                },
                child: AnimatedOpacity(
                  opacity: opacity,
                  duration: const Duration(milliseconds: 400),
                  child: Container(
                    width: 150,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: TextWidget(
                        "Get Started",
                        17,
                        Colors.white,
                        FontWeight.bold,
                        letterSpace: 0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Your custom TextWidget
class TextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final double letterSpace;

  const TextWidget(this.text, this.fontSize, this.color, this.fontWeight, {this.letterSpace = 0.0});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        letterSpacing: letterSpace,
      ),
    );
  }
}