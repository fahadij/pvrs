import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FAQPage(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.white, // Set title color to white
            fontSize: 20.0, // Optional: Adjust the font size
          ),
        ),
      ),
    );
  }
}

class FAQPage extends StatelessWidget {
  final List<Map<String, String>> faqList = [
    {'question': 'what is the age limit?', 'answer': 'because you can''t register in the app without an id photo and a payment methed to pay we require all users of the app to be 18 and above.'},
    {'question': 'how can i register?', 'answer': 'Creating an PVRS account is easy! You need to be at least 18 years of age and have the following:-A valid national ID or iqama ID -A valid credit or debit card'},
    {'question': 'when will i get charged?', 'answer': 'For the Booking fee you will be chagred as soon as you place a Booking request.'}
    // Add more questions and answers as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove back button
        title: Text(
          'FAQ Page',
          style: TextStyle(color: Colors.white), // Set title color to white
        ),
      ),
      body: ListView.builder(
        itemCount: faqList.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(
              faqList[index]['question']!,
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  faqList[index]['answer']!,
                  style: TextStyle(color: Colors.white), // Set text color to white
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}