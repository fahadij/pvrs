import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:pvers_customer/MainScreens/main_screen.dart';
import 'package:pvers_customer/authentication/signup_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController phoneTextEditingController = TextEditingController();
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
    var phone1 = phoneTextEditingController.text;
    var pass1 = passTextEditingController.text;
    var owner_pass = '';
    print("Connecting to mysql server...");

    final conn = await MySQLConnection.createConnection(
        host: '10.0.2.2',
        port: 3306,
        userName: 'root',
        password: 'root',
        databaseName: 'pvers');

    await conn.connect();
    print("Connected");
    var res = await conn.execute("SELECT * FROM owner WHERE owner_phonenum = '$phone1' AND owner_pass ='$pass1'");
    //owner_pass= '$pass1'



    if(res.numOfRows ==1){
      print("user is found");
    }
    else{
      print("user is not found");
    }

    await conn.close();
  }


}
