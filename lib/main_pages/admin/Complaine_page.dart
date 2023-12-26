import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Complainets_details.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Complaints_page(),
    );
  }
}

class Complaints_page extends StatefulWidget {
  @override
  _Complaints_page createState() => _Complaints_page();
}

class _Complaints_page extends State<Complaints_page> {
  List<Map<String, String?>> Complaine = [
    {
      'question': 'How to add an Complaint?',
      'answer': 'Click the "+" button and fill out the form.'
    },
  ];

  TextEditingController questionController = TextEditingController();
  TextEditingController answerController = TextEditingController();
  TextEditingController idController = TextEditingController();
  String? token;
  String? test;
  String? ID_delete;
  String? ID_update;
  List<Map<String, String>> displayList = [];
  List<Map<String, String>> filteredList = [];
  List<Map<String, String>> tempList1 = [];
  bool isTextFieldFocused = false;
  final TextEditingController searchController = TextEditingController();

  void initState() {
    super.initState();
    getCred();
    select1();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("ID1")!;
      test = pref.getString("ID1")!;
      print(token);
    });
  }

  void _addComplaints(String question, String answer, String id) {
    setState(() {
      Complaine.add({
        'id': id,
        'question': question,
        'answer': answer
      });
      insert();
      select1();
    });
  }

  void _updateComplaints(int index, String question, String answer, String id) {
    setState(() {
      Complaine[index] = {'question': question, 'answer': answer};
      ID_update = Complaine[index]['id']!;
    });
  }


  void _filterList(String query) {
    List<Map<String, String>> tempList = [];
    if (query.isNotEmpty) {
      displayList.forEach((data) {
        if (data['id'].toString().contains(query) || data['question'].toString().contains(query)) {
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
      displayList = filteredList;
    });
    print("this is mylist: $filteredList");
    String query = searchController.text;
    print("this is a test to see the value of: $query");
    _filterList(query);
  }

  Future<void> update1() async {
    print("Connecting to MySQL server...");

    final conn = await MySQLConnection.createConnection(
      host: '10.0.2.2',
      port: 3306,
      userName: 'root',
      password: 'root',
      databaseName: 'pvers',
    );

    await conn.connect();

    var res = await conn.execute(
      "UPDATE complaints SET (complaint_sub,complaint_description) VALUES (:vid1, :vn1) WHERE complaint_no ='$test'",
      {
        "vid1": questionController.text.trim(),
        "vn1": answerController.text.trim(),
      },
    );
    print(res.affectedRows);

    await conn.close();
    Fluttertoast.showToast(msg: "the FAQ registered successfully");
  }

  Future<void> select1() async {
    print("Connecting to mysql server...");

    final conn = await MySQLConnection.createConnection(
      host: '10.0.2.2',
      port: 3306,
      userName: 'root',
      password: 'root',
      databaseName: 'pvers',
    );
    DateTime time = DateTime.now();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await conn.connect();
    print("Connected");


      var res = await conn.execute("SELECT * FROM complaints");

      List<Map<String, String>> list = [];
      for (final row in res.rows) {
        final data = {
          'id': row.colByName("complaint_no")!,
          'question': row.colByName("complaint_sub")!,
          'answer': row.colByName("complaint_description")!,
        };
        list.add(data);
        setState(() {
          displayList = list;
          tempList1 = list;
          print(displayList);
          print(tempList1);
        });
      }

      await conn.close();

  }

  Future<void> insert() async {
    print("Connecting to mysql server...");

    final conn = await MySQLConnection.createConnection(
      host: '10.0.2.2',
      port: 3306,
      userName: 'root',
      password: 'root',
      databaseName: 'pvers',
    );
    DateTime time = DateTime.now();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await conn.connect();
    print("Connected");

    var check_user_is_owner = await conn.execute("SELECT owner_id FROM owner WHERE owner_id = '$token'");
    print("checked owner_ids");
    var check_user_is_renter = await conn.execute("SELECT * FROM renter WHERE renter_id = '$token'");
    print("checked renter_ids");
    if (check_user_is_owner.numOfRows == 1) {
      print("user is owner");

      var res = await conn.execute(
        "INSERT INTO complaints (complaint_sub,complaint_description,complaint_date,owner_id) VALUES (:CS, :CD,:DATE,:ID)",
        {
          "CD": questionController.text.trim(),
          "CS": answerController.text.trim(),
          "DATE": time,
          "ID": token,
        },
      );
      print(res.affectedRows);

      await conn.close();
      Fluttertoast.showToast(msg: "the Complaint registered successfully");
      select1();
    } else if (check_user_is_renter.numOfRows == 1) {
      print("user is renter");

      var res2 = await conn.execute(
        "INSERT INTO complaints (complaint_sub,complaint_description,complaint_date,Renter_id) VALUES (:CS, :CD,:DATE,:ID)",
        {
          "CD": questionController.text.trim(),
          "CS": answerController.text.trim(),
          "DATE": time,
          "ID": token,
        },
      );
      print(res2.affectedRows);
      Fluttertoast.showToast(msg: "the Complaint registered successfully");
      await conn.close();
      select1();
    }
  }

  Future<void> deletfaq() async {
    String select = questionController.text;
    print("Connecting to mysql server...");

    final conn = await MySQLConnection.createConnection(
      host: '10.0.2.2',
      port: 3306,
      userName: 'root',
      password: 'root',
      databaseName: 'pvers',
    );
    DateTime time = DateTime.now();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await conn.connect();
    print("Connected");

    var res = await conn.execute("DELETE FROM complaints WHERE complaint_no = $ID_delete");
    print(res.affectedRows);

    await conn.close();
    Fluttertoast.showToast(msg: "the Complaints deleted successfully");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint Page'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {},
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by Car Number, Model, Type, or Electric',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterList,
              onTap: () {
                setState(() {
                  isTextFieldFocused = true;
                });
              },
              onEditingComplete: () {
                setState(() {
                  isTextFieldFocused = false;
                });
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                children: displayList.map<Widget>((data) {
                  return Card(
                    child: ListTile(
                      leading: Text(data['id'] ?? ""),
                      title: Text(data['question'] ?? ""),
                      subtitle: Text(data['answer'] ?? ""),
                      onTap: () {
                        var ID = int.tryParse(data['id'] ?? '');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ComplainetsDetailsPage(complaintId:ID)),
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: isTextFieldFocused,
        child: FloatingActionButton.extended(
          onPressed: _search,
          tooltip: 'Search',
          label: const Text("Search"),
          icon: const Icon(Icons.search),
        ),
      ),
    );
  }
}
