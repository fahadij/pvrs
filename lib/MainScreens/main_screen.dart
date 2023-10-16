import 'package:flutter/material.dart';
import 'package:pvers_customer/authentication/login_screen.dart';
import 'package:pvers_customer/tab_pages/home_tab.dart';
import 'package:pvers_customer/authentication/host_a_vehicle.dart';
import 'package:pvers_customer/tab_pages/profile.dart';
import 'package:pvers_customer/authentication/rent_a_vehicle.dart';



import '../authentication/Complaine_page.dart';
import '../authentication/FAQ.dart';
import '../authentication/Payment_page.dart';
import '../authentication/signup_page.dart';
import '../authentication/Select_page.dart';
import '../authentication/My_vehicle_page.dart';

class MainScreen extends StatefulWidget
{


  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}
/*final Completer<GoogleMapController> _controllerGoogleMap = Completer<GoogleMapController>();
  GoogleMapController? newGoogleMapController;*/

//for dark mode

/*static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);


      Future<void> _fetchVehicles() async {
    print("Connecting to MySQL server...");
    final MySqlConnection conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'pvers.mysql.database.azure.com', // e.g., '10.0.2.2'
      port: 3306,
      user: 'root',
      db: 'pvers',
       password: 'wI@AyQmT7Xd3WbIJ',
    ));
    print("Connected");
    var results = await conn.query('SELECT * FROM vehicle');

    for (var row in results) {
      setState(() {
        vehicles.add(row.fields); // Assuming fields is a Map
      });
    }

    await conn.close();
  }

      */



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

    tabController = TabController(length: 8, vsync: this);
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
         VehicleRenterPage(),
         FAQScreen(),
         Complaints_page(),
         PaymentPage(),
         SelectPage(),
         profilepage(),
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
            label: "host a car",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.car_rental_sharp),
            label: "Rent a car",
          ),



          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: "QA",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.speaker),
            label: "Complaints page",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: "Payment",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_travel),
            label: "My Vehicles",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "profile",
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
