import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tile Tunes'),
      ),
      body: const Center(
        child: Text('Welcome to Tile Tunes!',
        style: TextStyle(fontSize: 24))
      ),
    );
  }
}