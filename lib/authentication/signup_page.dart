import 'package:flutter/material.dart';
import 'package:mysql_client/exception.dart';
import 'package:pvers_customer/authentication/host_a_vehicle.dart';
import 'package:pvers_customer/authentication/login_screen.dart';
import 'dart:async';
import 'package:mysql_client/mysql_client.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pvers_customer/widgets/progress_dialog.dart';

class signupscreen extends StatefulWidget {


  @override
  State<signupscreen> createState() => _signupscreenState();
}

class _signupscreenState extends State<signupscreen>
{

  TextEditingController idTextEditingController = TextEditingController();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();


validateForm() async {

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

  else if (passTextEditingController.text.isEmpty) {
    Fluttertoast.showToast(msg: "password must not be empty.");
  }
  else if (passTextEditingController.text.length <= 8) {
    Fluttertoast.showToast(msg: "password must be at least 8 Characters.");
  }
   /*else if (phoneTextEditingController.text.startsWith("05")) {
     Fluttertoast.showToast(msg: "the phone must start with 05.");
   }*/
  else if (phoneTextEditingController.text.length < 10) {
    Fluttertoast.showToast(msg: "phone must be 10 digit.");
  }

  else {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext c)
      {
        return ProgressDialo(message: "Processing, Please wait",);
      }
    );
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
     var res = await conn.execute("SELECT * FROM owner WHERE owner_id = '$id'");
     //owner_pass= '$pass1'



     if(res.numOfRows ==1){
       Fluttertoast.showToast(msg: "this id is already registered.");
       print("user is found");
       Navigator.pop(context);
     }
     else{
       print("user is not found");
       insert();
     }

     await conn.close();
   }


  }







  @override
  Widget build(BuildContext context)
  {


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

           const SizedBox(height: 20,),
           ElevatedButton(
               onPressed:()
               {
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
             onPressed:()
             {
               Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
             },
           ),
         ],
       ),
     ),
      ),
    );
  }
  Future<void> insert() async{
    print("Connecting to mysql server...");

    final conn = await MySQLConnection.createConnection(
        host: '10.0.2.2',
        port: 3306,
        userName: 'root',
        password: 'root',
        databaseName: 'pvers');

    await conn.connect();
    print("Connected");
    var res = await conn.execute("INSERT INTO owner (owner_id,owner_name,owner_phonenum,owner_email,owner_pass) VALUES (:id1, :name1, :phone1, :email1, :pass1)",
      {
        "id1": idTextEditingController.text.trim(),
        "name1": nameTextEditingController.text.trim(),
        "phone1": phoneTextEditingController.text.trim(),
        "email1": emailTextEditingController.text.trim(),
        "pass1": passTextEditingController.text.trim(),
      },
    );
    print(res.affectedRows);

    await conn.close();
    Fluttertoast.showToast(msg: "the user registered successfully");
    Navigator.pop(context);
  }
}
