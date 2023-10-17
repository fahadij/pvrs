import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Payment_page.dart';

class VehicleDetailsPage extends StatefulWidget {

  @override
  _VehicleDetailsPageState createState() => _VehicleDetailsPageState();
}

class _VehicleDetailsPageState extends State<VehicleDetailsPage> {
  String? token2;
  Map<String, dynamic>? vehicleDetails;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String total ="";

  @override
  void initState() {
    super.initState();
    _getVehicleDetails();
  }

  Future<void> _getVehicleDetails() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token2 = pref.getString("selectedVIDreft")!;
      print("this is the value of token2:$token2");


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
        "SELECT V_num, V_Name, V_Model, V_Type, V_Location, V_Battery, V_Rate, V_EV FROM vehicle WHERE V_num = $token2");

    if (results.isNotEmpty) {
      for (final row in results.rows) {
        setState(() {
          vehicleDetails = row.assoc(); // Assuming your database returns a map of field names to values.
        });
      }
    }
    final SharedPreferences pref1 = await SharedPreferences.getInstance();
    await pref1.remove('selectedVIDreft');
    var token3 = pref.getString("selectedVIDreft")!;
    print(token3);
    await conn.close();
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }
  String calculateTotalPrice() {
    // Assuming rate is in dollars per hour
    double rate = double.parse(vehicleDetails?['V_Rate']);
    int hours = selectedTime.hour;
    int minutes = selectedTime.minute;

    DateTime selectedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      hours,
      minutes,
    );

    // Calculate total price
    double totalPrice = rate * (selectedDateTime.difference(DateTime.now()).inHours.toDouble());

    return totalPrice.toStringAsFixed(2);
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
            SizedBox(height: 20),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _selectDate(context);
              },
              child: Text('Select Date'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _selectTime(context);
              },
              child: Text('Select Time'),
            ),
            SizedBox(height: 10),
            Text('Total Price: \$${calculateTotalPrice()}'),
            SizedBox(height: 20),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () async {
                    SharedPreferences pref = await SharedPreferences.getInstance();
                    pref.setString('TotalPrice', calculateTotalPrice() );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaymentPage()),
                    );
                  },
                  child: Text('Rent it Now'),
                ),
              ),
            ),
            SizedBox(height: 20),

            SizedBox(height: 20),
            Center(
              /*child: Image.network(
                vehicleDetails?['V_Image'], // Assuming V_Image stores the image URL
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),*/
            ),
          ],
        ),
      ),
    );
  }
}
