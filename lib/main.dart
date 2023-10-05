import 'package:flutter/material.dart';
import 'package:pvers_customer/splashScreen/splash_screen.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
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

