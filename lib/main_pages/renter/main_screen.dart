import 'package:flutter/material.dart';
import 'home_tab.dart';
import 'profile.dart';
import 'rent_a_vehicle.dart';
import 'Complaine_page.dart';
import 'FAQ.dart';


class MainScreen_renter extends StatefulWidget
{


  const MainScreen_renter({super.key});

  @override
  State<MainScreen_renter> createState() => _MainScreen_renterState();
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
      host: '10.0.2.2', // e.g., '10.0.2.2'
      port: 3306,
      user: 'root',
      db: 'pvers',
      password: 'root',
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



class _MainScreen_renterState extends State<MainScreen_renter> with SingleTickerProviderStateMixin
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
         VehicleRenterPage(),
         FAQScreen(),
         Complaints_page(),
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
            icon: Icon(Icons.directions_bike),
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
