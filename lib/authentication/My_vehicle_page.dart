import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MainScreens/main_screen.dart';
import '../authentication/login_screen.dart';
import '../authentication/FAQ.dart';
import '../widgets/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class vehicle_page extends StatefulWidget {

  @override
  State<vehicle_page> createState() => _vehicle_page();
}

class _vehicle_page extends State<vehicle_page> {
  TextEditingController vehiclenumTextEditingController = TextEditingController();
  TextEditingController vehiclenameTextEditingController = TextEditingController();
  TextEditingController vehiclemodelTextEditingController = TextEditingController();
  TextEditingController vehicleEVTextEditingController = TextEditingController();
  TextEditingController vehicleRateTextEditingController = TextEditingController();
  TextEditingController vehicleLocationTextEditingController = TextEditingController();
  List<String> carTypesList = ["size-big", "size-medium", "size-small"];
  String? selectedCarType;
  bool isChecked = false;
  bool? isChecked3 = true;
  bool? isChecked4 = false;
  int? EV_value_db = 0;
  TextEditingController idTextEditingController = TextEditingController();
  String token= "";
  String? token2;


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
        "SELECT * FROM vehicle WHERE owner_id_V = $token2 "
    );

    for (final row in res.rows) {
      final data = {
        setState(() {
          vehiclenumTextEditingController.text = row.colByName("V_num")!;
          vehiclenameTextEditingController.text = row.colByName("V_Name")!;
          vehiclemodelTextEditingController.text= row.colByName("V_Model")!;
          EV_value_db = row.colByName("V_EV") == "1" ? 1 : 0;
          selectedCarType = row.colByName("V_Type")!;
          idTextEditingController.text = row.colByName("owner_id_V")!;
        }),
      };
    }
    isChecked3 = EV_value_db == 1 ? true : false;
    print("this is the value of the checkbox3: $isChecked3");
    setState(() {
      isChecked = isChecked3!;
    });
    print("this is the value of the checkbox1: $isChecked");
      await conn.close();
    }



  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 24,),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("images/logo-color.png"),
              ),


              const SizedBox(height: 10,),

              const Text(

                "vehicle Details",
                style: TextStyle(

                  fontSize: 26,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),


              ),

              TextField(
                controller: vehiclenumTextEditingController,
                keyboardType: TextInputType.phone,

                style: const TextStyle(
                  color: Colors.grey,
                ),
                decoration: const InputDecoration(
                  labelText: "vehicle Number",
                  hintText: "vehicle Number",

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
                controller: idTextEditingController,
                keyboardType: TextInputType.phone,
                readOnly: true,

                style: const TextStyle(
                  color: Colors.grey,
                ),
                decoration: const InputDecoration(
                  labelText: "user id",

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
                controller: vehiclenameTextEditingController,
                style: const TextStyle(
                  color: Colors.grey,
                ),
                decoration: const InputDecoration(
                  labelText: "vehicle Name",
                  hintText: "vehicle Name",

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
                controller: vehiclemodelTextEditingController,
                keyboardType: TextInputType.emailAddress,

                style: const TextStyle(
                  color: Colors.grey,
                ),
                decoration: const InputDecoration(
                  labelText: "vehicle model",
                  hintText: "vehicle model",

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
              DropdownButton(
                dropdownColor: Colors.white24,
                hint: const Text(
                    "Please choose Vehicle Type",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,

                    )
                ),
                value: selectedCarType,
                onChanged: (newValue) {
                  setState(() {
                    selectedCarType = newValue.toString();
                  });
                },
                items: carTypesList.map((car) {
                  return DropdownMenuItem(
                    child: Text(
                      car,
                      style: const TextStyle(
                          color: Colors.grey
                      ),
                    ),
                    value: car,
                  );
                }).toList(),
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
                  const Text("EV?",style: TextStyle(
                    color: Colors.white,
                  ),
                  ),





                ],
              )


              /*TextField(
                controller: vehicleEVTextEditingController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(
                  color: Colors.grey,
                ),
                decoration: const InputDecoration(
                  labelText: "is the vehicle EV?",
                  hintText: "is the vehicle EV?",

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


              )*/,

              const SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {
                  validateForm();
                  getCred();
                  initState();
                },
                //Navigator.push(context,MaterialPageRoute(builder: (c) => const MainScreen()));


                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent,
                ),
                child: const Text
                  (
                  "Update Vehicle",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),




                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (c) => const MainScreen()));
                },
                //Navigator.push(context,MaterialPageRoute(builder: (c) => const MainScreen()));


                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent,
                ),
                child: const Text
                  (
                  "Go back to main screen",
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

  validateForm() async {
    if (vehiclenumTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "the vehicle number must not be empty");
    }

    else if (vehiclenameTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "the vehicle name must not be empty.");
    }

    else if (vehiclemodelTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "the vehicle model must not be empty.");
    }

    else if(selectedCarType == null) {
      Fluttertoast.showToast(msg: "the Vehicle type must not be empty.");


    }
    else

    {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext c) {
            var _timer = Timer(Duration(seconds: 5), () {
              Navigator.of(context).pop();
            });
            return ProgressDialo(message: "Processing, Please wait",);
          }
      );
      insert();
    }
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
    String? V_name1 = vehiclenameTextEditingController.text;
    String? V_num1 = vehiclenumTextEditingController.text;
    String? V_Model1 = vehiclemodelTextEditingController.text;
    String? V_Type1 = selectedCarType;
    var res = await conn.execute("UPDATE vehicle SET V_num = '$V_num1' ,V_Name = '$V_name1' ,V_Model = '$V_Model1' ,V_EV='${isChecked ? 1 : 0}' ,V_Type ='$V_Type1' WHERE owner_id_V = '$token'");

    print(res.affectedRows);

    await conn.close();
    Fluttertoast.showToast(msg: "the Vehicle updated successfully");
    Navigator.pop(context);
  }
}