import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:printing/printing.dart';
import 'package:pvers_customer/authentication/vehicle_page_rent.dart';
import 'package:pvers_customer/tab_pages/home_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';



class VehicleRenterPage extends StatefulWidget {

  @override
  State<VehicleRenterPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<VehicleRenterPage> {
  var vid;

  String? token2;
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
  List<Map<String, String>> filteredList = [];
  List<Map<String, String>> tempList1 = [];
  bool isTextFieldFocused = false;

  final TextEditingController searchController = TextEditingController();


  Future<void> _select() async {
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
    print (token2);
    var available = 0;
    // make query
    var result = await conn.execute(
        "SELECT * FROM vehicle Where V_Status=$available ORDER BY V_num ASC ");

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
        'V_EV': row.colByName("V_EV")!
      };
      list.add(data);
      vid =row.colAt(0)!;

    }
    print(vid);

    setState(() {
      displayList = list;
      tempList1 = list;
      print(displayList);
      print(tempList1);
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
  void _saveVID(String vid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedVIDreft', vid);
    print(vid);
  }

  void _filterList(String query) {

    List<Map<String, String>> tempList = [];
    if (query.isNotEmpty) {
      displayList.forEach((data) {
        if (data['VID'].toString().contains(query) ||
            data['vehicleName'].toString().contains(query) ||
            data['vehicleModel'].toString().contains(query) ||
            (data['V_EV'] == '1' && query == 'EV') ||
            (data['V_EV'] == '0' && query == 'NEV')) {
          tempList.add(data);
        }
      });
    } else {
      tempList.addAll(tempList1);
    }
    setState(() {
      filteredList = tempList;
      displayList = filteredList;
    });


    setState(() {});
    print("this is the inside of the list$filteredList");
  }

  void _search() {
    setState(() {
      filteredList = tempList1;
      displayList= filteredList;
    });
    print("this is mylist: $filteredList");
    String query = searchController.text;
    print("this is a test to see the value of: $query");
    _filterList(query);
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('rent a car page')
      ),
      body: Column(
          children:[
             GestureDetector(
               onTap:() {

             },
              child:TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by Car Number, Model, Type, or Electric',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterList,
                onTap: (){
              setState(() {
              isTextFieldFocused = true;
              });
              },
                  onEditingComplete: () {
                    setState(() {
                      isTextFieldFocused = false;
                    });
                  },),
            ),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child:
                Column(children: displayList.map<Widget>((data)  {
                  return Card(
                      child: ListTile(
                        leading: Text(data['VID']?? ""),
                        title: Text(data['vehicleName']?? ""),
                        subtitle: Text(data['vehicleModel']?? ""),
                        trailing: Text(data['V_EV'] == '1' ? 'Electric' : 'Not Electric'),
                          onTap: () {
                            _saveVID(data['VID'] ?? "");
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => VehicleDetailsPage()),
                            );
                          },
                        ),
                      );

                }
                ).toList()
                ),
              ),
            ),
          ]),
    floatingActionButton: Visibility(
        visible: isTextFieldFocused,
        child: FloatingActionButton.extended(
        onPressed: _search,
        tooltip: 'Search',
        label: const Text("Search"),
        icon: const Icon(Icons.search),
    )
    )
    );
  }
}