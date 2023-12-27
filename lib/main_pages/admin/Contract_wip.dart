import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Contract_list extends StatefulWidget {
  @override
  _Contract_listState createState() => _Contract_listState();
}

class _Contract_listState extends State<Contract_list> {
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
      "SELECT * FROM contract ORDER BY Con_No ASC",

    );

    List<Map<String, dynamic>> list = [];

    for (final row in results.rows) {
      final data = {
        'contract_number': row.colByName("Con_No"),
        'contract_Date_of_issue': row.colByName("Con_Date_of_issue"),
        'contract_Beginning_of_Rent_date': row.colByName("Con_Beginning_of_Rent_date"),
        'contract_End_of_Rent_date': row.colByName("Con_End_of_Rent_date"),
        'reservartion_number_for_contract': row.colByName("Res_num"),
      };
      list.add(data);
    }

    setState(() {
      invoices = list;
      print (invoices);
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
        title: Text('contract'),
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
                title: Text('contract_number: ${invoices[index]['contract_number']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('contract Date of issue: ${invoices[index]['contract_Date_of_issue']}'),
                    Text('contract Beginning of Rent date: ${invoices[index]['contract_Beginning_of_Rent_date']}'),
                    Text('contract End of Rent date: ${invoices[index]['contract_End_of_Rent_date']}'),
                    Text('reservartion number for contract: ${invoices[index]['reservartion_number_for_contract']}'),

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
            "Contract",
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
                "Contract",
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
                "Contract details",
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
                    pw.Flexible(child:pw.Text("Contract num: $num")),
                    pw.Flexible(child:pw.Text("contract Date of issue: $total")),
                    pw.Flexible(child:pw.Text("contract Beginning of Rent date: $date")),
                    pw.Flexible(child:pw.Text("contract End of Rent date: $vnum")),
                    pw.Flexible(child:pw.Text("Thank you for using this service")),

                  ]

              )

          )],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    var date = "${invoice['contract_Beginning_of_Rent_date']}";
    var num = "${invoice['contract_number']}";
    String? total = "${invoice['contract_Date_of_issue']}";
    String? vnum = "${invoice['contract_End_of_Rent_date']}";



    return Scaffold(
      appBar: AppBar(
        title: Text('Contract Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Contract Number: ${invoice['contract_number']}'),
          ),
          ListTile(
            title: Text('Contract Date: ${invoice['contract_Date_of_issue']}'),
          ),
          ListTile(
            title: Text('Contract start date: ${invoice['contract_Beginning_of_Rent_date']}'),
          ),
          ListTile(
            title: Text('Contract end date: ${invoice['contract_End_of_Rent_date']}'),
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
              "print contract",
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
    home: Contract_list(),
  ));
}
