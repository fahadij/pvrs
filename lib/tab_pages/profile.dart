import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authentication/login_screen.dart';
import '../authentication/FAQ.dart';
import '../widgets/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class profilepage extends StatefulWidget {

  @override
  State<profilepage> createState() => _profilepageState();
}

class _profilepageState extends State<profilepage> {

  TextEditingController idTextEditingController = TextEditingController();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  String? token;
  String? token2;
  Timer? _timer;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCred();
    getdata();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("ID1")!;
      idTextEditingController.text = token!;
      token2 = pref.getString("ID1")!;
      //nameTextEditingController.text =
    });
  }

  @override
  validateForm() async {
    if (nameTextEditingController.text.length < 3) {
      Fluttertoast.showToast(msg: "name must be at least 3 Characters.");
    }

    else if (!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email is not Valid.");
    }
    else if (!GetUtils.isEmail(emailTextEditingController.text)) {
      Fluttertoast.showToast(msg: "Email is not Valid.");
    }

    else if (passTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "password must not be empty.");
    }
    else if (!GetUtils.isPhoneNumber(phoneTextEditingController.text)) {
      Fluttertoast.showToast(msg: "the phone must start with 05.");
    }
    else if (passTextEditingController.text.length <= 8) {
      Fluttertoast.showToast(msg: "password must be at least 8 Characters.");
    }

    else if (phoneTextEditingController.text.length < 10) {
      Fluttertoast.showToast(msg: "phone must be 10 digit.");
    }

    else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext c) {
            _timer = Timer(Duration(seconds: 5), () {
              Navigator.of(context).pop();
            });
            return ProgressDialo(message: "Processing, Please wait",);
          });
      update1();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [

              const SizedBox(height: 10,),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("images/logo-color.png"),
              ),
              const SizedBox(height: 10),

              const Text(

                "Profile Page",
                style: TextStyle(

                  fontSize: 26,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),

              ),


              TextField(
                controller: idTextEditingController,
                keyboardType: TextInputType.phone,
                readOnly: true,
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
                controller: nameTextEditingController,
                style: TextStyle(
                  color: Colors.grey,
                ),
                decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "Name",

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
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,

                style: TextStyle(
                  color: Colors.grey,
                ),
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Email",

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

              TextField(
                controller: phoneTextEditingController,
                keyboardType: TextInputType.phone,
                style: TextStyle(
                  color: Colors.grey,
                ),
                decoration: InputDecoration(
                  labelText: "Phone",
                  hintText: "Phone",

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
                onPressed: () {
                  validateForm();
                },
                style:
                ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent,
                ),

                child: Text
                  (
                  "Update Account",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),

                ),
              ),
              ElevatedButton(
                onPressed: () {
                  FAQScreen();
                },
                style:
                ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent,
                ),

                child: Text
                  (
                  "Go to FAQ page",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),

                ),
              ),

              ElevatedButton(
                onPressed: () {
                  Logout();
                },
                style:
                ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),

                child: Text
                  (
                  "Logout",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),

                ),
              ),

              ElevatedButton(
                onPressed: () {
                  getCred();
                  getdata();
                },
                style:
                ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent,
                ),

                child: Text
                  (
                  "Get Account data",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> Logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('ID1');
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (c) => const LoginScreen()), (
        route) => false);
  }

  Future<void> getdata() async {
    print("Connecting to mysql server...");

    final conn = await MySQLConnection.createConnection(
        host: '10.0.2.2',
        port: 3306,
        userName: 'root',
        password: 'root',
        databaseName: 'pvers');

    await conn.connect();
    print("Connected");
    var res = await conn.execute(
        "SELECT * FROM owner WHERE owner_id = $token2 "
    );

    for (final row in res.rows) {
      final data = {
        setState(() {
          nameTextEditingController.text = row.colAt(1)!;
          phoneTextEditingController.text = row.colAt(2)!;
          emailTextEditingController.text = row.colAt(4)!;
          passTextEditingController.text = row.colAt(6)!;
        }),
      };


      await conn.close();
    }
  }


    Future<void> update1() async {
      print("Connecting to mysql server...");

      final conn = await MySQLConnection.createConnection(
          host: '10.0.2.2',
          port: 3306,
          userName: 'root',
          password: 'root',
          databaseName: 'pvers');
      String name1 = nameTextEditingController.text.trim();
      String phone1 = phoneTextEditingController.text.trim();
      String email1 = emailTextEditingController.text.trim();
      String pass1 = passTextEditingController.text.trim();

      await conn.connect();
      print("Connected");
      var res = await conn.execute(
          "UPDATE owner SET owner_name = '$name1' , owner_phonenum = '$phone1' , owner_email = '$email1' , owner_pass = '$pass1' WHERE owner_id = '$token' ");


      await conn.close();
      Fluttertoast.showToast(msg: "the user updated successfully");


    }
  }


