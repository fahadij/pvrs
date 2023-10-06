import 'package:flutter/material.dart';

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
  TextEditingController vehicletypeTextEditingController = TextEditingController();
  TextEditingController vehicleEVTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24,),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset("images/logo-color.png"),
            ),


            const SizedBox(height: 10),

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

              style: TextStyle(
                color: Colors.grey,
              ),
              decoration: InputDecoration(
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
              style: TextStyle(
                color: Colors.grey,
              ),
              decoration: InputDecoration(
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

              style: TextStyle(
                color: Colors.grey,
              ),
              decoration: InputDecoration(
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
              controller: vehicletypeTextEditingController,
              keyboardType: TextInputType.text,
              obscureText: true,
              style: TextStyle(
                color: Colors.grey,
              ),
              decoration: InputDecoration(
                labelText: "vehicle Type",
                hintText: "vehicle Type",

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
              controller: vehicleEVTextEditingController,
              keyboardType: TextInputType.phone,
              style: TextStyle(
                color: Colors.grey,
              ),
              decoration: InputDecoration(
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

          ],

        ),
      ),

    );
  }
}