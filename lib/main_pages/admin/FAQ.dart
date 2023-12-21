import 'dart:ffi';

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
      'question': 'what is the age limit?',
      'answer': 'because you can''t register in the app without an id photo and a payment methed to pay we require all users of the app to be 18 and above.'
    },
    {
    'question': 'how can i register?',
    'answer': 'Creating an PVRS account is easy! You need to be at least 18 years of age and have the following:-A valid national ID or iqama ID -A valid credit or debit card.'
    },
    {
     'question': 'when will i get charged?',
     'answer': 'For the Booking fee you will be chagred as soon as you place a Booking request.'
    },
    {
      'question': 'How to add an FAQ?',
      'answer': 'Click the "+" button and fill out the form.'
    },
  ];

  TextEditingController questionController = TextEditingController();
  TextEditingController answerController = TextEditingController();
  TextEditingController idController = TextEditingController();
  String? ID_delete;
  String? ID_update;


  void _addFAQ(String question, String answer, String id) {
    setState(() {
      faqs.add({'id': id ,'question': question, 'answer': answer});
    });
  }

  void _updateFAQ(int index, String question, String answer,String id) {
    setState(() {
      faqs[index] = {'id': id ,'question': question, 'answer': answer};
      ID_update= faqs[index]['id'];
    });
  }

  void _deleteFAQ(int index) {
    setState(() {
      ID_delete =faqs[index]['id'];
      faqs.removeAt(index);
    });
  }



  Future<void> fetchFAQsFromDatabase() async {
    // Establish a connection with your database.
    final conn = await MySQLConnection.createConnection(
      host: "10.0.2.2",
      port: 3306,
      userName: "root",
      password: "root",
      databaseName: "pvers",
    );

    await conn.connect();
    var results = await conn.execute("SELECT * FROM faq");

    List<Map<String, String>> list = [];

    for (final row in results.rows) {
      final data = {
        'id': row.colByName("faq_num") as String,
        'question': row.colByName("faq_headline") as String,
        'answer': row.colByName("faq_content") as String,
      };
      list.add(data);
       setState(() {
       faqs = list;
       });


    }
    print("fetch completed");
    await conn.close();

  }

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchFAQsFromDatabase();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                                      decoration: InputDecoration(labelText: 'ID'),
                                      readOnly: true,
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
                                      answerController.text,idController.text);
                                  Navigator.of(context).pop();
                                  update();
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
                          readOnly: true,
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
                      _addFAQ(questionController.text, answerController.text,idController.text);
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
    var question_db = questionController.text;
    var answer_db = answerController.text;
    print("Connecting to MySQL server...");
    print(question_db);
    print(answer_db);


    final conn = await MySQLConnection.createConnection(
      host: '10.0.2.2',
      port: 3306,
      userName: 'root',
      password: 'root',
      databaseName: 'pvers',
    );


    await conn.connect();
    print("Connected");

      var res = await conn.execute("UPDATE faq SET faq_Headline= '$question_db', faq_Content= '$answer_db' WHERE faq_num = $ID_update");
      print(res.affectedRows);
       ID_update ="";
    print("this is the value of the id after the update$ID_update");
      await conn.close();
    fetchFAQsFromDatabase();
    Fluttertoast.showToast(msg: "the FAQ updated successfully");
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
        "INSERT INTO faq (faq_headline,faq_content) VALUES (:vid1, :vn1)",
        {
          "vid1": questionController.text.trim(),
          "vn1": answerController.text.trim(),
        },
      );
      print(res.affectedRows);

      await conn.close();
      fetchFAQsFromDatabase();
      Fluttertoast.showToast(msg: "the FAQ registered successfully");
    }

    Future<void> deletfaq() async {
      print("Connecting to mysql server...");
      String? test;
      String select = questionController.text;


      final conn = await MySQLConnection.createConnection(
          host: '10.0.2.2',
          port: 3306,
          userName: 'root',
          password: 'root',
          databaseName: 'pvers');

      await conn.connect();
      print("Connected");

      var res = await conn.execute("DELETE FROM faq WHERE FAQ_num = $ID_delete");
      print(res.affectedRows);

      await conn.close();
      Fluttertoast.showToast(msg: "the FAQ deleted successfully");
      fetchFAQsFromDatabase();
    }
  }
