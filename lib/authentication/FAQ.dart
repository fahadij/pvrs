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
      home: FAQScreen(),
    );
  }
}

class FAQScreen extends StatefulWidget {
  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  List<Map<String, String>> faqs = [
    {
      'question': 'What is Flutter?',
      'answer': 'Flutter is an open-source UI software development toolkit created by Google.'
    },
    {
      'question': 'How to add an FAQ?',
      'answer': 'Click the "+" button and fill out the form.'
    },
  ];

  TextEditingController questionController = TextEditingController();
  TextEditingController answerController = TextEditingController();
  TextEditingController idController = TextEditingController();


  void _addFAQ(String question, String answer, String ID) {
    setState(() {
      faqs.add({'ID': ID, 'question': question, 'answer': answer});
    });
  }

  void _updateFAQ(int index, String question, String answer, String ID) {
    setState(() {
      faqs[index] = {'ID': ID, 'question': question, 'answer': answer};
    });
  }

  void _deleteFAQ(int index) {
    setState(() {
      faqs.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ Page'),
      ),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(faqs[index]['question'] ?? ''),
              subtitle: Text(faqs[index]['answer'] ?? ''),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      idController.text = faqs[index]['id'] ?? '';
                      questionController.text = faqs[index]['question'] ?? '';
                      answerController.text = faqs[index]['answer'] ?? '';
                      update();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Edit FAQ'),
                            content: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: idController,
                                      decoration: InputDecoration(
                                          labelText: 'ID'),
                                    ),
                                    TextField(
                                      controller: questionController,
                                      decoration: InputDecoration(
                                          labelText: 'Question'),
                                    ),
                                    TextField(
                                      controller: answerController,
                                      decoration: InputDecoration(
                                          labelText: 'Answer'),
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
                                  _updateFAQ(index, questionController.text,
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
                            title: Text('Delete FAQ'),
                            content: Text(
                                'Are you sure you want to delete this FAQ?'),
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
                                  _deleteFAQ(index);
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
                title: Text('Add FAQ'),
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
                      _addFAQ(questionController.text, answerController.text,
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
        "SELECT * FROM faq WHERE FAQ_Headline = '$select' "); //idk why it errors out
    print(result.affectedRows);
    for (final row in result.rows) {
      final data = {
      setState((){
        test: row.colAt(1)!;
      }),
      };


      print("this is a test $test");

      var res = await conn.execute(
        "UPDATE faq (FAQ_Headline,FAQ_Content,FAQ_num) VALUES (:vid1, :vn1, :num1) FAQ_num = $test",
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
