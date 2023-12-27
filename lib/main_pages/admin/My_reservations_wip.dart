import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysql1/mysql1.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:printing/printing.dart';
import 'package:awesome_notifications/awesome_notifications.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/data/latest.dart';

import 'Reservation_update.dart';


const int reminderNotificationTime = 3 * 60 * 60; // 3 hours before reservation


class ReservationpageAdmin extends StatefulWidget {
  @override

  _ReservationpageAdminState createState() => _ReservationpageAdminState();
}


class _ReservationpageAdminState extends State<ReservationpageAdmin> {
  List<Map<String, dynamic>> invoices = [];
  var token2;

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token2 = pref.getString("ID1")!;
      print(token2);
    });
  }


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
      "SELECT * FROM reservation ORDER BY RESno ASC",

    );

    List<Map<String, dynamic>> list = [];

    for (final row in results.rows) {
      final data = {
        'reservation_num': row.colByName("RESno"),
        'RES_DateTime_start1': row.colByName("RES_DateTime_start"),
        'RES_DateTime_end1': row.colByName("RES_DateTime_end"),
        'res_Status': row.colByName("RES_Status"),
        'reservation_Vehicle_number': row.colByName("V_num_RES"),
        'reservation_renter_id': row.colByName("V_Renter_Id"),
      };
      list.add(data);
    }

    setState(() {
      invoices = list;
    });

    await conn.close();
  }
  Future<void> updateReservationStatuses() async {
    String? token2;
    SharedPreferences pref = await SharedPreferences.getInstance();
    token2 = pref.getString("ID1")!;

    // Establish database connection
    final conn = await MySQLConnection.createConnection(
      host: "10.0.2.2",
      port: 3306,
      userName: "root",
      password: "root",
      databaseName: "pvers",
    );

    await conn.connect();

    // Fetch all reservations for the current user
    final results = await conn.execute(
      "SELECT * FROM reservation WHERE V_Renter_Id = $token2 ORDER BY RESno ASC",
    );

    // Loop through each reservation
    for (final row in results.rows) {
      final reservationId = row.colByName("RESno");
      final currentStatus = row.colByName("RES_Status");
      final startTime = DateTime.parse(row.colByName("RES_DateTime_start")!);
      final endTime = DateTime.parse(row.colByName("RES_DateTime_end")!);
      var vNID = row.colByName("V_num_RES");

      // Skip expired or canceled reservations
      if (currentStatus == "expired" || currentStatus == "canceled") {
        print("Skipping reservation $reservationId - already expired or canceled.");

        continue;
      }

      // Update pending reservation to active
      if (currentStatus == "pending" && DateTime.now().isAfter(startTime)) {
        await _updateStatus(conn, reservationId!, "active");
        //scheduleReservationNotification(reservationId, startTime, vNID );
        print("Reservation $reservationId activated successfully.");
      }

      // Update active reservation to expired
      if (currentStatus == "active" && DateTime.now().isAfter(endTime)) {
        await _updateStatus(conn, reservationId!, "expired");
        print("Reservation $reservationId expired successfully.");
      }

      if (currentStatus == "pending" && DateTime.now().isBefore(startTime)) {
        print("Reservation $reservationId is still pending but checked successfully.");
      }
    }

    // Close the database connection
    await conn.close();
  }

  Future<void> _updateStatus(conn, String reservationId, String newStatus) async {
    // Parse the reservationId to an int
    final int reservationIdInt = int.parse(reservationId);

    try {
      await conn.execute("UPDATE reservation SET RES_Status = '$newStatus' WHERE RESno = '$reservationIdInt'");
    } catch (e) {
      print("Error updating reservation status: ${e.toString()}");
    }
  }



  /*Future<void> scheduleReservationNotification(String reservationId, DateTime startTime, String? VID3) async {

    final serverTimeZone = "Asia/Riyadh";


    final reminderTime = startTime.add(Duration(seconds: reminderNotificationTime)).toUtc().atTime(TimeZone.parse(serverTimeZone));

    // Parse reservation ID to an int
    final int reservationIdInt = int.parse(reservationId);

    // Schedule notification using AwesomeNotifications

    await AwesomeNotifications().createDateTimeSchedule(
      notificationId: reservationIdInt,
      scheduleType: ScheduledNotificationType.Once,
      content: NotificationContent(
        title: "Reservation Reminder",
        body: "Your reservation number $reservationId for vehicle #$VID3 starts at ${startTime.toString()}",
      ),
      dateTime: reminderTime,
      dateInterpretation: DateTimeInterpretation.absoluteDateAndTime,
    );

    print("Scheduled notification for reservation $reservationId!");
  }*/






  @override
  void initState() {
    super.initState();
    updateReservationStatuses();
    fetchReservations();
    getCred();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservations'),
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
                    'Reservation Number: ${invoices[index]['reservation_num']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'start Date: ${invoices[index]['RES_DateTime_start1']}'),
                    Text('end  Date: ${invoices[index]['RES_DateTime_end1']}'),
                    Text('Res status: ${invoices[index]['res_Status']}'),
                    Text('VID: ${invoices[index]['reservation_Vehicle_number']}'),
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
            title: Text('Reservation Number: ${invoice['reservation_num']}'),
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
            title: Text('Renter ID: ${invoice['reservation_renter_id']}'),
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
              "Print Reservation",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18,
              ),

            ),
          ),
          ElevatedButton(
            onPressed: () {
              update();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpdateReservationPage()),
              );

            },

            //Navigator.push(context,MaterialPageRoute(builder: (c) => const MainScreen()));


            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightGreenAccent,
            ),
            child: const Text
              (
              "Update Reservation",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18,
              ),

            ),
          ),
          ElevatedButton(
            onPressed: () {
              Delete_and_archive_Complaint(num);
              Navigator.pop(context);
            },

            //Navigator.push(context,MaterialPageRoute(builder: (c) => const MainScreen()));


            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightGreenAccent,
            ),
            child: const Text
              (
              "archive Reservation",
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
              "cancel Reservation",
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
    var res2 = await conn.execute("UPDATE contract SET Con_status='canceled' WHERE RESno = '$num1'");
    print(res.affectedRows);
    print(res2.affectedRows);

    await conn.close();


    Fluttertoast.showToast(msg: "the Vehicle removed successfully");

  }
  Future<void> update() async {
    print("Connecting to MySQL server...");
    var num1 = "${invoice['reservation_num']}";
    try {
      final conn = await MySQLConnection.createConnection(
        host: '10.0.2.2',
        port: 3306,
        userName: 'root',
        password: 'root',
        databaseName: 'pvers',
      );

      await conn.connect();
      print("Connected");

      var res = await conn.execute(
        "SELECT * FROM reservation WHERE RESno = '$num1'",
      );

      for (final row in res.rows) {
        final reservationId = row.colByName("RESno");
        final currentStatus = row.colByName("RES_Status");
        final startTime = DateTime.parse(row.colByName("RES_DateTime_start")!);
        final endTime = DateTime.parse(row.colByName("RES_DateTime_end")!);
        final RVID2 = row.colByName("V_num_RES");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('start_date', startTime.toIso8601String());
        await prefs.setString('end_date', endTime.toIso8601String());
        await prefs.setString('RVID', RVID2!);
        await prefs.setString('RID1', reservationId!);
        print(startTime.toIso8601String());
        print(endTime.toIso8601String());
        if (currentStatus == "pending" && DateTime.now().isAfter(startTime)) {
          // Navigate to update page for pending reservations



        }
      }

      print(res.affectedRows);
      await conn.close();
    } catch (e) {
      print("Error: $e");
      // Handle connection errors appropriately
    }
  }
  Future<void> Delete_and_archive_Complaint(String reservationId) async {

    var num2 = int.parse(reservationId);
    var num1 = "${invoice['reservation_num']}";
    final conn = await MySQLConnection.createConnection(
        host: '10.0.2.2',
        port: 3306,
        userName: 'root',
        password: 'root',
        databaseName: 'pvers');
    await conn.connect();
    print(num2);
    var results = await conn.execute(
        "SELECT * FROM reservation WHERE RESno = $num2");
    var results2 = await conn.execute(
        "SELECT * FROM contract WHERE Res_num = $num2");

    var date1;
    var subject;
    var text;
    var currentStatus;
    var RVID2;
    var startTime;
    var endTime;
    var Con_no1;
    var DOI;
    var startTime1;
    var RES_no1;
    var RVID3;
    var TOS;
    var endTime1;
    var VNRES;
    if (results.isNotEmpty && results2.isNotEmpty ) {
      for (final row in results.rows) {
        reservationId = row.colByName("RESno")!;
        currentStatus = row.colByName("RES_Status");
        startTime = DateTime.parse(
            row.colByName("RES_DateTime_start")!);
        endTime = DateTime.parse(row.colByName("RES_DateTime_end")!);
        RVID2 = row.colByName("V_Renter_Id");
        VNRES = row.colByName("V_num_RES");
      }
      for (final row in results2.rows) {
        Con_no1 = row.colByName("Con_No")!;
        startTime1 = DateTime.parse(
            row.colByName("Con_Beginning_of_Rent_date")!);
        endTime1 = DateTime.parse(row.colByName("Con_End_of_Rent_date")!);
        RVID3 = row.colByName("Rid_contract");
        TOS = row.colByName("Con_ToS_agreement");
        RES_no1 = row.colByName("Res_num");
        DOI = row.colByName("Con_Date_of_issue");
      }
      var date = DateTime.now();
      String formattedDate = date
          .toString(); // This converts the DateTime to a string
      String formattedDate1 = date1.toString();

      print(num2);
      var resulst3 = await conn.execute(
          "INSERT INTO reservations_archive (RESno_old,RES_DateTime_start,RES_Status,V_num_RES,V_Renter_Id,RES_DateTime_end) VALUES (:complaint_sub1, :complaint_description1, :complaint_delete_date,:complaint_start_date,:owner_id1,:RES_DateTime_end1)",
          {
            "complaint_sub1": num2,
            "complaint_description1": startTime,
            "complaint_delete_date": currentStatus,
            "owner_id1": RVID2,
            "complaint_start_date": VNRES,
            "RES_DateTime_end1": endTime,
          }

      );
      var resulst4 = await conn.execute(
          "INSERT INTO contract_archive (Con_No_old,Con_Beginning_of_Rent_date,Con_End_of_Rent_date,Rid_contract,Con_ToS_agreement,Res_num,Con_Date_of_issue) VALUES (:complaint_sub1, :complaint_description1, :complaint_delete_date,:complaint_start_date,:owner_id1,:RES_DateTime_end1,:DOI2)",
          {
            "complaint_sub1": Con_no1,
            "complaint_description1": startTime1,
            "complaint_start_date":  RVID3 ,
            "complaint_delete_date": endTime1 ,
            "owner_id1": TOS,
            "RES_DateTime_end1": RES_no1,
            "DOI2": DOI,
          }

      );
      print (Con_no1);
      print(resulst4.affectedRows);
      var res6 = await conn.execute("DELETE FROM reservation WHERE RESno = $num2");
      var res7 = await conn.execute("DELETE FROM contract WHERE Con_No  = $Con_no1");
      var res_del = res6.affectedRows;
      var con_del = res7.affectedRows;
print ("this is the number of deleted rows from reservations $res_del");
      print ("this is the number of deleted rows from contract $con_del");

      var test = resulst3.affectedRows;
      print(
          "the number of reservations that has been inserted into complaintes 2 is $test");
    }else {
      print("No reservation found with ID $num2");
      await conn.close();
    }


  }
}

void main()  {
  WidgetsFlutterBinding.ensureInitialized();

  //await NotificationController.initializeLocalNotifications();
  //await NotificationController.initializeIsolateReceivePort();
  runApp(MaterialApp(
    home: ReservationpageAdmin(),
  ));
}
