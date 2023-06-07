import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grad_gg/main_page.dart';
import 'package:grad_gg/screen/login_screen.dart';
import 'package:grad_gg/screen/profile_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  //initailzied Firebase App
  Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainPage(),
      routes: {
        '/loginPage': (context) => const LoginScreen(),
        '/profilePage': (context) => const ProfileScreen(),
      },
    );
  }
}
