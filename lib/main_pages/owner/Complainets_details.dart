import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'package:mysql_client/mysql_client.dart'; // Updated import statement
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pvers_customer/tab_pages/Complaine_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ComplainetsDetailsPage extends StatefulWidget {
  final int? complaintId;

  const ComplainetsDetailsPage({required this.complaintId});

  @override
  State<ComplainetsDetailsPage> createState() => _ComplainetsDetailsPageState();
}

class _ComplainetsDetailsPageState extends State<ComplainetsDetailsPage> {
  late MySqlConnection _connection; // Added MySqlConnection

  TextEditingController subjectController = TextEditingController();
  TextEditingController textController = TextEditingController();
  TextEditingController answerController = TextEditingController();
  var subjectid;
  var token;
  @override


  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("ID1")!;
      print(token);
    });
  }
  Future<void> updateComplaint(String subject, String text, int complaintId) async {
    try {
      final conn = await MySQLConnection.createConnection(
          host: '10.0.2.2',
          port: 3306,
          userName: 'root',
          password: 'root',
          databaseName: 'pvers');
      await conn.connect();

      // Use prepared statements with named parameters
      var results = await conn.execute(
        "UPDATE complaints SET complaint_sub = '$subject', complaint_description = '$text' WHERE complaint_no = '$complaintId'",
      );
      print(results.numOfRows);
      print('Complaint submitted successfully!');
    } catch (e) {
      print('Error submitting complaint: $e');
    }
  }

  Future<void> getComplaint(int? complaintId) async {
    try {
      var subject;
      var text;
      var answer;
      final conn = await MySQLConnection.createConnection(
          host: '10.0.2.2',
          port: 3306,
          userName: 'root',
          password: 'root',
          databaseName: 'pvers');
      await conn.connect();
     print(complaintId);
      var results = await conn.execute(
        "SELECT complaint_sub, complaint_description, complaint_answer FROM complaints WHERE complaint_no = $complaintId");

      if (results.isNotEmpty) {
        for (final row in results.rows) {
          subject = row.colByName("complaint_sub");
          text = row.colByName("complaint_description");
          answer = row.colByName("complaint_answer");
        }

        setState(() {
          subjectController.text = subject;
          textController.text = text;
          answerController.text = answer;
        });
      } else {
        print('No complaint found with ID $complaintId');
      }
    } catch (e) {
      print('Error retrieving complaint: $e');
    }
  }

  Future<void> Delete_and_archive_Complaint(int? complaintId) async {
      var subject;
      var text;

      final conn = await MySQLConnection.createConnection(
          host: '10.0.2.2',
          port: 3306,
          userName: 'root',
          password: 'root',
          databaseName: 'pvers');
      await conn.connect();
      print(complaintId);
      var results = await conn.execute(
          "SELECT * FROM complaints WHERE complaint_no = $complaintId");
      var date1;

      if (results.isNotEmpty) {
        for (final row in results.rows) {
          subject = row.colByName("complaint_sub");
          text = row.colByName("complaint_description");
          date1 = row.colByName("complaint_date");
          subjectid = row.colByName("complaint_no");
        }
        var date = DateTime.now();
        String formattedDate = date.toString(); // This converts the DateTime to a string
        String formattedDate1 = date1.toString();

print(token);
        var check_user_is_owner = await conn.execute("SELECT * FROM owner WHERE owner_id = '$token'");
        var check_user_is_renter = await conn.execute("SELECT * FROM renter WHERE Renter_ID = '$token'");
        DatabaseReference complaintRef = FirebaseDatabase.instance.ref().child("complaint");
        print("checked renter_ids and owner_ids");

        print(check_user_is_owner.numOfRows);
        print(check_user_is_renter.numOfRows);
        
        String complaintId = subjectid;
        if (check_user_is_owner.numOfRows == 1) {
          Map complaintMap =
          {

            "complaint_sub": subject,
            "complaint_description": text,
            "complaint_start_date":formattedDate,
            "complaint_delete_date":formattedDate1,
            "owner_id":token,

          };
print(check_user_is_owner.numOfRows);
          complaintRef.child(subjectid).set(complaintMap);

        var resulst2 = await conn.execute("INSERT INTO complainets2 (complaint_sub,complaint_description,complaint_delete_date,complaint_add_Date,owner_id) VALUES (:complaint_sub1, :complaint_description1, :complaint_delete_date,:complaint_start_date,:owner_id1)",
        {
          "complaint_sub1": subject,
          "complaint_description1": text,
          "complaint_start_date":date,
          "complaint_delete_date":date1,
          "owner_id1":token,
        }

        );
        var test = resulst2.affectedRows;
        print("the number of complaints that has been inserted into complaintes 2 is $test");

        var res2 = await conn.execute("DELETE FROM complaints WHERE complaint_no = $complaintId");
            var res3 = res2.affectedRows;
        print("the number of complaints that have been deleted is:$res3");
        await conn.close();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Complaints_page()),
        );
        Fluttertoast.showToast(msg: "the Complaints deleted successfully");
      } else if (check_user_is_renter.numOfRows == 1) {

          Map complaintMap =
          {

            "complaint_sub": subject,
            "complaint_description": text,
            "complaint_date1":formattedDate,
            "complaint_date2":formattedDate1,
            "renter_id":token,

          };

          complaintRef.child(subjectid).set(complaintMap);
            var resulst2 = await conn.execute("INSERT INTO complainets2 (complaint_sub,complaint_description,complaint_delete_date,complaint_add_Date,renter_id) VALUES (:complaint_sub1, :complaint_description1, :complaint_date1,:complaint_date2,:renter)",
                {
                  "complaint_sub1": subject,
                  "complaint_description1": text,
                  "complaint_date1":date,
                  "complaint_date2":date1,
                  "renter":token,
                }

            );
            var test = resulst2.affectedRows;
            print("the number of complaints that has been inserted into complaintes 2 is $test");

            var res2 = await conn.execute("DELETE FROM complaints WHERE complaint_no = $complaintId");
            var res3 = res2.affectedRows;
            print("the number of complaints that have been deleted is:$res3");
            await conn.close();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Complaints_page()),
            );
            Fluttertoast.showToast(msg: "the Complaints deleted successfully");
          }


        }
        else {
        print("No complaint found with ID $complaintId");
        await conn.close();
      }


  }


  Future<void> printComplaint(String? num, String? name) async {
    final image = await imageFromAssetBundle("images/logo-color.png");

    final doc = pw.Document();
    doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) => buildPrintableData(context, num,name,image),
    ));
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  pw.Widget buildPrintableData(pw.Context context,String? num, String? name, image) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(25.00),
      child: pw.Column(

        children: [
          pw.Text(
            "Complaint",
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
          pw.SizedBox(height: 10.00),
          pw.Container(
            color: const PdfColor(0.5, 1, 0.5, 0.7),
            width: double.infinity,
            height: 36.00,
            child: pw.Center(
              child: pw.Text(
                "Complaint details",
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
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children:[
                      pw.Flexible(child:pw.Text("Complaint subject: $num")),
                      pw.Flexible(child:pw.Text("Complaint Text: $name")),
                      pw.Flexible(child:pw.Text("Thank you for using this service")),
                    ]
                )


              ],
            ),

          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getComplaint(widget.complaintId);
    getCred();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint Details'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: subjectController,
              decoration: InputDecoration(labelText: 'Subject'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: textController,
              decoration: InputDecoration(labelText: 'Text'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                updateComplaint(
                  subjectController.text,
                  textController.text,
                    widget.complaintId!,
                );
              },
              child: Text('update Complaint'),
            ),

            TextField(
              controller: answerController,
              decoration: InputDecoration(labelText: 'Answer'),
              readOnly: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Delete_and_archive_Complaint(widget.complaintId);
              },
              child: Text('delete Complaint'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                printComplaint(
                  subjectController.text,
                  textController.text,
                );
              },
              child: Text('Print Complaint'),
            ),
          ],
        ),
      ),
    );
  }
}