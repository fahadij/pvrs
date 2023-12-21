import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis/testing/v1.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'My_vehicle_page.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class SelectPage extends StatefulWidget {

  @override
  State<SelectPage> createState() => _SelectPageState();
}



class _SelectPageState extends State<SelectPage> {
  var vid;

  String? token2;
  final TextEditingController searchController = TextEditingController();

  void initState() {
    // TODO: implement initState
    super.initState();
    _select();
    getCred();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      token2 = pref.getString("ID1")!;


      print(token2);

      //nameTextEditingController.text =
    });
  }

  List<Map<String, String>> displayList = [];


  Future<void> _select() async {
    print("Connecting to mysql server...");

    // create connection
    final conn = await MySQLConnection.createConnection(
      host: "10.0.2.2",
      port: 3306,
      userName: "root",
      password: "root",
      databaseName: "pvers",
    );

    await conn.connect();

    print("Connected");
    print(token2);
    // make query
    var result = await conn.execute(
        "SELECT V_num,V_Name,V_Model FROM vehicle WHERE owner_id_V = $token2  ORDER BY V_num ASC");

    // print some result data
    //print(result.numOfColumns);
    //print(result.numOfRows);
    //print(result.lastInsertID);
    //print(result.affectedRows);


    // print query result
    List<Map<String, String>> list = [];
    for (final row in result.rows) {
      final data = {
        'VID': row.colByName("V_num")!,
        'vehicleName': row.colByName("V_Name")!,
        'vehicleModel': row.colByName("V_Model")!,
      };
      list.add(data);
      vid = row.colAt(0)!;
      print(vid);
      //await pref.setString('selectedVID', vid);
    }
    print('je suis la');
    print(list);

    setState(() {
      displayList = list;
    });

    // print(row.colAt(0));
    // print(row.colByName("title"));
    // print all rows as Map<String, String>
    //print(row.assoc());
    //as Map<String, dynamic>
    //print(row.typedAssoc());

    // close all connections
    await conn.close();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('My Vehicle page')
      ),
      body: Column(
          children: [

            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child:
                Column(children: displayList.map<Widget>((data) {
                  return Card(
                      child: ListTile(
                        leading: Text(data['VID'] ?? ""),
                        title: Text(data['vehicleName'] ?? ""),
                        subtitle: Text(data['vehicleModel'] ?? ""),
                        trailing: TextButton(
                          child: const Text("update"),
                          onPressed: () async {
                            SharedPreferences pref = await SharedPreferences
                                .getInstance();
                            pref.setString('selectedVIDreft',
                                data['VID'] ?? ""); // Save the selected VID
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => vehicle_page()),
                            );
                          },
                        ),
                      )
                  );
                }
                ).toList()

                ),

              ),
            ),
          ]),
    );
  }

}