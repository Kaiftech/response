import 'package:flutter/material.dart';
import 'package:response/login_page.dart';
import 'home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'registration_page.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(await MyApp.initialize()); // Use a static method to initialize the app
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.isUserSignedIn}) : super(key: key);

  static Future<MyApp> initialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isUserSignedIn = prefs.getBool('isUserSignedIn') ?? false;

    return MyApp(isUserSignedIn: isUserSignedIn);
  }

  final bool isUserSignedIn;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emergency response app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: isUserSignedIn ? '/home' : '/registration',
      routes: {
        '/registration': (context) => const RegistrationPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
