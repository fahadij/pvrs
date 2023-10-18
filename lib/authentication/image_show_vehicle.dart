import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageUploadPagevehicle extends StatefulWidget {
  @override
  _ImageUploadPageStatevehicle createState() => _ImageUploadPageStatevehicle();
}

class _ImageUploadPageStatevehicle extends State<ImageUploadPagevehicle> {
  File? _image;
  String? imageLink_front="https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fnull%2F1000000034.png?alt=media&token=529b684c-2a6a-4d11-9a3a-ea7202c5ad23";
  String? imageLink_back="https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fnull%2F1000000034.png?alt=media&token=529b684c-2a6a-4d11-9a3a-ea7202c5ad23";
  String? imageLink_left="https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fnull%2F1000000034.png?alt=media&token=529b684c-2a6a-4d11-9a3a-ea7202c5ad23";
  String? imageLink_right="https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fnull%2F1000000034.png?alt=media&token=529b684c-2a6a-4d11-9a3a-ea7202c5ad23";
  String? token;
  String? token2;
  String? token3;

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    _retrieveImage();
    getCred();
  }
  final picker = ImagePicker();
  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("ID1")!;
      token2 = pref.getString("ID1")!;
      token3 = pref.getString("selectedVIDreft")!;
      //nameTextEditingController.text =
    });
  }


  Future<void> _uploadImage_front() async {
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
        imageLink_front = downloadUrl;
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      print(imageLink_front);
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
          "UPDATE vehicle SET V_pictures_front = '$imageLink_front' WHERE owner_id ='$token3'");
      await conn.close();
    }
  }

  Future<void> _uploadImage_right() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    getCred();

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });


      final storageRef = FirebaseStorage.instance.ref().child('images/$token3/$token');
      final imageName = _image!.path.split('/').last;
      final imageRef = storageRef.child(imageName);

      final uploadTask = imageRef.putFile(_image!);
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        imageLink_right = downloadUrl;
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      print(imageLink_right);
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
          "UPDATE vehicle SET V_pictures_right = '$imageLink_right' WHERE V_num ='$token3'");
      await conn.close();
    }
  }

  Future<void> _uploadImage_left() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    getCred();

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });


      final storageRef = FirebaseStorage.instance.ref().child('images/$token3/$token');
      final imageName = _image!.path.split('/').last;
      final imageRef = storageRef.child(imageName);

      final uploadTask = imageRef.putFile(_image!);
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        imageLink_left = downloadUrl;
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      print(imageLink_left);
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
          "UPDATE vehicle SET V_pictures_left = '$imageLink_left' WHERE V_num ='$token3'");
      await conn.close();
    }
  }

  Future<void> _uploadImage_back() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    getCred();

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });


      final storageRef = FirebaseStorage.instance.ref().child('images/$token3/$token');
      final imageName = _image!.path.split('/').last;
      final imageRef = storageRef.child(imageName);

      final uploadTask = imageRef.putFile(_image!);
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        imageLink_back = downloadUrl;
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      print(imageLink_back);
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
          "UPDATE vehicle SET V_pictures_back = '$imageLink_back' WHERE V_num ='$token3'");
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
        "SELECT * FROM vehicle WHERE V_num = $token3 "
    );
    for (final row in res.rows) {
      imageLink_front = row.colByName("V_pictures_front");
      imageLink_back = row.colByName("V_pictures_back");
      imageLink_left = row.colByName("V_pictures_left");
      imageLink_right = row.colByName("V_pictures_right");
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
        child: SingleChildScrollView(
         scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageLink_right != null && imageLink_left != null && imageLink_front != null && imageLink_back != null)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Image.network(
                      imageLink_right!,
                      height: 150,
                      width: 150,
                    ),
                    ElevatedButton(
                      onPressed: _uploadImage_right,
                      child: Text('Upload Image right of the vehicle'),
                    ),
                  ],
                ),
                SizedBox(width: 16),
                Column(
                  children: [
                    Image.network(
                      imageLink_left!,
                      height: 150,
                      width: 150,
                    ),
                    ElevatedButton(
                      onPressed: _uploadImage_left,
                      child: Text('Upload Image left of the vehicle'),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Column(
                  children: [
                    Image.network(
                      imageLink_front!,
                      height: 150,
                      width: 150,
                    ),
                    ElevatedButton(
                      onPressed: _uploadImage_front,
                      child: Text('Upload Image front of the vehicle'),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Column(
                  children: [
                    Image.network(
                      imageLink_back!,
                      height: 150,
                      width: 150,
                    ),
                    ElevatedButton(
                      onPressed: _uploadImage_back,
                      child: Text('Upload Image back of the vehicle'),
                    ),
                  ],
                ),
                  ],
                ),

               Column(
                 children: [
                 Image.network(
                 imageLink_back!,
                 height: 150,
                 width: 150,
                 ),
                ElevatedButton(
                 onPressed: _retrieveImage,
                 child: Text('Retrieve Image'),
               ),
          ],
        ),
        ]

        ),

      ),





        ),
      );
  }
}