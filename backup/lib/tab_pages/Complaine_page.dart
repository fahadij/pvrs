/*import 'package:flutter/material.dart';
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
    _select();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("ID1")!;
      test = pref.getString("ID1")!;
      print(token);
      //nameTextEditingController.text =

    });
  }


  void _addComplaints(String question, String answer, String id) {
    setState(() {
      Complaine.add({
        'id': id,
        'complaint question': question,
        'complaint answer': answer
      });
      insert();
      select1();
    });
  }


    void _updateComplaints(int index, String question, String answer,
        String id) {
      setState(() {
        Complaine[index] = {'CID': 'id','Subject': question, 'Text': answer};
        ID_update = Complaine[index]['id']!;
      });
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
    // make query
    var result = await conn.execute(
        "SELECT * FROM complaints ORDER BY V_num ASC ");


    List<Map<String, String>> list = [];
    for (final row in result.rows) {
      final data = {
        'CID': row.colByName("Complaint_no")!,
        'Subject': row.colByName("Complaint_sub")!,
        'Text': row.colByName("Complaint_description")!,
      };
      list.add(data);

    }

    setState(() {
      displayList = list;
      tempList1 = list;
      print(displayList);
      print(tempList1);
    });

    await conn.close();
  }

  void _filterList(String query) {

    List<Map<String, String>> tempList = [];
    if (query.isNotEmpty) {
      displayList.forEach((data) {
        if (data['CID'].toString().contains(query)||
          data['Subject'].toString().contains(query)){
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
        "UPDATE SET complaints (complaint_sub,complaint_description) VALUES (:vid1, :vn1) WHERE complaint_no =$test ",
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
          databaseName: 'pvers');
      DateTime time = DateTime.now();
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await conn.connect();
      print("Connected");
      var check_user_is_owner = await conn.execute(
          "SELECT * FROM owner WHERE owner_id = '$token'");
      var check_user_is_renter = await conn.execute(
          "SELECT * FROM renter WHERE Renter_ID = '$token'");
      print (check_user_is_owner.numOfRows);
      if (check_user_is_owner.numOfRows == 1) {
        print("user is owner");

        var res = await conn.execute(
            "SELECT * FROM complaints WHERE owner_id = $token");
        List<Map<String, String?>> list = [];
        for (final row in res.rows) {
          final data = {
            'id': row.colByName("complaint_no"),
            'question': row.colByName("complaint_sub"),
            'answer': row.colByName("complaint_description"),
          };
          list.add(data);
          setState(() {
            Complaine = list;
            print(res.numOfRows);
          }
          );
        };


        await conn.close();
      }
      else if (check_user_is_renter.numOfRows == 1) {
        print("user is renter");

        var results = await conn.execute(
            "SELECT * FROM complaints WHERE owner_id = $token");
        List<Map<String, String>> list = [];
        for (final row in results.rows) {
          final data = {

            'id': row.colByName("complaint_no"),
            'question': row.colByName("complaint_no"),
            'answer': row.colByName("complaint_no"),

          };
          setState(() {
            questionController.text = row.colByName("complaint_sub")!;
            answerController.text = row.colByName("complaint_description")!;
            print(row.numOfColumns);
          }
          );

        };

        await conn.close();
      }
    }



  Future<void> insert() async {
    print("Connecting to mysql server...");


    final conn = await MySQLConnection.createConnection(
        host: '10.0.2.2',
        port: 3306,
        userName: 'root',
        password: 'root',
        databaseName: 'pvers');
    DateTime time = DateTime.now();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await conn.connect();
    print("Connected");


    var check_user_is_owner = await conn.execute(
        "SELECT owner_id FROM owner WHERE owner_id = '$token'");
    print("checked owner_ids");
    var check_user_is_renter = await conn.execute(
        "SELECT * FROM renter WHERE renter_id = '$token'");
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
    }
    else if (check_user_is_renter.numOfRows == 1) {
      print("user is renter");

      var res2 = await conn.execute(
        "INSERT INTO complaints (complaint_sub,complaint_description,complaint_date,owner_id) VALUES (:CS, :CD,:DATE,:ID)",
        {
          "CD": questionController.text.trim(),
          "CS": answerController.text.trim(),
          "date": time,
          "ID": token,

        },
      );
      print(res2.affectedRows);

      await conn.close();
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
        databaseName: 'pvers');
    DateTime time = DateTime.now();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await conn.connect();
    print("Connected");


    var res = await conn.execute(
        "DELETE FROM complaints WHERE complaint_no = $ID_delete");
    print(res.affectedRows);

    await conn.close();
    Fluttertoast.showToast(msg: "the Complaints deleted successfully");
  }



    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Complaint Page'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: ()
                {
                  questionController.text = '';
                  answerController.text = '';
                  idController.text = '';

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Add Complaint'),
                        content: SingleChildScrollView(
                            child: Column(
                              children: [
                                TextField(
                                  controller: idController,
                                  decoration: InputDecoration(labelText: 'ID'),
                                  readOnly: true,
                                ),
                                TextField(
                                  controller: questionController,
                                  decoration: InputDecoration(labelText: 'subject'),
                                ),
                                TextField(
                                  controller: answerController,
                                  decoration: InputDecoration(labelText: 'Text'),
                                ),

                              ],
                            )),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Save'),
                            onPressed: () {
                              _addComplaints(questionController.text, answerController
                                  .text, idController.text);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
            ),
          ],
        ),
        body: Column(
            children: [
              GestureDetector(
                onTap:(){

              },
                 child: TextField(
                  controller: searchController,
                  onChanged: (query) {
                 _filterList(query);
                 },
                  decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                   border: OutlineInputBorder(),
          ),
        ),
      ),
              ]),
          Expanded(
            flex: 3,
            child: Column(children: displayList.map<Widget>((data)
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Text(Complaine[index]['id'] ?? ''),
                    title: Text(Complaine[index]['question'] ?? ''),
                    subtitle: Text(Complaine[index]['answer'] ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            idController.text = Complaine[index]['id'] ?? '';
                            questionController.text =
                                Complaine[index]['question'] ?? '';
                            answerController.text =
                                Complaine[index]['answer'] ?? '';
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Edit Complaint'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: idController,
                                          decoration: InputDecoration(labelText: 'ID'),
                                          readOnly: true,
                                        ),
                                        TextField(
                                          controller: questionController,
                                          decoration:
                                          InputDecoration(labelText: 'subject'),
                                        ),
                                        TextField(
                                          controller: answerController,
                                          decoration: InputDecoration(labelText: 'Text'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Save'),
                                      onPressed: () {
                                        _updateComplaints(
                                            index,
                                            questionController.text,
                                            answerController.text,
                                            idController.text);
                                        Navigator.of(context).pop();
                                        update1();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Delete Complaint'),
                                  content: Text(
                                      'Are you sure you want to delete this FAQ?'),
                                  actions: [
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      var complain_id = Complaine[index]['id'];
                      int complaintId = int.parse(complain_id!);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ComplainetsDetailsPage(
                            complaintId: complaintId,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),



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
  }*/