import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_preferences/shared_preferences.dart';



Future<void> makePayment(double amount, String cardNumber, String expirationDate,String? userId ) async {
  print("Connecting to mysql server...");

  final conn = await MySQLConnection.createConnection(
      host: 'pvers.mysql.database.azure.com',
      port: 3306,
      userName: 'nawaf',
       password: 'wI@AyQmT7Xd3WbIJ',
      databaseName: 'pvers');
  print("Connected");

  DateTime now = DateTime.now();

  String formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  await conn.connect();
  var res = await conn.execute(
    "INSERT INTO invoice (invoice_total_price, card_number, expiration_date, user_id, invoice_date) VALUES (:vid1, :vn, :vm, :ev, :et)",
      {
        "vid1": amount,
        "vn": cardNumber,
        "vm": expirationDate,
        "ev": userId,
        "et": formattedDate,
      }
  );
  print(res.affectedRows);
  await conn.close();
}



class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? token21;
  String? userId;
  getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
         
      userId = pref.getString("ID1");
      print("this is the id that is conected$userId");
      //nameTextEditingController.text =
    });
  }
  TextEditingController amountController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expirationController = TextEditingController();

  void makePaymentAndNavigate() async {
    double amount = double.parse(amountController.text);
    String cardNumber = cardNumberController.text;
    String expirationDate = expirationController.text;
    // Assuming user ID is 1 for this example.
    getCred();
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
              onPressed: makePaymentAndNavigate,
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