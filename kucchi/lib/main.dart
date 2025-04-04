import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kucchi/screens/auth.dart';
import 'package:kucchi/screens/dashboard.dart';
import 'package:kucchi/screens/kucchi.dart';
import 'package:kucchi/screens/insert.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyAF4Jtm-0m69KwDZRAKdmNmC-aijdf92tc",
          authDomain: "kucchi-1bdd0.firebaseapp.com",
          projectId: "kucchi-1bdd0",
          storageBucket: "kucchi-1bdd0.firebasestorage.app",
          messagingSenderId: "343367289205",
          appId: "1:343367289205:web:4dc94edf90fe21278eab3c",
          measurementId: "G-HY8CB39B5F"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/kuchulu',
      routes: {
        '/kuchulu': (context) => const Dashboard(),
        '/yup':(context) =>const Insert()
        },
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      
    );
  }
}
