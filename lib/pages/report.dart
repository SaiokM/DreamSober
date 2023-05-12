import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.brown[100],
       body: Column(
        children: [
          // Day Report
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 250,
              color: Colors.brown[300],
            ),
          ),
          
          // HR Grafico 
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 150,
              color: Colors.brown[300],
            ),
          ),

          // alcohol expenses
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 150,
              color: Colors.brown[300],
            ),
          ),
        ],
       ),
    );
  }
}