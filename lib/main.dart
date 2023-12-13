import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:pvers_customer/splashScreen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';



void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    //androidProvider: AndroidProvider.debug,
    androidProvider: AndroidProvider.playIntegrity,
  );

  runApp(
    MyApp(
      child:MaterialApp(
        title: 'PVER Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MySplashScreen(),
        debugShowCheckedModeBanner: false,
      )
    )
  );
}

class MyApp extends StatefulWidget
{

   final Widget? child;

   MyApp({this.child});

   static void restartApp(BuildContext context){
     context.findAncestorStateOfType<_MyAppState>()!.restartApp();
   }


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Key key = UniqueKey();
  void restartApp(){
    setState(() {
      Key key = UniqueKey();
    });
  }
  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
        child: widget.child!,
    );
  }
}

