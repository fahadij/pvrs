import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysql1/mysql1.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:printing/printing.dart';
import 'package:pvers_customer/authentication/Select_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


class Reservationpage extends StatefulWidget {
  @override
  _ReservationpageState createState() => _ReservationpageState();
}

class _ReservationpageState extends State<Reservationpage> {
  List<Map<String, dynamic>> invoices = [];


  Future<void> fetchReservations() async {
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
      "SELECT * FROM reservation WHERE V_Renter_Id = $token2 ORDER BY RESno ASC",

    );

    List<Map<String, dynamic>> list = [];

    for (final row in results.rows) {
      final data = {
        'reservation_num': row.colByName("RESno"),
        'RES_DateTime_start1': row.colByName("RES_DateTime_start"),
        'RES_DateTime_end1': row.colByName("RES_DateTime_end"),
        'res_Status': row.colByName("RES_Status"),
        'reservation_Vehicle_number': row.colByName("V_num_RES"),
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
    fetchReservations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resrvation'),
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
                title: Text(
                    'Resrvation Number: ${invoices[index]['reservation_num']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'start Date: ${invoices[index]['RES_DateTime_start1']}'),
                    Text('end  Date: ${invoices[index]['RES_DateTime_end1']}'),
                    Text('Res status: ${invoices[index]['res_Status']}'),
                    Text(
                        'VID: ${invoices[index]['reservation_Vehicle_number']}'),
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



  Future<void> printInvoice(String? date, String? num, String? total, String? vnum, String? status) async {
    final image = await imageFromAssetBundle("images/logo-color.png");

    final doc = pw.Document();
    doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) => buildPrintableData(context, image,date,total,num, vnum, status),
    ));
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  pw.Widget buildPrintableData(pw.Context context, image,date, total, num, vnum, status) {
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
              height: 100.00,
              child:pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children:[
                    pw.Flexible(child:pw.Text("Reservation num: $num")),
                    pw.Flexible(child:pw.Text("Reservation start date: $date")),
                    pw.Flexible(child:pw.Text("Reservation end date: $total")),
                    pw.Flexible(child:pw.Text("vehicle number: $vnum")),
                    pw.Flexible(child:pw.Text("Reservation Status: $status")),
                    pw.Flexible(child:pw.Text("Thank you for using this service")),

                  ]

              )

          )],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    var start_date = "${invoice['RES_DateTime_start1']}";
    var num = "${invoice['reservation_num']}";
    String? total = "${invoice['RES_DateTime_end1']}";
    String? vnum = "${invoice['reservation_Vehicle_number']}";
    String? status = "${invoice['res_Status']}";



    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('reservation Number: ${invoice['reservation_num']}'),
          ),
          ListTile(
            title: Text('Start Date: ${invoice['RES_DateTime_start1']}'),
          ),
          ListTile(
            title: Text('End Date: ${invoice['RES_DateTime_end1']}'),
          ),
          ListTile(
            title: Text('Res Status: ${invoice['res_Status']}'),
          ),
          ListTile(
            title: Text('vehicle number: ${invoice['reservation_Vehicle_number']}'),
          ),
          ListTile(
            title: Text('Thank you for using our services'),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () {
              printInvoice(start_date, num, total,vnum,status);
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
              showDialog(context: context,
              builder: (BuildContext context) {
                      return AlertDialog(
                      title: Text("Are you sure?"),
                      content: Text("Do you want to cancle the reservation?"),
                       actions: [
                        TextButton(
                         onPressed: () {
                         Navigator.of(context).pop(); // Close the dialog
                        },
                         child: Text("No"),
                        ),
                       TextButton(
                       onPressed: (){
                       cancel();
                       Navigator.of(context).pop();
                         },
                        child: Text("Yes"),

                      ),
                      ],
                      );
                       },
                      );
                      },
            //Navigator.push(context,MaterialPageRoute(builder: (c) => const MainScreen()));


            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            child: const Text
              (
              "cancele reservation",
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
  Future<void> cancel() async{

    print("Connecting to mysql server...");
    var num1 = "${invoice['reservation_num']}";


    final conn = await MySQLConnection.createConnection(
        host: '10.0.2.2',
        port: 3306,
        userName: 'root',
        password: 'root',
        databaseName: 'pvers');

    await conn.connect();
    print("Connected");
    var res = await conn.execute("UPDATE reservation SET RES_Status='canceled' WHERE RESno = '$num1'");

    print(res.affectedRows);

    await conn.close();


    Fluttertoast.showToast(msg: "the Vehicle removed successfully");

  }
}

void main() {
  runApp(MaterialApp(
    home: Reservationpage(),
  ));
}
