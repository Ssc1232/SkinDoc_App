import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:skindoc/dbmanager.dart';
import 'package:skindoc/homepage.dart';
import 'package:skindoc/resultpage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp firebaseApp = await Firebase.initializeApp(
    name: "SkinDoc",
    options: const FirebaseOptions(
        apiKey: "AIzaSyCl4PToNXp4OlIpfvoQ6cxxjoqn06JIggo",
        authDomain: "skindoc-6d2ab.firebaseapp.com",
        databaseURL: "https://skindoc-6d2ab-default-rtdb.firebaseio.com",
        projectId: "skindoc-6d2ab",
        storageBucket: "skindoc-6d2ab.appspot.com",
        messagingSenderId: "179746611835",
        appId: "1:179746611835:web:07cfa4baf7a598311fb8de",
        measurementId: "G-FP0DMTE6ES"),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  MaterialColor buildMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: buildMaterialColor(Color(0xff7253B9))),
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
          splash: Image.asset("assets/splash_icon.png"),
          backgroundColor: Color(0xff898DD4),
          duration: 2000,
          splashIconSize: 150,
          splashTransition: SplashTransition.scaleTransition,
          nextScreen: ImagePickerApp()),
    );
  }
}
