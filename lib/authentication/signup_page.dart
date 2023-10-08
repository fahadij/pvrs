import 'package:flutter/material.dart';
import 'package:pvers_customer/authentication/host_a_vehicle.dart';
import 'package:pvers_customer/authentication/login_screen.dart';
import 'dart:async';
import 'package:mysql_client/mysql_client.dart';

class signupscreen extends StatefulWidget {


  @override
  State<signupscreen> createState() => _signupscreenState();
}

class _signupscreenState extends State<signupscreen>{



  




  @override

  TextEditingController idTextEditingController = TextEditingController();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();


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
               onPressed:_insert,
               style: ElevatedButton.styleFrom(
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
  Future<void> _insert() async{
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
        "id1": idTextEditingController.text,
        "name1": nameTextEditingController.text,
        "phone1": phoneTextEditingController.text,
        "email1": emailTextEditingController.text,
        "pass1": passTextEditingController.text,
      },
    );
    print(res.affectedRows);
    await conn.close();
  }
}
