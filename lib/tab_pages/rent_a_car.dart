import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class rentacarpage extends StatefulWidget {
  const rentacarpage({super.key});

  @override
  State<rentacarpage> createState() => _rentacarpageState();
}

class _rentacarpageState extends State<rentacarpage> {
  /*final Completer<GoogleMapController> _controllerGoogleMap = Completer<GoogleMapController>();
  GoogleMapController? newGoogleMapController;*/

  //for dark mode

  /*static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
      children: [

    ]
    ),
    );
  }
}
