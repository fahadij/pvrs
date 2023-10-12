import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class VehicleRenterPage extends StatefulWidget {
  @override
  _VehicleRenterPageState createState() => _VehicleRenterPageState();
}

class _VehicleRenterPageState extends State<VehicleRenterPage> {
  List<Map<String, dynamic>> vehicles = [];

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Renter'),
      ),
      body: ListView.builder(
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Name: ${vehicles[index]['name']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Model: ${vehicles[index]['model']}'),
                Text('Type: ${vehicles[index]['type']}'),
                Text('Status: ${vehicles[index]['status']}'),
                Text('Location: ${vehicles[index]['location']}'),
                Text('Battery: ${vehicles[index]['battery']}'),
                Text('Rate: ${vehicles[index]['rate']}'),
                Text('EV: ${vehicles[index]['ev']}'),
              ],
            ),
          );
        },
      ),
    );
  }
}