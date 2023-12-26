import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:pvers_customer/main_pages/renter/Payment_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VehicleRentalContractPage extends StatefulWidget {


  VehicleRentalContractPage();

  @override
  _VehicleRentalContractPageState createState() => _VehicleRentalContractPageState();
}

class _VehicleRentalContractPageState extends State<VehicleRentalContractPage> {
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
  var vrate_1;
  var amount;
  var lastInsertId;
  @override
  void initState() {
    super.initState();
    getCred();



  }
  getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {

      userId = pref.getString("ID1");
      token21 = pref.getString("selectedVIDreft")!;
      reservationDateStringstart = pref.getString("reservationDateTimestartString") ;
      reservationDateStringend = pref.getString("reservationDateStringen");
      amount = pref.getString("TotalPrice")!;

      print("this is the value of token2:$token21");
      print("this is the value of reservation date$reservationDateStringstart");
      print("this is the value of reservation date$reservationDateStringend");

      fetchVehicleData(token21);
    });
  }



  Future<void> fetchVehicleData(String vehicleId) async {
    try {
      var owner_id;
      var VehicleId = int.parse(vehicleId);
      final conn = await MySQLConnection.createConnection(
          host: '10.0.2.2',
          port: 3306,
          userName: 'root',
          password: 'root',
          databaseName: 'pvers');

      await conn.connect();

      final results = await conn.execute("SELECT * FROM vehicle WHERE V_num = $VehicleId");
      for (final row in results.rows) {
        setState(() {
          Vnum  = row.colByName("V_num")!;
          Vname = row.colByName("V_Name")!;
          Vmodel = row.colByName("V_Model")!;
          owner_id = row.colByName("owner_id_V")!;
          vrate_1 = row.colByName("V_Rate")!;

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
            Text('PEER-TO-PEER VEHICLE RENTAL AGREEMENT', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('USER: ${userId}'),
            SizedBox(height: 16),
            Text('VEHICLE DETAILS:'),
            Text('Make: $Vname'),
            Text('Model: $Vmodel'),
            Text('price: ${amount}'),
            // Include other details as needed
            SizedBox(height: 16),
            SizedBox(height: 16),
            Text('TERMS AND CONDITIONS:'),
            Text('1. RENTAL PERIOD:'),
            Text('   1.1 The rental period shall begin on $reservationDateStringstart  and end on $reservationDateStringend.'),
            Text('2. RENTAL FEE:'),
            Text('   2.1 The User agrees to pay the Owner a total rental fee of $amount SAR for the entire rental period.'),
            Text('   2.2 Payment shall be made before the start of the rental period.'),
            Text('3. SECURITY DEPOSIT:'),
            Text('   3.1 The User agrees to provide a security deposit of [Deposit Amount] to cover any damages or violations.'),
            Text('   3.2 The security deposit will be refunded within [Number of Days] after the end of the rental period, less any deductions for damages or violations.'),
            Text('4. CONDITION OF THE VEHICLE:'),
            Text('   4.1 The Owner agrees to provide the User with the vehicle in good working condition.'),
            Text('   4.2 The User agrees to return the vehicle in the same condition, normal wear and tear excepted.'),
            Text('5. USE OF THE VEHICLE:'),
            Text('   5.1 The User agrees to use the vehicle for personal use only and not for any illegal or prohibited activities.'),
            Text('   5.2 Smoking and pets are prohibited inside the vehicle.'),
            Text('6. RESPONSIBILITIES:'),
            Text('   6.1 The User is responsible for any traffic violations, tolls, or fines incurred during the rental period.'),
            Text('   6.2 The Owner is responsible for maintaining the vehicle in compliance with local regulations.'),
            Text('7. INSURANCE:'),
            Text('   7.1 The Owner represents that the vehicle is adequately insured for the duration of the rental period.'),
            Text('   7.2 The User is responsible for any deductibles or damages not covered by insurance.'),
            Text('8. CANCELLATION:'),
            Text('   8.1 In the event of cancellation, [Cancellation Policy] shall apply.'),
            Text('9. GOVERNING LAW:'),
            Text('   9.1 This Agreement shall be governed by and construed in accordance with the laws of saudi arabia.'),
            SizedBox(height: 16),
            SizedBox(height: 16),
            // Add checkboxes for owner and user agreements
            // ... contract text, including terms and conditions

            Row(
              children: [
                Checkbox(value: userAgreement, onChanged: (bool? value) => setState(() => userAgreement = value!)),
                Text('I agree to the terms and conditions as specified above (User)'),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: userAgreement ? _handleContractAcceptance : null,
              child: Text('Accept Contract'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleContractAcceptance() async {
    try {
      var date = DateTime.now();
      final conn = await MySQLConnection.createConnection(
          host: '10.0.2.2',
          port: 3306,
          userName: 'root',
          password: 'root',
          databaseName: 'pvers');

      await conn.connect();
print(userId);
      var res = await conn.execute(
          "INSERT INTO contract (Con_Date_of_issue, Con_Beginning_of_Rent_date, Con_End_of_Rent_date, Con_ToS_agreement,Rid_contract) VALUES (:vid1, :vn, :vm, :ev,:Rid_contract1)",
          {
            "vid1": date,
            "vn": reservationDateStringstart,
            "vm": reservationDateStringend,
            "ev": userAgreement,
            "Rid_contract1": userId,
          });
      lastInsertId = res.lastInsertID;
      final generatedId = lastInsertId.toString();

      print ("this is the value of the id$generatedId");
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('Contract_id', generatedId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contract accepted successfully!')),
      );
      Navigator.push(context, MaterialPageRoute(builder: (c)=> PaymentPage()));

      // Navigate to a confirmation page or back to the previous page
    } catch (e) {
      debugPrint('Error handling contract acceptance: $e');
    }
  }
}