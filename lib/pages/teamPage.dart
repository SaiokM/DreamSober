// ignore_for_file: file_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});
  static String route = "/team/";

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  List<String> imgList = [
    'assets/ale.jpg',
    'assets/saiok.jpg',
    'assets/giulio.jpg',
  ];
  List<String> nameList = ['Alessandro', 'Saiok', 'Giulio'];
  List<String> textList = [
    "Health advisor of the group, gym addict, calories obsessed.\n\n He wrote the function to calculate the sleep quality and we still don't know how.\n\nLikes to upload code without first testing it.\n\nOverall a nice guy.",
    "Group manager and page designer. He choose the color palette based on himself.\n\nAvid chatGPT user but he actually knows what he's doing (most of the times).\n\nAsks Giulio to fix what Alessandro broke.",
    "The only one who can actualy code without chatGPT. \n\n The app was basically wrote by him for himself, due to his known alcohol problems.\n\nHe can't take it anymore and just wants to graduate.",
  ];
  List<String> quoteList = [
    "Fioi ho pushato",
    "Ale porca puttana!",
    "Sono stanco, fate voi"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(215, 204, 200, 1),
      appBar: AppBar(
        title: const Text("Meet the Well-Yes team!"),
        backgroundColor: Colors.brown[900],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: CarouselSlider(
            items: memberCard(context),
            options: CarouselOptions(
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 30),
              //autoPlayCurve: Curves.easeOutSine,
              viewportFraction: 1,
              height: 600,
              onPageChanged: ((index, reason) {}),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> memberCard(BuildContext context) {
    return List.generate(
      3,
      (i) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 15),
          Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              ClipOval(
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(100), // Image radius
                  child: Image.asset(imgList[i]),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 160,
                  ),
                  Card(
                    elevation: 5,
                    color: Colors.brown[400],
                    child: SizedBox(
                      width: 260,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          textAlign: TextAlign.center,
                          nameList[i],
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Expanded(
                      child: Card(
                        elevation: 5,
                        color: Colors.brown[200],
                        child: SizedBox(
                          width: 250,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              '\'\'${quoteList[i]}\'\'',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Expanded(
                      child: Card(
                        elevation: 5,
                        color: Colors.brown[200],
                        child: SizedBox(
                          //height: 200,
                          width: 250,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              textList[i],
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}


/*

        child: CarouselSlider(
          items: memberCard(context),
          options: CarouselOptions(
            onPageChanged: ((index, reason) {}),
          ),
        ),
        */