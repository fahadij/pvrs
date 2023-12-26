import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysql1/mysql1.dart';
import 'package:mysql_client/mysql_client.dart';
import 'home_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_screen.dart';







class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  TextEditingController amountController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expirationController = TextEditingController();
  TextEditingController CCVController = TextEditingController();
  String? token21;
  String? userId;
  String? reservationDateStringstart;
  String? reservationDateStringend;
  String active = "active";
  String pending = "pending";
  var contract_id1;
var lastInsertId;

 void  initState(){
   getCred();
  }

  validateForm() async {

    if (cardNumberController.text.length < 16) {
      Fluttertoast.showToast(msg: "card number must be 16 digit.");
    }
    else  if (CCVController.text.length < 3) {
      Fluttertoast.showToast(msg: "CCV must be 3 numbers.");
    }
    else {
    makePayment();
    }

  }
  getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
         contract_id1 = pref.getString("Contract_id");
      userId = pref.getString("ID1");
      amountController.text = pref.getString("TotalPrice")!;
        token21 = pref.getString("selectedVIDreft")!;
      reservationDateStringstart = pref.getString("reservationDateTimestartString") ;
      reservationDateStringend = pref.getString("reservationDateStringen");

        print("this is the value of token2:$token21");
        print("this is the value of reservation date$reservationDateStringstart");
        print("this is the value of reservation date$reservationDateStringend");


    });
  }

  Future<void> makePayment() async {
    double amount = double.parse(amountController.text);
    String cardNumber = cardNumberController.text;
    String expirationDate = expirationController.text;
    getCred();
    DateTime now = DateTime.now();
    print("Connecting to mysql server...");

    final conn = await MySQLConnection.createConnection(
        host: '10.0.2.2',
        port: 3306,
        userName: 'root',
        password: 'root',
        databaseName: 'pvers');

    print("Connected");

DateTime now2 = DateTime.now();
    int? day = now2.day;
    List<String> dateParts = expirationDate.split('/');
    String year = dateParts[1];
    String month = dateParts[0];
    String date = "20$year-$month-$day";
    print(date);
    DateTime formattedDate = DateTime.now();
    await conn.connect();
    var res = await conn.execute(
        "INSERT INTO invoice (invoice_total_price, card_number, expiration_date, user_id, invoice_date,invoice_VNUM) VALUES (:vid1, :vn, :vm, :ev, :et, :Vnum)",
        {
          "vid1": amount,
          "vn": cardNumber,
          "vm": date,
          "ev": userId,
          "et": formattedDate,
          "Vnum":token21,
        });
    await conn.close();
    _createReservation();

    print(res.affectedRows);

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen_renter()));
  }
  Future<void> _createReservation() async {
    print("Connecting to mysql server... _createReservation");
    final connection = await MySQLConnection.createConnection(
      host: '10.0.2.2',
      port: 3306,
      userName: 'root',
      password: 'root',
      databaseName: 'pvers',
    );
    print("Connected _createReservation");



    // Execute the query
    final reservationDateTime = DateTime.parse(reservationDateStringstart!);
    final now = DateTime.now();
    await connection.connect();
    if (now.isBefore(reservationDateTime!)) {
      var res = await connection.execute(
          "INSERT INTO reservation (V_num_RES, V_Renter_Id, RES_DateTime_start, RES_DateTime_end,RES_Status) VALUES (:vid1, :vn, :vm, :ev, :et)",
          {
            "vid1": token21,
            "vn": userId,
            "vm": reservationDateStringstart,
            "ev": reservationDateStringend,
            "et": pending,
          });
      //contract_id1
      var lastInsertId = res.lastInsertID;
      String lastInsertId1 = lastInsertId.toString();
      var res3 = await connection.execute(
            "UPDATE contract SET Res_num = '$lastInsertId1' WHERE Con_No = '$contract_id1'");
      print(res.affectedRows);
      var affeted = res3.affectedRows;
      print("this is for the update for the contract:$affeted");

    } else if (now.isAfter(reservationDateTime!)) {
      var res = await connection.execute(
          "INSERT INTO reservation (V_num_RES, V_Renter_Id, RES_DateTime_start, RES_DateTime_end,RES_Status) VALUES (:vid1, :vn, :vm, :ev, :et)",
          {
            "vid1": token21,
            "vn": userId,
            "vm": reservationDateStringstart,
            "ev": reservationDateStringend,
            "et": active,
          });
      lastInsertId = res.lastInsertID;
      String lastInsertId1 = lastInsertId.toString();


      var res3 = await connection.execute(
          "UPDATE contract SET Res_num = '$lastInsertId1' WHERE Con_No = '$contract_id1'");
      print(res.affectedRows);
      var affeted = res3.affectedRows;
      print("this is for the update for the contract:$affeted");
      print(res.affectedRows);
    }
    connection.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment Page')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: amountController,
              readOnly: true,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Amount'),
            ),
            TextField(
              controller: cardNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Card Number'),
            ),
            TextField(
              controller: CCVController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'CCV Number'),
            ),
            TextField(
              controller: expirationController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Expiration Date (MM/YY)'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed:(){ validateForm();
                },
              child: Text('Make Payment'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PaymentPage(),
  ));
}