/*import 'package:flutter/material.dart';
import 'package:booking_calendar/booking_calendar.dart';
import 'package:mysql1/mysql1.dart';

class DatabaseConnection {
  static final MySqlConnection _connection = MySqlConnection(ConnectionSettings(
    host: 'your_mysql_host',
    port: 3306,
    user: 'your_mysql_user',
    db: 'your_mysql_database',
    password: 'your_mysql_password',
  ));

  static Future<void> openConnection() async {
    await _connection.open();
  }

  static MySqlConnection get connection => _connection;
}

class Booking {
  int id;
  String title;
  DateTime date;

  Booking(this.id, this.title, this.date);

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      json['id'],
      json['title'],
      DateTime.parse(json['date']),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseConnection.openConnection();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<List<Booking>> getBookings() async {
    final MySqlConnection connection = DatabaseConnection.connection;

    Results results = await connection.query('SELECT * FROM bookings');
    List<Booking>? bookings = results.map((Row row) {
      return Booking.fromJson(row.fields);
    }).toList();

    return bookings;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Booking Calendar Example'),
        ),
        body: FutureBuilder<List<Booking>>(
          future: getBookings(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return BookingCalendar(
                bookings: snapshot.data,
                // Other calendar properties go here
              );
            }
          },
        ),
      ),
    );
  }
}
*/