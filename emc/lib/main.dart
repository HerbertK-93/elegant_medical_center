import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/auth/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase directly with your web config
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAFNerMX5qnVPCLxWe29IsInBoauvSIAkk",
      authDomain: "elegantmedicalcenter-bfba2.firebaseapp.com",
      projectId: "elegantmedicalcenter-bfba2",
      storageBucket: "elegantmedicalcenter-bfba2.appspot.com", // 👈 fixed
      messagingSenderId: "877260324568",
      appId: "1:877260324568:web:3225c188efe408c116e1ad",
    ),
  );

  runApp(const ElegantMedicalCenterApp());
}

class ElegantMedicalCenterApp extends StatelessWidget {
  const ElegantMedicalCenterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elegant Medical Center',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
