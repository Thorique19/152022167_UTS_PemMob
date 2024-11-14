import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:riqapp/login.dart';
import 'package:riqapp/splashscreen.dart'; // Pastikan ini sesuai dengan nama file SplashScreen Anda

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Inisialisasi binding
  await Firebase.initializeApp(); // Inisialisasi Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/', // Rute awal
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
