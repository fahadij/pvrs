import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'authentication/image_show_vehicle.dart';

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
        'invoice_Vehicle_number': row.colByName("invoice_VNUM"),
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
                    Text('invoice_Vehicle_number: ${invoices[index]['invoice_Vehicle_number']}'),
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



  Future<void> printInvoice(String? date, String? num, String? total, String? vnum) async {
    final image = await imageFromAssetBundle("images/logo-color.png");

    final doc = pw.Document();
    doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) => buildPrintableData(context, image,date,total,num, vnum),
    ));
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  pw.Widget buildPrintableData(pw.Context context, image,date, total, num, vnum) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(25.00),
      child: pw.Column(

        children: [
          pw.Text(
            "invoice",
            style: pw.TextStyle(fontSize: 25.00, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10.00),
          pw.Divider(),
          pw.Align(
            alignment: pw.Alignment.center,
            child: pw.Image(
              image,
              height: 250,
              width: 250,
            ),
          ),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.SizedBox(width: 5.5),
              pw.Text(
                "Invoice",
                style: pw.TextStyle(fontSize: 23.00, fontWeight: pw.FontWeight.bold),
              )
            ],
          ),
          pw.SizedBox(height: 10.00),
          pw.Container(
            color: const PdfColor(0.5, 1, 0.5, 0.7),
            width: double.infinity,
            height: 36.00,
            child: pw.Center(
              child: pw.Text(
                "Invoice details",
                style: pw.TextStyle(
                  color: const PdfColor(0.2, 0.2, 0.2, 0.2),
                  fontSize: 20.00,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ),
            pw.Container(
              width: double.infinity,
              height: 50.00,
              child:pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                    children:[
                      pw.Flexible(child:pw.Text("invoice num: $num")),
                      pw.Flexible(child:pw.Text("invoice total price: $total")),
                      pw.Flexible(child:pw.Text("invoice date: $date")),
                      pw.Flexible(child:pw.Text("vehicle number: $vnum")),
                      pw.Flexible(child:pw.Text("Thank you for using this service")),

              ]

                  )

            )],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    var date = "${invoice['invoice_date']}";
    var num = "${invoice['invoice_num']}";
    String? total = "${invoice['invoice_total_price']}";
    String? vnum = "${invoice['invoice_Vehicle_number']}";



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
          ListTile(
            title: Text('vehicle number: ${invoice['invoice_Vehicle_number']}'),
          ),
          ListTile(
            title: Text('Thank you for using our services'),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () {
              printInvoice(date, num, total,vnum);
            },
            //Navigator.push(context,MaterialPageRoute(builder: (c) => const MainScreen()));


            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightGreenAccent,
            ),
            child: const Text
              (
              "print invoice",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18,
              ),

            ),
          ),
          ElevatedButton(
            onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => ImageUploadPagevehicle()));},

            //Navigator.push(context,MaterialPageRoute(builder: (c) => const MainScreen()));


            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightGreenAccent,
            ),
            child: const Text
              (
              "update vehicle images renter",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18,
              ),

            ),
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
