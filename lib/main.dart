import 'package:flight_search/homepage.dart';
import 'package:flutter/material.dart';

void main() => runApp(FlightSearch());

class FlightSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flight Search',
      theme: ThemeData(primarySwatch: Colors.red),
      home: Homepage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
