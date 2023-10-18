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

  Future<void> generateTerms() async {
    // Generate terms for owner
    ownerTerms = 'Owner terms and conditions...';

    // Generate terms for renter
    renterTerms = 'Renter terms and conditions...';

    setState(() {});
    final conn = await MySQLConnection.createConnection(
      host: "10.0.2.2",   //when you use simulator
      //host: "10.0.2.2",   when you use emulator
      //host: "localhost"
      port: 3306,
      userName: "root",
      password: "root", // you need to replace with your password
      databaseName: "pvers", // you need to replace with your db name
    );

    await conn.connect();

    print("Connected");

    await conn.execute("INSERT INTO contract (owner_terms,renter_terms) VALUES (:vid1, :vn)",
        {
        "vid1": ownerTerms,
        "vn": renterTerms
        }
    );

  }

  Future<void> agreeOwnerTerms() async {
    setState(() {
      ownerAgreed = true;
    });

    print("Connecting to mysql server...");

    // create connection
    final conn = await MySQLConnection.createConnection(
      host: "10.0.2.2",   //when you use simulator
      //host: "10.0.2.2",   when you use emulator
      //host: "localhost"
      port: 3306,
      userName: "root",
      password: "root", // you need to replace with your password
      databaseName: "pvers", // you need to replace with your db name
    );

    await conn.connect();

    print("Connected");
    await conn.execute("UPDATE contract SET owner_agreed = ownerAgreed WHERE id = 1");
  }

  Future<void> agreeRenterTerms() async {
    setState(() {
      renterAgreed = true;
    });
    print("Connecting to mysql server...");

    // create connection
    final conn = await MySQLConnection.createConnection(
      host: "10.0.2.2",   //when you use simulator
      //host: "10.0.2.2",   when you use emulator
      //host: "localhost"
      port: 3306,
      userName: "root",
      password: "root", // you need to replace with your password
      databaseName: "pvers", // you need to replace with your db name
    );

    await conn.connect();

    print("Connected");
    // Update the database to reflect the agreement
    await conn.execute("UPDATE contract SET renter_agreed = $renterAgreed WHERE id = 1");
  }

  Future<void> confirmAgreement() async {
    if (ownerAgreed && renterAgreed) {
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

      // Perform any additional actions or database updates as needed
    }
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
            ElevatedButton(
              onPressed: generateTerms,
              child: Text('Generate Contract Terms'),
            ),
            SizedBox(height: 20),
            Text(
              'Owner Terms and Conditions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(ownerTerms),
            SizedBox(height: 20),
            CheckboxListTile(
              title: Text('Agree to Owner Terms and Conditions'),
              value: ownerAgreed,
              onChanged: (value) => agreeOwnerTerms(),
            ),
            SizedBox(height: 30),
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
              onChanged: (value) => agreeRenterTerms(),
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