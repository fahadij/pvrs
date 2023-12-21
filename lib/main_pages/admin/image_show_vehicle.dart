import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ImageUploadPagevehicle extends StatefulWidget {
  @override
  _ImageUploadPageStatevehicle createState() => _ImageUploadPageStatevehicle();
}

class _ImageUploadPageStatevehicle extends State<ImageUploadPagevehicle> {
  File? _image;
  String? token;
  String? token3;
  String? _imageLink;

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    //_retrieveImage();

  }

  final picker = ImagePicker();


  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("ID1")!;
      token3 = pref.getString("selectedVIDreft")!;
      //nameTextEditingController.text =
      print(token3);
      print(token);
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

      final storageRef = FirebaseStorage.instance.ref().child('images/vheicle/$token3/$token');
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
          "UPDATE vehicle SET V_pictures_front = '$_imageLink' WHERE V_num ='$token3'");
      await conn.close();
      Fluttertoast.showToast(msg: "the user updated the image successfully");
    }
  }

  Future<void> _retrieveImage() async {
    print("Connecting to mysql server...");
    final conn = await MySQLConnection.createConnection(
        host: '10.0.2.2',
        port: 3306,
        userName: 'root',
        password: 'root',
        databaseName: 'pvers');
    await conn.connect();
    print("Connected");
    getCred();

    final result = await conn.execute(
        "SELECT  V_pictures_front  FROM vehicle WHERE V_num ='$token3'");
    for (final row in result.rows) {
      _imageLink = row.colByName("V_pictures_front");
    }
    await conn.close();
    Fluttertoast.showToast(msg: "the user updated the image successfully");
  }


//final row = res.affectedRows;
//final imageLink = row['image_link'] as String?;


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
                _imageLink!,
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