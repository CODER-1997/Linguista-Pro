import 'package:linguista_ios/screens/admin/admin_home_screen.dart';
import 'package:linguista_ios/screens/auth/login.dart';
import 'package:linguista_ios/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
 import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:linguista_ios/screens/splash/intro_screen.dart';


import 'firebase_options.dart';



void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        canvasColor: Colors.white,
        applyElevationOverlayColor: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.transparent),
        useMaterial3: true,
      ),
      home:   MyHomePage(title: 'Teachers app'),
    );
  }
}

class MyHomePage extends StatelessWidget {
    MyHomePage({super.key, required this.title});

  final String title;

  var box = GetStorage();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: box.read('isLogged') == null
            ? box.read('isIntroduced') == null ?IntroScreen():  Login()
            : (box.read('isLogged') == 'Linguista9' ? AdminHomeScreen():HomeScreen()),
      ),
    );
  }
}
