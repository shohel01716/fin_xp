import 'dart:async';

import 'package:fin_xp/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
            ()=> Get.to(LoginScreen()
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child:Padding(
          padding: const EdgeInsets.symmetric(horizontal:75),
          child: Image.asset("assets/images/logo.png", fit: BoxFit.contain,),
        )
    );
  }
}