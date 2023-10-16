import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysql_client/mysql_client.dart';

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
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<Complaints_page> {
  List<Map<String, String>> faqs = [
    {
      'question': 'How to add an Complaint?',
      'answer': 'Click the "+" button and fill out the form.'
    },
  ];

  TextEditingController questionController = TextEditingController();
  TextEditingController answerController = TextEditingController();
  TextEditingController idController = TextEditingController();


  void _addComplaints(String question, String answer, String ID) {
    setState(() {
      faqs.add({'ID': ID, 'complaint question': question, 'complaint content': answer});
    });
  }

  void _updateComplaints(int index, String question, String answer, String ID) {
    setState(() {
      faqs[index] = {'ID': ID, 'complaint question': question, 'complaint answer': answer};
    });
  }

  void _deleteComplaints(int index) {
    setState(() {
      faqs.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('complaint Page'),
      ),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(faqs[index]['complaint question'] ?? ''),
              subtitle: Text(faqs[index]['complaint answer'] ?? ''),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      idController.text = faqs[index]['id'] ?? '';
                      questionController.text = faqs[index]['complaint question'] ?? '';
                      answerController.text = faqs[index]['complaint answer'] ?? '';
                      update();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Cancel complaint'),
                            content: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: idController,
                                      decoration: InputDecoration(
                                          labelText: 'complaint ID'),
                                    ),
                                    TextField(
                                      controller: questionController,
                                      decoration: InputDecoration(
                                          labelText: 'complaint Question'),
                                    ),
                                    TextField(
                                      controller: answerController,
                                      decoration: InputDecoration(
                                          labelText: 'complaint Answer'),
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
                                  _updateComplaints(index, questionController.text,
                                      answerController.text, idController.text);
                                  Navigator.of(context).pop();
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
                            title: Text('delete FAQ'),
                            content: Text(
                                'Are you sure you want to delete this complaint?'),
                            actions: [
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Delete'),
                                onPressed: () {
                                  _deleteComplaints(index);
                                  Navigator.of(context).pop();
                                  deletfaq();
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
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          questionController.text = '';
          answerController.text = '';
          idController.text = '';

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add complaint'),
                content: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          controller: idController,
                          decoration: InputDecoration(labelText: 'ID'),
                        ),
                        TextField(
                          controller: questionController,
                          decoration: InputDecoration(labelText: 'Question'),
                        ),
                        TextField(
                          controller: answerController,
                          decoration: InputDecoration(labelText: 'Answer'),
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
                      _addComplaints(questionController.text, answerController.text,
                          idController.text);
                      Navigator.of(context).pop();
                      insert();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }


  Future<void> update() async {
    String select = questionController.text;
    String? test;
    print("Connecting to MySQL server...");

    final conn = await MySQLConnection.createConnection(
      host: '10.0.2.2',
      port: 3306,
      userName: 'root',
      password: 'root',
      databaseName: 'pvers',
    );

    await conn.connect();
    print("this is a test help $select");
    var result = await conn.execute(
        "SELECT * FROM complaints WHERE complaint_sub = '$select' "); //idk why it errors out
    print(result.affectedRows);
    for (final row in result.rows) {
      final data = {
        setState((){
          test: row.colAt(1)!;
        }),
      };


      print("this is a test $test");

      var res = await conn.execute(
        "UPDATE complaints (complaint_sub,complaint_description) VALUES (:vid1, :vn1)",
        {
          "vid1": questionController.text.trim(),
          "vn1": answerController.text.trim(),
          "num1": idController.text.trim()
        },
      );
      print(res.affectedRows);

      await conn.close();
      Fluttertoast.showToast(msg: "the FAQ registered successfully");
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

    await conn.connect();
    print("Connected");
    var res = await conn.execute(
      "INSERT INTO faq (FAQ_Headline,FAQ_Content,FAQ_num) VALUES (:vid1, :vn1, :num1)",
      {
        "vid1": questionController.text.trim(),
        "vn1": answerController.text.trim(),
        "num1": idController.text.trim()
      },
    );
    print(res.affectedRows);

    await conn.close();
    Fluttertoast.showToast(msg: "the FAQ registered successfully");
  }

  Future<void> deletfaq() async {
    print("Connecting to mysql server...");
    var test = idController.text.trim();


    final conn = await MySQLConnection.createConnection(
        host: '10.0.2.2',
        port: 3306,
        userName: 'root',
        password: 'root',
        databaseName: 'pvers');

    await conn.connect();
    print("Connected");
    var res = await conn.execute("DELETE FROM faq WHERE FAQ_num = $test");
    print(res.affectedRows);

    await conn.close();
    Fluttertoast.showToast(msg: "the FAQ deleted successfully");
  }
}
