import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:pvers_customer/MainScreens/main_screen.dart';
import 'package:pvers_customer/authentication/host_a_vehicle.dart';
import 'package:pvers_customer/authentication/signup_page.dart';
import 'package:pvers_customer/global/global.dart';
import 'package:pvers_customer/tab_pages/home_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/progress_dialog.dart';
import 'otp_mail.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController idTextEditingController = TextEditingController();
  TextEditingController passTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [

              const SizedBox(height: 30,),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("images/logo-color.png"),
              ),
              const Text(

                "Login",
                style: TextStyle(

                  fontSize: 26,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),


              ),

              TextField(
                controller: idTextEditingController,
                keyboardType: TextInputType.phone,
                style: TextStyle(
                  color: Colors.grey,
                ),
                decoration: InputDecoration(
                  labelText: "ID",
                  hintText: "ID",

                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),

                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),

                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),

                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),

                ),


              ),

              TextField(
                controller: passTextEditingController,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: TextStyle(
                  color: Colors.grey,
                ),
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Password",

                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),

                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),

                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),

                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),

                ),


              ),

              const SizedBox(height: 20,),
              ElevatedButton(
                onPressed: (){
                  _insert();
                  //Navigator.push(context, MaterialPageRoute(builder: (c)=> MainScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent,
                ),
                child: Text
                  (
                  "Login ",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),


                ),
              ),

              TextButton(
                child: const Text(
                  "Do not have an account? Register Here",
                      style: TextStyle(color: Colors.grey),

                ),
                onPressed:()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> signupscreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );

  }
  Future<void> _insert() async{

    var id1 = idTextEditingController.text;
    var pass1 = passTextEditingController.text;
    var owner_pass = '';
    var email_owner = '';
    var email_renter = '';
    print("Connecting to mysql server...");

    //passkG1N04&QuQHuWwix
    final conn = await MySQLConnection.createConnection(
        host: '10.0.2.2',
        port: 3306,
        userName: 'root',
        password: 'root',
        databaseName: 'pvers');


    await conn.connect();
    print("Connected");
    var res = await conn.execute("SELECT * FROM owner WHERE owner_id = '$id1' AND owner_pass ='$pass1'");
    //owner_pass= '$pass1'
    var res1 = await conn.execute("SELECT * FROM renter WHERE Renter_ID = '$id1' AND Renter_pass ='$pass1'");


    if(res.numOfRows ==1){
      print("user is found");

      for (final row in res1.rows) {
        final data = {
          setState(() {
            email_owner = row.colAt(4)!;
          }
          ),};
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('ID1', id1);
      Navigator.push(context,MaterialPageRoute(builder: (c) =>  otp_mail(email: email_owner )));
    }
    else if(res1.numOfRows ==1) {
      print("user is found");
      for (final row in res1.rows) {
        final data = {
          setState(() {
            email_renter = row.colAt(4)!;
          }
          ),};
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('ID1', id1);
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => otp_mail(email: email_renter)));
    }
    else{
      print("user is not found");
    }

    await conn.close();
  }
  }

