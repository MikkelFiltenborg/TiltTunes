import 'package:flutter/material.dart';
import 'features/soundboard/screens/home_screen.dart';
import 'package:flutter_sensors_plus/flutter_sensors_plus.dart';
import 'dart:async';

void main() {
  runApp(TiltTunesApp());
}

class TiltTunesApp extends StatelessWidget {
  const TiltTunesApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tilt Tunes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home:HomeScreen(), // Defines Init Load Page
    );
  }
}