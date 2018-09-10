import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker_app/src/screens/home.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    FirebaseDatabase.instance.setPersistenceEnabled(true);

    return MaterialApp(
      title: "Weight Tracker",
      home: Home(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
    );
  }
}
