// ignore_for_file: unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_const_constructors

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dreamsober/models/drink.dart';
import 'package:dreamsober/models/drinkDB.dart';
import 'package:dreamsober/screens/managedrink.dart';
import 'package:dreamsober/screens/databasepage.dart';
import 'package:provider/provider.dart';

class DrinkPage extends StatefulWidget {
  DrinkPage({super.key});
  static String route = "/drink/";
  static String routeName = "What did you drink today?";
  @override
  State<StatefulWidget> createState() => _DrinkState();
}

class _DrinkState extends State<DrinkPage> {
  final Color mainColor = Color.fromARGB(255, 97, 96, 95);
  final List<String> imgs = [
    'assets/beer.png',
    'assets/cocktail.png',
    'assets/whiskey.png',
    'assets/wine-bottle.png'
  ];
  final List<Drink> drinks = [
    Drink('Beer', 4, 500),
    Drink('Cocktail', 8, 200),
    Drink('Super Alcoholics', 40, 40),
    Drink('Wine', 12, 150)
  ];

  // Carousel Variables
  final CarouselController _carouselController = CarouselController();
  int _currentIdx = 0;

  // Date Variables

  @override
  Widget build(BuildContext context) {
    return _mainApp(context);
  }

  Widget _mainApp(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(215, 204, 200, 1),
      resizeToAvoidBottomInset: false,
      /*
      appBar: AppBar(
        title: Text(DrinkPage.routeName),
        centerTitle: true,
        backgroundColor: mainColor,
      ),*/
      body: Stack(
        children: [
          _backGroundDeco(context),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 50),
              _buildCarousel(context),
              _buildCard(context),
              SizedBox(height: 10),
              _buttonSet(context),
              SizedBox(height: 10),
              _datePicker(context),
              SizedBox(height: 5),
              _resetButton(context),
            ],
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _listButton(context),
          SizedBox(width: 215),
          _saveButton(context),
        ],
      ),
    );
  }

  Widget _backGroundDeco(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Positioned(
          top: 40,
          left: screenWidth / 2 - 125,
          child: SizedBox(
            height: 250,
            width: 250,
            child: Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 58, 57, 69),
                  borderRadius: BorderRadius.all(Radius.circular(125))),
            ),
          ),
        ),
        Positioned(
          top: 30,
          left: screenWidth / 2 + 60,
          child: SizedBox(
            height: 60,
            width: 60,
            child: Consumer<DailyDrinkDB>(
              builder: (context, dailyDrinkDB, _) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 125, 122, 146),
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: Text(
                    dailyDrinkDB
                        .getDrinkCount(drinks[_currentIdx].name)
                        .toString(),
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarousel(BuildContext context) {
    return CarouselSlider(
      carouselController: _carouselController,
      items: [0, 1, 2, 3]
          .map(
            (i) => Center(
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                constraints: BoxConstraints.tightForFinite(
                  width: 140,
                  height: 160,
                ),
                child: Image.asset(
                  imgs[i],
                  fit: BoxFit.contain,
                ),
              ),
            ),
          )
          .toList(),
      options: CarouselOptions(
        height: 190,
        onPageChanged: ((index, reason) {
          _currentIdx = index;
          context.read<DailyDrinkDB>().notifyChange();
        }),
        viewportFraction: 0.7,
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Consumer<DailyDrinkDB>(
      builder: (context, dailyDrinkDB, _) {
        return Card(
          color: Color.fromARGB(255, 170, 167, 196),
          elevation: 5,
          child: SizedBox(
            width: 200,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    drinks[_currentIdx.toInt()].name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    "Alcohol Content: ~ ${drinks[_currentIdx.toInt()].perc}%",
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    "Volume: ~ ${drinks[_currentIdx.toInt()].volume} ml",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buttonSet(BuildContext context) {
    int index = 0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: mainColor,
          ),
          onPressed: () {
            _carouselController.previousPage();
          },
          child: Icon(Icons.arrow_left),
        ), //left button
        SizedBox(width: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            fixedSize: Size(50, 50),
            backgroundColor: mainColor,
          ),
          onPressed: () {
            context
                .read<DailyDrinkDB>()
                .removeDrink(drinks[_currentIdx].name, 1);
          },
          child: Icon(Icons.remove),
        ), //remove
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            fixedSize: Size(50, 50),
            backgroundColor: mainColor,
          ),
          onPressed: () {
            context.read<DailyDrinkDB>().addDrink(drinks[_currentIdx].name, 1);
          },
          child: Icon(Icons.add),
        ), //add
        SizedBox(width: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: mainColor,
          ),
          onPressed: () {
            _carouselController.nextPage();
          },
          child: Icon(Icons.arrow_right),
        ), //right button
      ],
    );
  }

  Widget _resetButton(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: mainColor,
        ),
        onPressed: () => context.read<DailyDrinkDB>().resetDB(),
        child: Text("Reset Drinks"));
  }

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(
              primarySwatch: Colors.grey,
              splashColor: Colors.black,
              textTheme: TextTheme(
                titleMedium: TextStyle(color: Colors.black),
                labelLarge: TextStyle(color: Colors.black),
              ),
              colorScheme: ColorScheme.light(
                  primary: mainColor,
                  onSecondary: Colors.red,
                  onPrimary:
                      Color.fromARGB(255, 163, 163, 199), //title text color
                  surface: Colors.black,
                  onSurface: Colors.black,
                  secondary: Colors.black),
              dialogBackgroundColor: Colors.white, // background color
            ),
            child: child ?? Text(""),
          );
        },
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        context.read<DailyDrinkDB>().addDate(selectedDate);
      });
    }
  }

  Widget _datePicker(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: mainColor,
          ),
          onPressed: () {
            if (context.read<DailyDrinkDB>().modify) {
              _selectDate(context);
            }
          },
          child: SizedBox(
            width: 100,
            height: 40,
            child: Center(
              child: Text(
                DateFormat('dd-MM-yyyy')
                    .format(context.read<DailyDrinkDB>().date)
                    .split(' ')[0]
                    .replaceAll("-", "/"),
              ),
            ),
          ),
        ),
        //Text(DateFormat('dd-MM-yyyy').format(context.read<DailyDrinkDB>().date).split(' ')[0]),
      ],
    );
  }

  Widget _saveButton(BuildContext context) {
    return FloatingActionButton(
      heroTag: "btn1",
      onPressed: () {
        Navigator.pushNamed(context, ManageDrinkPage.route);
      },
      backgroundColor: mainColor,
      child: Icon(Icons.check),
    );
  }

  Widget _listButton(BuildContext context) {
    return Consumer<DailyDrinkDB>(
      builder: (context, db, _) {
        if (db.modify) {
          return FloatingActionButton(
            heroTag: "btn2",
            onPressed: () {
              Navigator.pushNamed(context, DatabasePage.route);
            },
            backgroundColor: mainColor,
            child: Icon(Icons.menu),
          );
        } else {
          return SizedBox(
            height: 50,
            width: 50,
          );
        }
      },
    );
  }
}
