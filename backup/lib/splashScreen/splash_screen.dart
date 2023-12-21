import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pvers_customer/MainScreens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authentication/login_screen.dart';

class MySplashScreen extends StatefulWidget
{


  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}




class _MySplashScreenState extends State<MySplashScreen>

{
  var ID;
  @override
  void initState() {
    super.initState();

    startTimer();

  }

  startTimer(){
    Timer(const Duration(seconds: 3),() async
    {
      SharedPreferences pref = await SharedPreferences.getInstance();
      setState(() {
        ID = pref.getString("ID1");
        print('signed in id is: $ID');
      });

      if(await ID != null ){

        Navigator.push(context, MaterialPageRoute(builder: (c)=> MainScreen()));

      } else{

        Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));

      }
      //send user to home screen


    });
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
