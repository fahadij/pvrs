import 'package:flutter/material.dart';
import 'package:pvers_customer/MainScreens/main_screen.dart';
import 'package:pvers_customer/tab_pages/home_tab.dart';

class hostacarpage extends StatefulWidget {
  const hostacarpage({super.key});

  @override
  State<hostacarpage> createState() => _hostacarpageState();
}

class _hostacarpageState extends State<hostacarpage>
{
  TextEditingController vehiclenumTextEditingController = TextEditingController();
  TextEditingController vehiclenameTextEditingController = TextEditingController();
  TextEditingController vehiclemodelTextEditingController = TextEditingController();
  TextEditingController vehicleEVTextEditingController = TextEditingController();
  List<String> carTypesList = ["size-big","size-medium","size-small"];
  String? selectedCarType;
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
                  onChanged: (newValue){
                   setState(() {
                    selectedCarType = newValue.toString();
                    });
                   },
                  items: carTypesList.map((car){
                    return DropdownMenuItem(
                     child: Text(
                       car,
                       style: const TextStyle(
                         color: Colors.grey
                       ) ,
                     ),
                      value: car,
                    );
                  }).toList(),
              ),


              TextField(
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


              ),

              const SizedBox(height: 20,),
              ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> const MainScreen()));
                },
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
}