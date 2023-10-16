import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VehicleDetailsPage extends StatefulWidget {

  @override
  _VehicleDetailsPageState createState() => _VehicleDetailsPageState();
}

class _VehicleDetailsPageState extends State<VehicleDetailsPage> {
  String? token2;
  Map<String, dynamic>? vehicleDetails;

  @override
  void initState() {
    super.initState();
    _getVehicleDetails();
  }

  Future<void> _getVehicleDetails() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token2 = pref.getString("selectedVID")!;
      print(token2);


      //nameTextEditingController.text =
    });
    print("Connecting to mysql server...");
    final conn = await MySQLConnection.createConnection(
        host: '10.0.2.2',
        port: 3306,
        userName: 'root',
        password: 'root',
        databaseName: 'pvers');

    await conn.connect();
    print("Connected");
    var results = await conn.execute(
        "SELECT V_num, V_Name, V_Model, V_Type, V_Location, V_Battery, V_Rate, V_EV, V_Image FROM vehicle WHERE V_num = $token2",);

    if (results.isNotEmpty) {
      for (final row in results.rows) {
        setState(() {
          vehicleDetails = row.assoc(); // Assuming your database returns a map of field names to values.
        });
      }
    }

    await conn.close();
  }

  @override
  Widget build(BuildContext context) {
    if (vehicleDetails == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vehicle Number: ${vehicleDetails?['V_num']}'),
            Text('Vehicle Name: ${vehicleDetails?['V_Name']}'),
            Text('Vehicle Model: ${vehicleDetails?['V_Model']}'),
            Text('Vehicle Type: ${vehicleDetails?['V_Type']}'),
            Text('Vehicle Location: ${vehicleDetails?['V_Location']}'),
            Text('Battery: ${vehicleDetails?['V_Battery']}'),
            Text('Rate: ${vehicleDetails?['V_Rate']}'),
            Text('Electric: ${vehicleDetails?['V_EV'] == 1 ? 'Yes' : 'No'}'),
            SizedBox(height: 20), // Add some spacing
            Center(
              child: Image.network(
                vehicleDetails?['V_Image'], // Assuming V_Image stores the image URL
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
