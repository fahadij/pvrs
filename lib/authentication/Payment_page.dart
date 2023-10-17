import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MainScreens/main_screen.dart';







class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  TextEditingController amountController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expirationController = TextEditingController();
  String? token21;
  String? userId;

 void  initState(){
   getCred();
  }
  getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
         
      userId = pref.getString("ID1");
      print("this is the id that is conected$userId");
      amountController.text = pref.getString("TotalPrice")!;
      var test = pref.getString("TotalPrice");
      print("this is the full price for the rent$test");
      //nameTextEditingController.text =
    });
  }

  Future<void> makePayment(double amount, String cardNumber, String expirationDate,String? userId ) async {
    print("Connecting to mysql server...");

    final conn = await MySQLConnection.createConnection(
        host: '10.0.2.2',
        port: 3306,
        userName: 'root',
        password: 'root',
        databaseName: 'pvers');
    print("Connected");
    String? expirationDate = expirationController.text;

    DateTime now = DateTime.now();
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
        "INSERT INTO invoice (invoice_total_price, card_number, expiration_date, user_id, invoice_date) VALUES (:vid1, :vn, :vm, :ev, :et)",
        {
          "vid1": amount,
          "vn": cardNumber,
          "vm": date,
          "ev": userId,
          "et": formattedDate,
        }
    );
    print(res.affectedRows);
    await conn.close();
  }

  void makePaymentAndNavigate() async {
    double amount = double.parse(amountController.text);
    String cardNumber = cardNumberController.text;
    String expirationDate = expirationController.text;
    // Assuming user ID is 1 for this example.
    getCred();
    DateTime now = DateTime.now();

    await makePayment(amount, cardNumber, expirationDate, userId);

    // Navigate to homepage after payment
    // Assuming you want to go back to the previous screen
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
              controller: expirationController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Expiration Date (MM/YY)'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed:(){ makePaymentAndNavigate;
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
                );
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