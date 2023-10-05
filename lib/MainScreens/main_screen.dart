import 'package:flutter/material.dart';
import 'package:pvers_customer/tab_pages/home_tab.dart';
import 'package:pvers_customer/authentication/host_a_vehicle.dart';
import 'package:pvers_customer/tab_pages/profile.dart';
import 'package:pvers_customer/tab_pages/rent_a_car.dart';

import '../authentication/signup_page.dart';

class MainScreen extends StatefulWidget
{


  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}




class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin
{


 TabController? tabController;
  int selectedIndex = 0;

  onItemClicked(int index){

    setState(() {
      selectedIndex = index;
      tabController!.index = selectedIndex;
    });
  }


 @override
  void initState(){
    super.initState();

    tabController = TabController(length: 5, vsync: this);
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
     body: TabBarView(
       physics: NeverScrollableScrollPhysics(),
       controller: tabController,
       children:  [
         hometabpage(),
         hostacarpage(),
         rentacarpage(),
         profilepage(),
         signupscreen(),
       ],
     ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.car_rental),
            label: "Rent a car",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.car_rental_sharp),
            label: "host a car",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "profile",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: "signup screen",
          ),
        ],
        unselectedItemColor: Colors.white54,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 14),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
    ),
    );


  }
}
