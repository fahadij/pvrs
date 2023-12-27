import 'package:flutter/material.dart';
import 'package:googleapis/admob/v1.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Contract_wip.dart';
import 'Payment_page.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/src/material/time.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpdateReservationPage extends StatefulWidget {



  @override
  _UpdateReservationPageState createState() => _UpdateReservationPageState();
}

class _UpdateReservationPageState extends State<UpdateReservationPage> {
  String? token2;
  String? token4;
  var token;
  Map<String, dynamic>? vehicleDetails;
  DateTime selectedDatestart = DateTime.now() ;
  DateTime selectedDateend = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime reserved_timestart = DateTime.now();
  DateTime reserved_timeend = DateTime.now();

  @override
  void initState() {
    super.initState();
    getCred();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      final selectedDatestart1 = pref.getString("start_date")!;
      selectedDatestart = DateTime.parse(selectedDatestart1);

      final selectedDateend1 = pref.getString("end_date")!;
      selectedDateend = DateTime.parse(selectedDateend1);
      token2 = pref.getString("RVID")!;
      print("this is the value of token2:$token2");
      token4 = pref.getString("ID1")!;
      token = pref.getString('RID1')!;


    });
  }





  Future<void> _selectDatestart(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDatestart,
      firstDate: now,
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(

              primary: Colors.blue, // Change this to the color you want
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedDatestart = DateTime(
          picked.year,
          picked.month,
          picked.day,
          TimeOfDay.now().hour, // Use current hour
          TimeOfDay.now().minute, // Use current minute
        );
      });
    }
  }

  Future<void> _selectDateend(BuildContext context) async {
    final DateTime? picked2 = await showDatePicker(
      context: context,
      initialDate: selectedDatestart,
      firstDate: selectedDatestart,
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(

              primary: Colors.blue, // Change this to the color you want
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked2 != null) {
      setState(() {
        selectedDateend = DateTime(
          picked2.year,
          picked2.month,
          picked2.day,
          TimeOfDay.now().hour, // Use current hour
          TimeOfDay.now().minute, // Use current minute
        );
      });
    }
  }

  /*Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,

    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
        print(selectedTime);
      });
    calculateTotalPrice();

  }*/
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay now = TimeOfDay.now();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked.hour >= now.hour && picked.minute >= now.minute) {
      setState(() {
        selectedTime = picked;
      });

    }

  }



  void compair() {
    int hours = selectedTime.hour;
    int minutes = selectedTime.minute;

    DateTime selectedDateTime = DateTime(
      selectedDateend.year,
      selectedDateend.month,
      selectedDateend.day,
      hours,
      minutes,
    );



  }
  Future<void> createtime() async {
    final selectedDate = DateTime(selectedDateend.year, selectedDateend.month, selectedDateend.day);
    final reservationDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);
    final reservationDateTimeend = selectedDatestart;
    final reservationDateString = reservationDateTime.toIso8601String();
    final reservationDateTimestartString = reservationDateTimeend.toIso8601String();
    print("this is the value of reservationDateString:$reservationDateString");
    print("this is the value of reservationDateString:$reservationDateTimestartString");
    final SharedPreferences pref = await SharedPreferences.getInstance();

    await pref.setString('reservationDateStringen', reservationDateString);
    await pref.setString('reservationDateTimestartString', reservationDateTimestartString);
    checkAvailability();
  }

  Future<void> checkAvailability() async {
    final url = Uri.parse('http://10.0.2.2/test/reservation_api.php');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    print("value of token2 in checkavailability$token2");
    print("value of selectedDatestart in checkavailability$selectedDatestart");
    print("value of token2 in checkavailability$selectedDateend");
    final params = {
      'vehicle_id': token2,
      'start_time': selectedDatestart.toIso8601String(),
      'end_time': selectedDateend.toIso8601String(),
    };
    final completeUrl = url.replace(
      queryParameters: params,
    );
    final response = await http.get(completeUrl);

    final data = jsonDecode(response.body);

    if (data['status'] == 'success') {
      update();
    } else {
      // Show error message using a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['message']),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Change Time',
            onPressed: () => Navigator.pop(context), // Close the current screen
          ),
        ),
      );
    }
    print(data['message']);

  }
  Future<void> update() async {

    print("Connecting to mysql server...");

    final conn = await MySQLConnection.createConnection(
        host: '10.0.2.2',
        port: 3306,
        userName: 'root',
        password: 'root',
        databaseName: 'pvers');
    await conn.connect();
    print("Connected");

    var res = await conn.execute(
        "UPDATE reservation SET RES_DateTime_start = '$selectedDatestart' , RES_DateTime_end = '$selectedDateend' WHERE RESno = '$token' ");
    var res2 = await conn.execute(
        "UPDATE contract SET Con_Beginning_of_Rent_date = '$selectedDatestart' , Con_End_of_Rent_date = '$selectedDateend' WHERE Res_num = '$token' ");
    print(res.affectedRows);
    print(res2.affectedRows);
    await conn.close();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _selectDatestart(context);
              },
              child: Text('Select start Date'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _selectDateend(context);
              },
              child: Text('Select end Date'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _selectTime(context);
              },
              child: Text('Select Time'),
            ),
            SizedBox(height: 10),
            SizedBox(height: 20),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child:

                Row(
                    children:[

                      ElevatedButton(
                        onPressed: () async {
                          createtime();
                          Navigator.pop(context, () => setState(() {}));
                        },
                        child: Text('Update it Now'),
                      ),
                    ]


                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
