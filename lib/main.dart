import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:game_recommend/pages/authPage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
      title: 'GAME RECOMMEND APP',
      theme: ThemeData(
    
        primaryColor: Colors.black, // Set the primary color to black
        hintColor: Colors.pink[900], // Set the accent color to dark pink
      ),
      home: const authPage(),
    );
  }
}
