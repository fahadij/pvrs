import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:pvers_customer/MainScreens/main_screen.dart';
import 'package:pvers_customer/tab_pages/home_tab.dart';
import 'package:pvers_customer/widgets/progress_dialog.dart';

class hostacarpage extends StatefulWidget {
  const hostacarpage({super.key});

  @override
  State<hostacarpage> createState() => _hostacarpageState();
}





class _hostacarpageState extends State<hostacarpage> {
  TextEditingController vehiclenumTextEditingController = TextEditingController();
  TextEditingController vehiclenameTextEditingController = TextEditingController();
  TextEditingController vehiclemodelTextEditingController = TextEditingController();
  TextEditingController vehicleEVTextEditingController = TextEditingController();
  List<String> carTypesList = ["size-big", "size-medium", "size-small"];
  String? selectedCarType;
  bool isChecked = false;
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
                    "Please choose Car Type",
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
                onPressed: () {validateForm();},
                  //Navigator.push(context,MaterialPageRoute(builder: (c) => const MainScreen()));


                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent,
                ),
                child: const Text
                  (
                  "Register Vehicle",
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
      Fluttertoast.showToast(msg: "the car type must not be empty.");


    }
    else

      {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext c) {
              return ProgressDialo(message: "Processing, Please wait",);
            }
        );
        var vcheiclenum1 = vehiclenumTextEditingController.text;
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
            "SELECT * FROM vehicle WHERE V_num = '$vcheiclenum1'");
        //owner_pass= '$pass1'


        if (res.numOfRows == 1) {
          Fluttertoast.showToast(msg: "this vehicle is already registered.");
          print("vehicle is found");
          Navigator.pop(context);
        }
        else {
          print("vehicle is not found");
          insert();
        }

        await conn.close();
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
    var res = await conn.execute("INSERT INTO vehicle (V_num,V_Name,V_Model,V_EV,V_Type) VALUES (:vid1, :vn, :vm, :ev, :et)",
      {
        "vid1": vehiclenumTextEditingController.text.trim(),
        "vn": vehiclenameTextEditingController.text.trim(),
        "vm": vehiclemodelTextEditingController.text.trim(),
        "ev": isChecked,
        "et": selectedCarType,
      },
    );
    print(res.affectedRows);

    await conn.close();
    Fluttertoast.showToast(msg: "the car registered successfully");
    Navigator.pop(context);
  }
}
