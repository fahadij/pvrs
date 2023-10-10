import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pvers_customer/MainScreens/main_screen.dart';
import 'package:pvers_customer/authentication/signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authentication/login_screen.dart';

class MySplashScreen extends StatefulWidget
{


  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}




class _MySplashScreenState extends State<MySplashScreen>

{

  startTimer(){
    Timer(const Duration(seconds: 3),() async
    {
      //send user to home screen
      Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));

    });
  }
 @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {

    return  Material(
      child: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/logo-color.png"),

              const SizedBox(height: 10,),

              const Text(
                "PVRS project",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                )
          ,
              )
            ],
          ),
        ),

      ),
    );
  }
}
