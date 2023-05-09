import 'package:flutter/material.dart';

class UpDatePage extends StatelessWidget {
  const UpDatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.brown[900],),
      body:Center(child: Text("Avaible from the next update"),)
    );
  }
}