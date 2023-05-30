// ignore_for_file: unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_const_constructors

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dreamsober/models/drink.dart';
import 'package:dreamsober/models/drinkDB.dart';
import 'package:dreamsober/models/userprefs.dart';
import 'package:dreamsober/screens/managedrink.dart';
import 'package:dreamsober/screens/databasepage.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

class DrinkPage extends StatefulWidget {
  final String userUID = UserPrefs.getUID();
  DrinkPage({super.key});
  static String route = "/drink/";
  static String routeName = "What did you drink today?";
  @override
  State<StatefulWidget> createState() => _DrinkState();
}

class _DrinkState extends State<DrinkPage> {
  final Color mainColor = Color.fromARGB(255, 69, 63, 57);
  final Color secondaryColor = Color.fromARGB(255, 146, 138, 122);
  final List<String> imgs = [
    'assets/beer.png',
    'assets/cocktail.png',
    'assets/whiskey.png',
    'assets/wine-bottle.png'
  ];
  final List<Drink> drinks = [
    Drink('Beer', 5, 400, 5),
    Drink('Cocktail', 8, 200, 8),
    Drink('Super Alcoholics', 40, 40, 6),
    Drink('Wine', 12, 150, 4)
  ];
  @override
  void initState() {
    for (Drink drink in drinks) {
      drink.calCal();
    }
    super.initState();
  }

  // Carousel Variables
  final CarouselController _carouselController = CarouselController();
  int _currentIdx = 0;

  // Date Variables

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    //log(height.toString());
    if (height < 700) {
      return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SizedBox(
          height: height - 100,
          child: _mainApp(context),
        ),
      );
    } else {
      return _mainApp(context);
    }
  }

  Widget _mainApp(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(215, 204, 200, 1),
      resizeToAvoidBottomInset: false,
      body: _appBody(context),
      floatingActionButton: _floatingButtons(context),
    );
  }

  Widget _floatingButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _listButton(context),
        SizedBox(width: 215),
        _saveButton(context),
      ],
    );
  }

  Widget _appBody(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        _backGroundDeco(context),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30),
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
    );
  }

  Widget _backGroundDeco(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Positioned(
          top: 20,
          left: screenWidth / 2 - 125,
          child: SizedBox(
            height: 250,
            width: 250,
            child: Container(
              decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.all(Radius.circular(125))),
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: screenWidth / 2 + 60,
          child: SizedBox(
            height: 60,
            width: 60,
            child: Consumer<DailyDrinkDB>(
              builder: (context, dailyDrinkDB, _) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: secondaryColor,
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
          color: secondaryColor,
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
                    "Volume: ~ ${drinks[_currentIdx.toInt()].volume.toInt()} ml",
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    "Calories: ~ ${drinks[_currentIdx.toInt()].cal.toInt()}",
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    "Price: ~ ${drinks[_currentIdx.toInt()].price} €",
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
              child: Consumer<DailyDrinkDB>(
                builder: (context, db, _) => Text(
                  DateFormat('dd-MM-yyyy')
                      .format(db.date)
                      .split(' ')[0]
                      .replaceAll("-", "/"),
                ),
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
        Navigator.pushNamed(context, ManageDrinkPage.route,
            arguments: widget.userUID);
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
              Navigator.pushNamed(context, DatabasePage.route,
                  arguments: widget.userUID);
            },
            backgroundColor: mainColor,
            child: Icon(Icons.menu),
          );
        } else {
          return FloatingActionButton(
            heroTag: "btn2",
            onPressed: () {
              context.read<DailyDrinkDB>().addDate(DateTime.now());
              Navigator.pushNamed(context, DatabasePage.route,
                  arguments: widget.userUID);
              db.mod(true);
            },
            backgroundColor: mainColor,
            child: Icon(Icons.arrow_back),
          );
        }
      },
    );
  }
}
