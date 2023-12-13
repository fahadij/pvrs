/*import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:mysql_client/mysql_client.dart';





class reservation extends StatefulWidget {
  const reservation({super.key});

  @override
  State<reservation> createState() => _reservationState();
}

class _reservationState extends State<reservation> {
  @override

  final connection = await MySQLConnection.createConnection(
  host: '10.0.2.2',
  port: 3306,
  userName: 'root',
  password: 'root',
  databaseName: 'pvers',
  );

  void Reservation() {
  String vehicleId;
  String userId;
  DateTime reservedAt;
  DateTime reservedUntil;

  Future<int> createReservation() async {
  final connection = await MySQLConnection.createConnection(
  host: '10.0.2.2',
  port: 3306,
  userName: 'root',
  password: 'root',
  databaseName: 'pvers',
  );

  final statement = connection.prepare('INSERT INTO reservation (V_num_RES, V_Renter_Id, RES_Time, RES_Status) VALUES (?, ?, NOW(), "Pending")');
  await statement.execute([vehicleId, userId]);
  connection.close();
  return 1; // Reservation created successfully
  }

  // Read, update, and delete reservations are similar
  }
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
*/