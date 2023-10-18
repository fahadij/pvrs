import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoicePage extends StatefulWidget {
  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  List<Map<String, dynamic>> invoices = [];


  Future<void> fetchInvoices() async {
    String? token2;
    SharedPreferences pref = await SharedPreferences.getInstance();
    token2 = pref.getString("ID1")!;

    final conn = await MySQLConnection.createConnection(
      host: "10.0.2.2",
      port: 3306,
      userName: "root",
      password: "root",
      databaseName: "pvers",
    );

    await conn.connect();
    var results = await conn.execute(
        "SELECT * FROM invoice WHERE user_id = $token2 ORDER BY invoice_num ASC",

    );

    List<Map<String, dynamic>> list = [];

    for (final row in results.rows) {
      final data = {
        'invoice_num': row.colByName("invoice_num"),
        'invoice_date': row.colByName("invoice_date"),
        'invoice_con_No': row.colByName("conNo"),
        'invoice_total_price': row.colByName("invoice_total_price"),
      };
      list.add(data);
    }

    setState(() {
      invoices = list;
    });

    await conn.close();
  }

  @override
  void initState() {
    super.initState();
    fetchInvoices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoices'),
      ),
      body: ListView.builder(
        itemCount: invoices.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      InvoiceDetailPage(invoice: invoices[index]),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.all(8),
              child: ListTile(
                title: Text('Invoice Number: ${invoices[index]['invoice_num']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date: ${invoices[index]['invoice_date']}'),
                    Text('Total Price: ${invoices[index]['invoice_total_price']}SAR'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class InvoiceDetailPage extends StatelessWidget {
  final Map<String, dynamic> invoice;

  InvoiceDetailPage({required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Invoice Number: ${invoice['invoice_num']}'),
          ),
          ListTile(
            title: Text('Date: ${invoice['invoice_date']}'),
          ),
          ListTile(
            title: Text('Total Price: ${invoice['invoice_total_price']}SAR'),
          ),
          // Add more ListTile widgets for other attributes if needed
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: InvoicePage(),
  ));
}