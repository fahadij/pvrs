import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'My_vehicle_page.dart';
import 'domain/format.dart';
import 'My_vehicle_page.dart';

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
  List<Map<String, String>> filteredList = [];


  void _filterList(String query) {
    filteredList.clear();
    if (query.isNotEmpty) {
      displayList.forEach((data) {
        if (data['VID']!.contains(query) ||
            data['vehicleName']!.contains(query) ||
            data['vehicleModel']!.contains(query)) {
          filteredList.add(data);
        }
      });
    } else {
      filteredList.addAll(displayList);
    }
    setState(() {});
  }

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
    // make query
    var result = await conn.execute(
        "SELECT * FROM vehicle WHERE owner_id_V = $token2  ORDER BY V_num ASC");

    // print some result data
    //print(result.numOfColumns);
    //print(result.numOfRows);
    //print(result.lastInsertID);
    //print(result.affectedRows);


    // print query result
    List<Map<String, String>> list = [];
    for (final row in result.rows) {
      final data = {
        'VID': row.colAt(1)!,
        'vehicleName': row.colAt(2)!,
        'vehicleModel': row.colAt(3)!,
      };
      list.add(data);
      vid =row.colAt(0)!;

    }
    print('je suis la');
    print(vid);

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


      ),
      body: Column(
          children:[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: 'Search by Car Number, Model, Type, or Electric',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child:
                Column(children: filteredList.map<Widget>((data) {
                  return Card(
                      child: ListTile(
                        leading: Text(data['VID']?? ""),
                        title: Text(data['vehicleName']?? ""),
                        subtitle: Text(data['vehicleModel']?? ""),
                        trailing: TextButton(
                          child: const Text("update"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => vehicle_page()),
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

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _select,
        tooltip: 'select',
        label: const Text("select"),
      ),
    );
  }
}