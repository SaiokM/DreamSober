import 'package:flutter/material.dart';
import 'package:dreamsober/screens/drinkpage.dart';
import 'package:dreamsober/screens/graph.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key});
  static String route = "/home/";
  static String routeName = "Home Page";

  final Color mainColor = const Color.fromARGB(255, 42, 41, 50);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(PlaceholderPage.routeName),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, DrinkPage.route);
              },
              child: const Text("To Drink Page"),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, ChartPage.route);
              },
              child: const Text("To Chart Page"),
            ),
          ],
        ),
      ),
    );
  }
}
