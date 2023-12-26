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

class VehicleDetailsPage extends StatefulWidget {

  @override
  _VehicleDetailsPageState createState() => _VehicleDetailsPageState();
}

class _VehicleDetailsPageState extends State<VehicleDetailsPage> {
  String? token2;
  String? token4;
  Map<String, dynamic>? vehicleDetails;
  DateTime selectedDatestart = DateTime.now();
  DateTime selectedDateend = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String total = "";
  DateTime reserved_timestart = DateTime.now();
  DateTime reserved_timeend = DateTime.now();

  @override
  void initState() {
    super.initState();
    _getVehicleDetails();
  }

  Future<void> _getVehicleDetails() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token2 = pref.getString("selectedVIDreft")!;
      print("this is the value of token2:$token2");
      token4 = pref.getString("ID1")!;

      //nameTextEditingController.text =
    });
    print("Connecting to mysql server...");
    final conn = await MySQLConnection.createConnection(
        host: '10.0.2.2',
        port: 3306,
        userName: 'root',
        password: 'root',
        databaseName: 'pvers');

    await conn.connect();
    print("Connected");
    var results = await conn.execute(
        "SELECT V_num, V_Name, V_Model, V_Type, V_Location, V_Battery, V_Rate, V_EV FROM vehicle WHERE V_num = $token2");

    if (results.isNotEmpty) {
      for (final row in results.rows) {
        setState(() {
          vehicleDetails = row.assoc(); // Assuming your database returns a map of field names to values.
        });
      }
    }


    var token3 = pref.getString("selectedVIDreft")!;
    print(token3);
    await conn.close();
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
    createtime();
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
    createtime();
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
    calculateTotalPrice();
  }

  String? calculateTotalPrice() {
    // Assuming rate is in dollars per hour
    print("this is the data$selectedDatestart");
    double rate = double.parse(vehicleDetails?['V_Rate']);
    int hours = selectedTime.hour;
    int minutes = selectedTime.minute;

    DateTime selectedDateTime = DateTime(
      selectedDateend.year,
      selectedDateend.month,
      selectedDateend.day,
      hours,
      minutes,
    );

    // Calculate total price
    if (selectedDateTime == null) {//
      Fluttertoast.showToast(
          msg: "the time or date is incoreect please select a valid time");
      double totalPrice = 0.00;
      return totalPrice.toStringAsFixed(2);
    }
    else {
      double totalPrice = rate * (selectedDateTime
          .difference(selectedDatestart)
          .inMinutes
          .toDouble()) / 60;
      if (totalPrice >= 0) {
        return totalPrice.toStringAsFixed(2);
      }
    }
    createtime();
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
      // Vehicle is available, show confirmation dialog
    } else {
      // Show error message using a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['message']),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Change Time/Vehicle',
            onPressed: () => Navigator.pop(context), // Close the current screen
          ),
        ),
      );
    }
      print(data['message']);

    }


  Future<void> printVehicle(String? num, String? name, String? model, String? type, String? location, String? battery, String? rate, String? Electric) async {
    final image = await imageFromAssetBundle("images/logo-color.png");

    final doc = pw.Document();
    doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) => buildPrintableData(context, num,name,model,type,location, battery,rate , Electric, image),
    ));
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  pw.Widget buildPrintableData(pw.Context context,String? num, String? name, String? model, String? type, String? location, String? battery, String? rate, String? Electric,image) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(25.00),
      child: pw.Column(

        children: [
          pw.Text(
            "Vehicle",
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
                "Vehicle details",
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
                      pw.Flexible(child:pw.Text("Vehicle number: $num")),
                      pw.Flexible(child:pw.Text("Vehicle name: $name")),
                      pw.Flexible(child:pw.Text("Vehicle model : $model")),
                      pw.Flexible(child:pw.Text("Vehicle Type: $type")),
                      pw.Flexible(child:pw.Text("Vehicle Location: $location")),
                      pw.Flexible(child:pw.Text("Vehicle battery: $battery")),
                      pw.Flexible(child:pw.Text("Vehicle rate: $rate")),
                      pw.Flexible(child:pw.Text("Vehicle Electric: $Electric")),
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
    Widget build(BuildContext context) {
      var Vnum = "${vehicleDetails?['V_num']}";
      var Vn = "${vehicleDetails?['V_Name']}";
      var VM = "${vehicleDetails?['V_Model']}";
      var VT = "${vehicleDetails?['V_Type']}";
      var VL = "${vehicleDetails?['V_Location']}";
      var VB = "${vehicleDetails?['V_Battery']}";
      var VR = "${vehicleDetails?['V_Rate']}";
      var VE = "${vehicleDetails?['V_EV'] == '1' ? 'Yes' : 'No'}'";
      if (vehicleDetails == null) {
        return Center(child: CircularProgressIndicator());
      }

      return Scaffold(
        appBar: AppBar(
          title: Text('Vehicle Details'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Vehicle Number: ${vehicleDetails?['V_num']}'),
              Text('Vehicle Name: ${vehicleDetails?['V_Name']}'),
              Text('Vehicle Model: ${vehicleDetails?['V_Model']}'),
              Text('Vehicle Type: ${vehicleDetails?['V_Type']}'),
              Text('Vehicle Location: ${vehicleDetails?['V_Location']}'),
              Text('Battery: ${vehicleDetails?['V_Battery']}'),
              Text('Rate: ${vehicleDetails?['V_Rate']}'),
              Text('Electric: ${vehicleDetails?['V_EV'] == '1' ? 'Yes' : 'No'}'),
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
              Text('Total Price: ${calculateTotalPrice()}'),
              SizedBox(height: 20),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child:

                  Row(
                    children:[
                    ElevatedButton(
                    onPressed: () async {

                      printVehicle(Vnum, Vn, VM,VT,VL,VB,VR,VE);

                    },
                    child: Text('Print details'),
                  ),
                      ElevatedButton(
                        onPressed: () async {
                          SharedPreferences pref = await SharedPreferences
                              .getInstance();
                          pref.setString('TotalPrice', calculateTotalPrice()!);
                          checkAvailability();

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => VehicleRentalContractPage()),
                          );
                        },
                        child: Text('Rent it Now'),
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
