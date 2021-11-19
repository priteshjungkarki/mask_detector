import 'package:flutter/material.dart';
import 'package:mask_detector/homepage.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplashScreen extends StatefulWidget {
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 10,
      backgroundColor: Colors.white,
      loaderColor: Colors.black,
      photoSize: 130,
      navigateAfterSeconds: HomePage(),
      image: Image.asset('assets/images/splash.png'),
      title: Text(
        'Face Mask Detector App',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Colors.black,
        ),
      ),
      loadingText: Text(
        'from coding cafe',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
