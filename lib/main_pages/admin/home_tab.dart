import 'package:flutter/material.dart';

import 'package:pvers_customer/MainScreens/main_screen.dart';

class hometabpage extends StatefulWidget {
  const hometabpage({super.key});

  @override
  State<hometabpage> createState() => _hometabpageState();
}

class _hometabpageState extends State<hometabpage> {
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
                  "Return to admin page",
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
