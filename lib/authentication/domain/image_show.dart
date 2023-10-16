import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class ImageDisplayPage extends StatefulWidget {
  @override
  _ImageDisplayPageState createState() => _ImageDisplayPageState();
}

class _ImageDisplayPageState extends State<ImageDisplayPage> {
  Uint8List? imageData;
  var token;

  void initState() {
    super.initState();
    getCred();
    _fetchImages();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("ID1")!;
      print(token);
    });
  }

  Future<void> _fetchImages() async {
    final MySqlConnection connection = await MySqlConnection.connect(
      ConnectionSettings(
        host: '10.0.2.2',
        port: 3306,
        user: 'root',
        db: 'pvers',
        password: 'root',
      ),
    );

    var results = await connection.query(
      "SELECT owner_id_picture FROM owner WHERE owner_id = ?",
      [int.parse(token)],
    );

    for (var row in results) {
      setState(() {
        imageData = row[0] as Uint8List?;
      });
    }



    await connection.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Display'),
      ),
      body: Center(
        child: imageData != null
            ? Image.memory(
          imageData!,
          height: 200,
        )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchImages,
        tooltip: 'Load Image',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
