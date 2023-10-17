import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  File? _image;
  String? _imageLink;
  String? token;
  String? token2;

  final picker = ImagePicker();
  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
       token = pref.getString("ID1")!;
       token2 = pref.getString("ID1")!;
      //nameTextEditingController.text =
    });
  }

  Future<void> _uploadImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    getCred();

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      final storageRef = FirebaseStorage.instance.ref().child('images/$token');
      final imageName = _image!.path.split('/').last;
      final imageRef = storageRef.child(imageName);

      final uploadTask = imageRef.putFile(_image!);
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _imageLink = downloadUrl;
      });

      setState(() {
        _imageLink = downloadUrl;
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();

print(_imageLink);
      print("Connecting to mysql server...");
      final conn = await MySQLConnection.createConnection(
          host: '10.0.2.2',
          port: 3306,
          userName: 'root',
          password: 'root',
          databaseName: 'pvers');

      await conn.connect();

      print("Connected");
      final result = await conn.execute(
        "UPDATE owner SET owner_picture_link = '$_imageLink' WHERE owner_id ='$token'");
      await conn.close();
    }
  }

  Future<void> _retrieveImage() async {
    getCred();
    print("Connecting to mysql server...");
    final conn = await MySQLConnection.createConnection(
        host: '10.0.2.2',
        port: 3306,
        userName: 'root',
        password: 'root',
        databaseName: 'pvers');
    await conn.connect();
    print("Connected");
    final res = await conn.execute(
      "SELECT owner_picture_link FROM owner WHERE owner_id = $token2 "
    );
    for (final row in res.rows) {
      _imageLink = row.colByName("owner_picture_link");
    }

    //final row = res.affectedRows;
    //final imageLink = row['image_link'] as String?;

    await conn.close();




    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           if (_imageLink != null)
              Image.network(
              _imageLink! ,
              height: 200,
               ),

            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Upload Image'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _retrieveImage,
              child: Text('Retrieve Image'),
            ),
          ],
        ),

      ),
    );
  }
}