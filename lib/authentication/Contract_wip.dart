import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';

class ContractPage extends StatefulWidget {
  @override
  _ContractPageState createState() => _ContractPageState();
}

class _ContractPageState extends State<ContractPage> {
  String ownerTerms = '';
  String renterTerms = '';
  bool ownerAgreed = false;
  bool renterAgreed = false;


  Future<void> confirmAgreement() async {
    if (renterAgreed) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Contract Agreed"),
            content: Text("You have successfully agreed to the contract terms."),
            actions: [
              TextButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      print("Connecting to mysql server...");

      final conn = await MySQLConnection.createConnection(
          host: '10.0.2.2',
          port: 3306,
          userName: 'root',
          password: 'root',
          databaseName: 'pvers');

      print("Connected");
      var res = await conn.execute(
          "INSERT INTO contract ( card_number, expiration_date, user_id, invoice_date) VALUES (:vid1, :vn, :vm, :ev, :et)",
          {

            // Perform any additional actions or database updates as needed
          });}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contract Page'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(ownerTerms),
            SizedBox(height: 20),
            Text(
              'Renter Terms and Conditions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(renterTerms),
            SizedBox(height: 20),
            CheckboxListTile(
              title: Text('Agree to Renter Terms and Conditions'),
              value: renterAgreed,
              onChanged: (value) => confirmAgreement(),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: confirmAgreement,
              child: Text('Confirm Agreement'),
            ),
          ],
        ),
      ),
    );
  }
}


void main() {
  runApp(MaterialApp(home: ContractPage()));
}