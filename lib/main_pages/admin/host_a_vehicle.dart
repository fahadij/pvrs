import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:pvers_customer/MainScreens/main_screen.dart';
import 'package:pvers_customer/authentication/login_screen.dart';
import 'package:pvers_customer/tab_pages/home_tab.dart';
import 'package:pvers_customer/widgets/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'image_show_vehicle.dart';

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
  TextEditingController vehicleRateTextEditingController = TextEditingController();
  TextEditingController imageTextEditingController = TextEditingController();
  TextEditingController vehicleLocationTextEditingController = TextEditingController();
  List<String> carTypesList = ["size-big", "size-medium", "size-small"];
  String? selectedCarType;
  bool isChecked = false;
  TextEditingController idTextEditingController = TextEditingController();
  String token= "";
  File? _imageFile;
  String? imageLink_front="";

  Future<void> _uploadImage_front() async {
    String? id5 = idTextEditingController.text;
    String? id6 = vehiclenumTextEditingController.text;

    final storageRef = FirebaseStorage.instance.ref().child('images/vehicle/$id5/$id6');
    final imageName = _imageFile!.path.split('/').last;
    final imageRef = storageRef.child(imageName);

    final uploadTask = imageRef.putFile(_imageFile!);
    final snapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await snapshot.ref.getDownloadURL();

    setState(() {
      imageLink_front = downloadUrl;
    });

    print(imageLink_front);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCred();
  }
  void getCred() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token= pref.getString("ID1")!;
      idTextEditingController.text =  token;

    });
  }

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

              TextField(
                controller: vehicleRateTextEditingController,
                keyboardType: TextInputType.number,

                style: const TextStyle(
                  color: Colors.grey,
                ),
                decoration: const InputDecoration(
                  labelText: "vehicleRate",
                  hintText: "vehicleRate",

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
                  "Register Vehicle",
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
                  "Rturn to home page",
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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
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

    else if (selectedCarType == null) {
      Fluttertoast.showToast(msg: "the Vehicle type must not be empty.");
    }
    //if{ imageLink_front == null}{
//  Fluttertoast.showToast(msg: "the Vehicle image must not be empty.");
  //}
    else

      {
        Fluttertoast.showToast(msg: "Processing, Please wait");
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
        }
        else {
          print("vehicle is not found");
          insert();
          _uploadImage_front();
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
    var res = await conn.execute("INSERT INTO vehicle (V_num,V_Name,V_Model,V_EV,V_Type,owner_id_V,V_pictures_front,V_Rate) VALUES (:vid1, :vn, :vm, :ev, :et, :uid ,:pvo,:rate)",
      {
        "vid1": vehiclenumTextEditingController.text.trim(),
        "vn": vehiclenameTextEditingController.text.trim(),
        "vm": vehiclemodelTextEditingController.text.trim(),
        "ev": isChecked,
        "et": selectedCarType,
        "uid":idTextEditingController.text,
        "pvo":imageLink_front,
        "rate":vehicleRateTextEditingController.text,
      },
    );
    print(res.affectedRows);

    await conn.close();
    Fluttertoast.showToast(msg: "the Vehicle registered successfully");
  }
}
