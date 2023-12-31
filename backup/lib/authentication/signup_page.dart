
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pvers_customer/authentication/login_screen.dart';
import 'dart:async';
import 'dart:io';
import 'package:mysql_client/mysql_client.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import '../MainScreens/main_screen.dart';



class signupscreen extends StatefulWidget {


  @override
  State<signupscreen> createState() => _signupscreenState();
}

class _signupscreenState extends State<signupscreen> {

  String? imageLink_front="";

  TextEditingController idTextEditingController = TextEditingController();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController dateTextEditingController = TextEditingController();
  TextEditingController imageTextEditingController = TextEditingController();
  Duration? DateTime_2 = Duration(days: 0);
  DateTime DateTime_1 = DateTime.now();
  File? _imageFile;
  bool? isChecked = false;
  bool? isChecked2 = false;



  validateForm() async {
    int years=0;
    print("this is the date inside of validate$DateTime_2");
      years = DateTime_2!.inDays~/ 365;
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

    else if (!GetUtils.isEmail(emailTextEditingController.text)) {
      Fluttertoast.showToast(msg: "Email is not Valid.");
    }

    else if (passTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "password must not be empty.");
    }
    else if (passTextEditingController.text.length <= 8) {
      Fluttertoast.showToast(msg: "password must be at least 9 Characters.");
    }
    else if (!phoneTextEditingController.text.startsWith("05")) {
      Fluttertoast.showToast(msg: "the phone must start with 05.");
    }



    else if (phoneTextEditingController.text.length < 10) {
      Fluttertoast.showToast(msg: "phone must be 10 digit.");
    }


    else if (years <= 18){
      Fluttertoast.showToast(msg: "your age must be at least 18");
    }
     else if (isChecked == false) {
       Fluttertoast.showToast(msg: "you have to agree to the terms and service");
     }

    else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      Fluttertoast.showToast(msg: "Processing, Please wait");


      var id = idTextEditingController.text;
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
          "SELECT * FROM owner WHERE owner_id = '$id'");
      //owner_pass= '$pass1'
      var res1 = await conn.execute(
          "SELECT * FROM renter WHERE Renter_ID = '$id'");

      if (res.numOfRows == 1) {
        Fluttertoast.showToast(msg: "this id is already registered.");
        print("user is owner found");
        Navigator.pop(context);
      }
      else if (res1.numOfRows == 1) {
        Fluttertoast.showToast(msg: "this id is already registered.");
        print("user is renter found");
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
        DateTime_2 = now.difference(value)!;
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        String? finaldate1 = formatter.format(DateTime_1);
        print("the date is$finaldate1.toString()");
        dateTextEditingController.text = finaldate1.toString();
      });
    });

  }

  //String? contents =  imageTemp.readAsString();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
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
                  labelText: "Upload ID Image",
                  hintText: "Upload ID Image",

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
                      onChanged: (bool? newvalue){

                        setState(() {
                          isChecked = newvalue!;
                        });
                      }),
                  const Text("I agree to the terms of service",style: TextStyle(
                    color: Colors.white,
                  ),
                  ),
        ]),
              const SizedBox(height: 20,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        activeColor: Colors.green,
                        value: isChecked2,
                        onChanged: (bool? newvalue2){

                          setState(() {
                            isChecked2 = newvalue2!;
                          });
                        }),
                    const Text("Are you owner?",style: TextStyle(
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
    String? id5 = idTextEditingController.text;

    final storageRef = FirebaseStorage.instance.ref().child('images/Users/$id5');
    final imageName = _imageFile!.path.split('/').last;
    final imageRef = storageRef.child(imageName);

    final uploadTask =  imageRef.putFile(_imageFile!);
    final snapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await snapshot.ref.getDownloadURL();

    setState(() {
      imageLink_front = downloadUrl;
    });

    print(imageLink_front);
    String? user = nameTextEditingController.text.trim();
    print("Connecting to mysql server...");

    final conn = await MySQLConnection.createConnection(
        host: '10.0.2.2',
        port: 3306,
        userName: 'root',
        password: 'root',
        databaseName: 'pvers');
    /*host: 'pvers.mysql.database.azure.com',
        port: 3306,
        userName: 'nawaf',
        password: 'wI@AyQmT7Xd3WbIJ',
        databaseName: 'pvers');*/

    await conn.connect();
    print("Connected");
    // for owner
    if(isChecked2 == true){
    var res = await conn.execute(
      "INSERT INTO owner (owner_id,owner_name,owner_phonenum,owner_email,owner_pass,owner_bdate,owner_picture_link,owner_tos_agreement) VALUES (:id1, :name1, :phone1, :email1, :pass1, :date1, :image1, :tos1)",
      {
        "id1": idTextEditingController.text.trim(),
        "name1": nameTextEditingController.text.trim(),
        "phone1": phoneTextEditingController.text.trim(),
        "email1": emailTextEditingController.text.trim(),
        "pass1": passTextEditingController.text.trim(),
        "date1": dateTextEditingController.text.trim(),
        "image1": imageLink_front,
        "tos1": isChecked,
      },
    );
    print(res.affectedRows);

    await conn.close();
    Fluttertoast.showToast(msg: "you $user registered successfully");

    //send();
    Navigator.push(
        context, MaterialPageRoute(builder: (c) => const MainScreen()));
  }
    // for renter
   else {
      var res = await conn.execute(
        "INSERT INTO renter (Renter_ID,Renter_Name,Renter_Phone_No,Renter_Email,Renter_pass,Renter_Bdate,Renter_picture_link,Renter_tos_agreement) VALUES (:id1, :name1, :phone1, :email1, :pass1, :date1, :image1, :tos1)",
        {
          "id1": idTextEditingController.text.trim(),
          "name1": nameTextEditingController.text.trim(),
          "phone1": phoneTextEditingController.text.trim(),
          "email1": emailTextEditingController.text.trim(),
          "pass1": passTextEditingController.text.trim(),
          "date1": dateTextEditingController.text.trim(),
          "image1": imageLink_front,
          "tos1": isChecked,
        },
      );
      print(res.affectedRows);

      await conn.close();
      Fluttertoast.showToast(msg: "you $user registered successfully");

      //send();
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


  }
  }
}