import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VehicleRentalContractPage extends StatefulWidget {


  VehicleRentalContractPage();

  @override
  _VehicleRentalContractPageState createState() => _VehicleRentalContractPageState();
}

class _VehicleRentalContractPageState extends State<VehicleRentalContractPage> {
  List<Map<String, dynamic>> vehicleData = [];
  late bool ownerAgreement = false;
  late bool userAgreement = false;
  var Vnum ;
  var Vname ;
  var Vmodel ;
  var owner_id_int ;
  var userId;
  var token21;
  var reservationDateStringstart;
  var reservationDateStringend;
  @override
  void initState() {
    super.initState();

    fetchVehicleData(token21);


  }
  getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {

      userId = pref.getString("ID1");
      token21 = pref.getString("selectedVIDreft")!;
      reservationDateStringstart = pref.getString("reservationDateTimestartString") ;
      reservationDateStringend = pref.getString("reservationDateStringen");

      print("this is the value of token2:$token21");
      print("this is the value of reservation date$reservationDateStringstart");
      print("this is the value of reservation date$reservationDateStringend");


    });
  }



  Future<void> fetchVehicleData(int vehicleId) async {
      try {
        var owner_id = "";
        final conn = await MySQLConnection.createConnection(
            host: '10.0.2.2',
            port: 3306,
            userName: 'root',
            password: 'root',
            databaseName: 'pvers');

        await conn.connect();

        final results = await conn.execute("SELECT * FROM vehicle WHERE V_num = $vehicleId");
        for (final row in results.rows) {
          setState(() {
            Vnum  = row.colByName("V_num")!;
            Vname = row.colByName("V_Name")!;
            Vmodel = row.colByName("V_Model")!;
            owner_id = row.colByName("V_Model")!;


        },);
        };

         owner_id_int =int.parse(owner_id);
        await conn.close();
      } catch (e) {
        debugPrint('Error fetching owner data: $e');
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Rental Contract'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // ... contract text, including terms and conditions
            Row(
              children: [
                Checkbox(value: ownerAgreement, onChanged: (bool? value) => setState(() => ownerAgreement = value!)),
                Text('I agree to the terms and conditions as specified above (Owner)'),
              ],
            ),
            Row(
              children: [
                Checkbox(value: userAgreement, onChanged: (bool? value) => setState(() => userAgreement = value!)),
                Text('I agree to the terms and conditions as specified above (User)'),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: ownerAgreement && userAgreement ? _handleContractAcceptance : null,
              child: Text('Accept Contract'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleContractAcceptance() async {
    try {
      final conn = await MySQLConnection.createConnection(
          host: '10.0.2.2',
          port: 3306,
          userName: 'root',
          password: 'root',
          databaseName: 'pvers');

      await conn.connect();

      final results = await conn.execute('INSERT INTO contract (...) VALUES (...)');

      // Update vehicle status
      final results2 = await conn.execute('UPDATE vehicle SET V_Status = 1 WHERE V_num = ?', token21);

      // Send confirmation emails (if applicable)

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contract accepted successfully!')),
      );
      // Navigate to a confirmation page or back to the previous page
    } catch (e) {
      debugPrint('Error handling contract acceptance: $e');
    }
  }
}