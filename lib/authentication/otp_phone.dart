import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../MainScreens/main_screen.dart';

class OtpVerification extends StatefulWidget {
  final String phoneNumber;

  OtpVerification({required this.phoneNumber});

  @override
  _OtpVerificationState createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController otpTextEditingController = TextEditingController();
  String verificationId ="";
  var token;
  bool verification = false;

  @override
  void initState() {
    super.initState();
    getCred();
    sendOtp();
  }


  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("ID1")!;
      //nameTextEditingController.text =
    });










  }

  Future<void> sendOtp() async {

    await _auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("OTP is verified"),
          ),
        );

      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Oops, Wrong OTP send failed"),
          ),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          this.verificationId = verificationId;

        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> checkOtp() async {
    String otp = otpTextEditingController.text;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    try {
      await _auth.signInWithCredential(credential);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OTP is verified test"),
        ),
      );
      print(verificationId);
      print(otp);

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

      if(res.numOfRows ==1){
        print("user is owner found");
        print(verificationId);
        print(token);
        var res = await conn.execute("UPDATE owner SET owner_verificationId = '$verificationId' WHERE owner_id = '$token' ");
        await conn.close();
        print("user is owner found");
        Fluttertoast.showToast(msg: "the Owner phone was successfully authonticated");
        print("user is owner found");
        Navigator.push(context,MaterialPageRoute(builder: (c) => const MainScreen()));
      }
      else if(res1.numOfRows ==1){
        print("user is renter found");
        var res = await conn.execute(
            "UPDATE owner SET Renter_Phone_auth = '$verification',Renter_verificationId = '$verificationId' WHERE Renter_ID = '$token'");
        await conn.close();
        Fluttertoast.showToast(msg: "the Renter phone was successfully authonticated");
        Navigator.push(context,MaterialPageRoute(builder: (c) => const MainScreen()));
      }




      Navigator.push(
        context,
        MaterialPageRoute(builder: (c) => const MainScreen()),
      );




    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid OTP"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
    );
  }
}