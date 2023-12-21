import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pvers_customer/MainScreens/main_screen.dart';
import 'package:pvers_customer/main_pages/admin/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mysql_client/mysql_client.dart';
import '../authentication/login_screen.dart';
import '../authentication/otp_mail.dart';
import '../authentication/otp_phone.dart';

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
  var phonenumber;
  startTimer(){
    Timer(const Duration(seconds: 3),() async
    {
      SharedPreferences pref = await SharedPreferences.getInstance();
      setState(() {
        ID = pref.getString("ID1");
        print('signed in id is: $ID');
      });
       if(ID == 100321){
         Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
       }
       else{
      print("Connecting to mysql server...");
var emailowner = '';
var emailrenter = '';
var adminemail = '';
      final conn = await MySQLConnection.createConnection(
          host: '10.0.2.2',
          port: 3306,
          userName: 'root',
          password: 'root',
          databaseName: 'pvers');

      await conn.connect();
      print("Connected");
      var res = await conn.execute("SELECT * FROM owner WHERE owner_id = '$ID'");
      //owner_pass= '$pass1'
      var res1 = await conn.execute("SELECT * FROM renter WHERE Renter_ID = '$ID' ");
      var res2 = await conn.execute("SELECT * FROM admin WHERE admin_id = '$ID' ");
      var o = res.numOfRows;
      var R = res1.numOfRows;
print("owner checked is $o");
print("renter checked is $R");
      if(res.numOfRows == 1) {
        print("user is owner found");
        var res2 = await conn.execute(
            "SELECT * FROM owner WHERE owner_id = '$ID'");
        if (res2.numOfRows == 1) {
          print("user is owner found and the mail is authonticated");

          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const MainScreen_admin()));
        } else {
          print("user is owner found and the mail is not authonticated");
          for (final row in res.rows) {
            final data = {
              setState(() {
                phonenumber = row.colByName("owner_phonenum")!;
                emailowner = row.colByName("owner_email")!;
              },)
            };
          };
          await conn.close();
          print("this is the value of phone$phonenumber");
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => otp_mail(email: emailowner)));
        }
      }
       else if(res1.numOfRows == 1){

        var res4 = await conn.execute("SELECT * FROM renter WHERE Renter_ID = '$ID' AND otp IS NOT NULL");
        if(res4.numOfRows == 1){
          print("user is renter found and the phone is authonticated");
          Navigator.push(context,MaterialPageRoute(builder: (c) => const MainScreen()));
        } else{
          print("user is renter found and the phone is not authonticated");
          for (final row in res4.rows) {
            final data = {
              phonenumber = row.colByName("Renter_Phone_No")!,
              emailrenter = row.colByName("Renter_Email")!,

            };};
          print("this is the value of email$emailrenter");
          await conn.close();
          Navigator.push(context,MaterialPageRoute(builder: (c) =>  otp_mail(email: emailowner)));
        }
    }
      if(res2.numOfRows == 1) {
        print("user is admin found");
        var res5 = await conn.execute(
            "SELECT * FROM admin WHERE admin_id = '$ID'");
        if (res5.numOfRows == 1) {
          print("user is owner found and the mail is authonticated");

          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const MainScreen()));
        } else {
          print("user is admin found and the mail is not authonticated");
          for (final row in res5.rows) {
            final data = {
              setState(() {
                phonenumber = row.colByName("owner_phonenum")!;
                adminemail = row.colByName("admin_email")!;
              },)
            };
          };
          await conn.close();
          print("this is the value of phone for admin$phonenumber");
          print("this is the value of email for admin$adminemail");
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => otp_mail(email: adminemail)));
        }
      }

      else if(res1 ==0 && res == 0){
        print("user is not found");
        Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
      }

    }});
      /*if(await ID != null ){

        Navigator.push(context, MaterialPageRoute(builder: (c)=> MainScreen()));

      } else{

        Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));

      }
      //send user to home screen
*/

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
