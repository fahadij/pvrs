import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../MainScreens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:pvers_customer/main_pages/owner/main_screen.dart';
import 'package:pvers_customer/main_pages/renter/main_screen.dart';
import 'package:pvers_customer/main_pages/admin/main_screen.dart';
class otp_mail extends StatefulWidget {
  final String email;


  otp_mail({required this.email});
  @override
  State<otp_mail> createState() => _otp_mailState();
}

class _otp_mailState extends State<otp_mail> {


  /*Future otp()async{
var respones = await http.post(Uri.parse('http://10.0.2.2/test/api_otp.php'),body: {

  "email": widget.email,
});
}*/

  TextEditingController otpTextEditingController = TextEditingController();
  String verificationId ="";
  var token;
  bool verification = false;
  String email_renter = "";
  String email_owner = "";
  String email_admin = "";
  bool owner = false;
  bool renter = false;
  bool admin = false;
  @override
  void initState() {
    super.initState();
    getCred();
    //sendOtp();
  }


  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("ID1")!;
      //nameTextEditingController.text =
      sendOtp();
    });










  }

  Future<void> sendOtp() async {
    //await otp();

    String url = 'http://10.0.2.2/test/api_otp.php'; // Replace with your actual server address

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    print("Connecting to mysql server...");

    final conn = await MySQLConnection.createConnection(
        host: '10.0.2.2',
        port: 3306,
        userName: 'root',
        password: 'root',
        databaseName: 'pvers');


    await conn.connect();
    print("Connected");
    var res = await conn.execute("SELECT * FROM owner WHERE owner_id = '$token'");
    //owner_pass= '$pass1'
    var res1 = await conn.execute("SELECT * FROM renter WHERE Renter_ID = '$token'");

    var res2 = await conn.execute("SELECT * FROM admin WHERE admin_id = '$token'");


    if(res2.numOfRows ==1){
      print("user is found admin");

      for (final row in res2.rows) {
        final data = {
          setState(() {
            admin = true;
            email_admin = row.colByName("admin_email")!;
          }
          ),};
      }
      print(email_admin);
    }
    else if(res.numOfRows ==1){
      print("user is found owner");

      for (final row in res.rows) {
        final data = {
          setState(() {
            owner = true;
            email_owner = row.colByName("owner_email")!;
          }
          ),};
      }
      print(email_owner);
    }
    else if(res1.numOfRows ==1) {
      print("user is found renter");
      for (final row in res1.rows) {
        final data = {
          setState(() {
            renter = true;
            email_renter = row.colByName("Renter_Email")!;
          }
          ),};}}

    await conn.close();

    try {
      var renter1 = renter.toString();
      var owner1 = owner.toString();
      var admin1 =  admin.toString();
      print(owner1);
      print(renter1);
      print(admin1);
      final response = await http.post(
        Uri.parse(url),
        body: {
          'email_owner':email_owner,
          'email_renter':email_renter,
          'email_admin':email_admin,
          'id':token,
          'renter':renter1,
          'owner':owner1,
          'admin':admin1,
        }
        //headers: headers,
      );
      //var data=json.decode(json.encode(snapshot.data));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("OTP is sent"),
          ),
        );
        print(response.statusCode);
    }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Oops, Wrong OTP send failed"),
          ),
        );
      }
      }catch (e) {
      print('Error: $e');
    }
  }


  Future<void> checkOtp() async {
    String otp = otpTextEditingController.text;
    var otp1;
    final conn = await MySQLConnection.createConnection(
        host: '10.0.2.2',
        port: 3306,
        userName: 'root',
        password: 'root',
        databaseName: 'pvers');


    await conn.connect();
    print("Connected");
    var res = await conn.execute(
        "SELECT * FROM owner WHERE owner_id = '$token'");
    //owner_pass= '$pass1'
    var res1 = await conn.execute(
        "SELECT * FROM renter WHERE Renter_ID = '$token'");
    var res2 = await conn.execute(
        "SELECT * FROM admin WHERE admin_id = '$token'");

    if (res2.numOfRows == 1) {
      print("user is admin found");

      for (final row in res2.rows) {
        final data = {
          setState(() {
            renter = true;
            otp1 = row.colByName("otp")!;
          }
          ),};
      }
      await conn.close();

      if (otp == otp1) {
        print("user is admin found");
        Fluttertoast.showToast(msg: "the Admin authonticated");
        print("user is admin found");
        Navigator.push(context,
            MaterialPageRoute(builder: (c) => const MainScreen_admin()));
      } else {
        print(otp1);
        print(otp);
        Fluttertoast.showToast(msg: 'Invalid OTP');
      }
    }
    else if (res1.numOfRows == 1) {
      print("user is renter found");

      for (final row in res1.rows) {
        final data = {
          setState(() {
            renter = true;
            otp1 = row.colByName("otp")!;
          }
          ),};
      }

      await conn.close();
      if (otp == otp1) {
        Fluttertoast.showToast(
            msg: "the Renter phone was successfully authonticated");
        Navigator.push(context,
            MaterialPageRoute(builder: (c) => const MainScreen_renter()));
      } else {
        // OTP is incorrect
        print(otp1);
        print(otp);
        Fluttertoast.showToast(msg: 'Invalid OTP');
        // Add code to handle incorrect OTP here
      }
    }
    else if (res.numOfRows == 1) {
      print("user is owner found");

      for (final row in res1.rows) {
        final data = {
          setState(() {
            renter = true;
            otp1 = row.colByName("otp")!;
          }
          ),};
      }

      await conn.close();
      if (otp == otp1) {
        Fluttertoast.showToast(
            msg: "the Owner phone was successfully authonticated");
        Navigator.push(context,
            MaterialPageRoute(builder: (c) => const MainScreen_owner()));
      } else {
        // OTP is incorrect
        print(otp1);
        print(otp);
        Fluttertoast.showToast(msg: 'Invalid OTP');
        // Add code to handle incorrect OTP here
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(

        child: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset("images/logo-color.png"),
          ),
          const SizedBox(height: 10),
          const Text(
            "Enter OTP",
            style: TextStyle(
              fontSize: 26,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: otpTextEditingController,
            keyboardType: TextInputType.phone,
            style: TextStyle(
              color: Colors.grey,
            ),
            decoration: InputDecoration(
              labelText: "OTP",
              hintText: "OTP",
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
          ElevatedButton(
            onPressed: () {
              checkOtp();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightGreenAccent,
            ),
            child: Text(
              "Verify OTP",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              sendOtp();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightGreenAccent,
            ),
            child: Text(
              "Resend OTP",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
