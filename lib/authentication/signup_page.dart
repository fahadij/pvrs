
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mysql_client/exception.dart';
import 'package:pvers_customer/authentication/host_a_vehicle.dart';
import 'package:pvers_customer/authentication/login_screen.dart';
import 'dart:async';
import 'dart:io';
import 'package:mysql_client/mysql_client.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pvers_customer/tab_pages/home_tab.dart';
import 'package:pvers_customer/widgets/progress_dialog.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import '../MainScreens/main_screen.dart';
import 'dart:typed_data';



class signupscreen extends StatefulWidget {


  @override
  State<signupscreen> createState() => _signupscreenState();
}

class _signupscreenState extends State<signupscreen> {


  TextEditingController idTextEditingController = TextEditingController();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController dateTextEditingController = TextEditingController();
  TextEditingController imageTextEditingController = TextEditingController();
  Timer? _timer;
  DateTime DateTime_1 = DateTime.now();
  File? _imageFile;
  Uint8List? _imageString;
  bool isChecked = false;
  Duration? DateTime_2;

  validateForm() async {
    int years = DateTime_2!.inDays~/ 365;
    print("your age is:$years");

    if (!idTextEditingController.text.startsWith("1")) {
      Fluttertoast.showToast(msg: "ID must start with 1.");
    }

    else if (idTextEditingController.text.length < 10) {
      Fluttertoast.showToast(msg: "ID must be 10 digit.");
    }

    else if (nameTextEditingController.text.length < 3) {
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

    else if (years <= 18){
      Fluttertoast.showToast(msg: "your age must be at least 18");
    }

    else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      Fluttertoast.showToast(msg: "Processing, Please wait");


      var id = idTextEditingController.text;
      print("Connecting to mysql server...");

      final conn = await MySQLConnection.createConnection(
          host: 'pvers.mysql.database.azure.com',
          port: 3306,
          userName: 'nawaf',
           password: 'wI@AyQmT7Xd3WbIJ',
          databaseName: 'pvers');

      await conn.connect();
      print("Connected");
      var res = await conn.execute(
          "SELECT * FROM owner WHERE owner_id = '$id'");
      //owner_pass= '$pass1'


      if (res.numOfRows == 1) {
        Fluttertoast.showToast(msg: "this id is already registered.");
        print("user is found");
        Navigator.pop(context);
      }
      else {
        print("user is not found");
        insert();
        await prefs.setString('ID1', id);
      }

      await conn.close();
    }
  }

  void showDatePicker1() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2025),
    ).then((value) {
      setState(() {
        DateTime_1 = value!;
        DateTime now = DateTime.now();
        DateTime_2 = now.difference(value!);
      });
    });
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    String? finaldate1 = formatter.format(DateTime_1);
    print("the date is$finaldate1.toString()");
    dateTextEditingController.text = finaldate1.toString();
  }

  //String? contents =  imageTemp.readAsString();
  Future<void> _imageToString() async {
    try {
      if (_imageFile != null) {
        final bytes = await _imageFile!.readAsBytes();
        Uint8List blob = Uint8List.fromList(bytes);

        setState(() {
          _imageString = blob;
        });

        print('Image converted to string: $_imageString');
      }
    } catch (e) {
      print('Error converting image to string: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Convert the image file to a string
      _imageToString();
    }
  }

  @override
  Widget build(BuildContext context) {
    //File imageFile = File(imageTemp!); // Replace with your image file path

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

                "Register user",
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

              TextField(
                controller: dateTextEditingController,
                onTap: () {
                  showDatePicker1();
                },
                style: TextStyle(
                  color: Colors.grey,
                ),
                decoration: InputDecoration(
                  labelText: "date",
                  hintText: "date",

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
                controller: imageTextEditingController,
                onTap: () {
                  _pickImage();
                },
                readOnly: true,
                style: TextStyle(
                  color: Colors.grey,
                ),
                decoration: InputDecoration(
                  labelText: "image",
                  hintText: "image",

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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                      activeColor: Colors.green,
                      value: isChecked,
                      onChanged: (bool? value){

                        setState(() {
                          isChecked = value!;
                        });
                      }),
                  const Text("I agree to the terms of service",style: TextStyle(
                    color: Colors.white,
                  ),
                  ),
        ]),

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
                  "Create Account",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),

                ),
              ),
              TextButton(
                child: const Text(
                  "Already have an account? Login Here",
                  style: TextStyle(color: Colors.grey),

                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => LoginScreen()));
                },
              ),





                ],
              )
          ),
      ),
    );
  }

  Future<void> insert() async {
    print("Connecting to mysql server...");

    final conn = await MySQLConnection.createConnection(
        host: 'pvers.mysql.database.azure.com',
        port: 3306,
        userName: 'nawaf',
         password: 'wI@AyQmT7Xd3WbIJ',
        databaseName: 'pvers');
    /*host: 'pvers.mysql.database.azure.com',
        port: 3306,
        userName: 'nawaf',
        password: 'wI@AyQmT7Xd3WbIJ',
        databaseName: 'pvers');*/

    await conn.connect();
    print("Connected");
    var res = await conn.execute(
      "INSERT INTO owner (owner_id,owner_name,owner_phonenum,owner_email,owner_pass,owner_bdate,owner_id_picture,owner_tos_agreement) VALUES (:id1, :name1, :phone1, :email1, :pass1, :date1, :image1, :tos1)",
      {
        "id1": idTextEditingController.text.trim(),
        "name1": nameTextEditingController.text.trim(),
        "phone1": phoneTextEditingController.text.trim(),
        "email1": emailTextEditingController.text.trim(),
        "pass1": passTextEditingController.text.trim(),
        "date1": dateTextEditingController.text.trim(),
        "image1": _imageString,
        "tos1": isChecked,
      },
    );
    print(res.affectedRows);

    await conn.close();
    Fluttertoast.showToast(msg: "the user registered successfully");

    send();
    Navigator.push(
        context, MaterialPageRoute(builder: (c) => const MainScreen()));
  }

  Future<void> send() async {
    const String subject = "the user registered successfully";
    const String body = "test";

    /*final Email email = Email(
      from: ['www.mt2arab.com@gmail.com'],
      body: body,
      subject: subject,
      recipients: [emailTextEditingController.text],
      cc: ['www.mt22arab.com@gmail.com'],
      bcc: ['www.mt222arab.com@gmail.com'],

    );*/


  }}