import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[900],
        title: const Text('Useful Informations'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 30.0,
            ), // Aggiungi uno spazio di 30 unità in alto
            child: Center(
              child: Column(
                children: const [
                  Text(
                    'Welcome to DreamSober!',
                    style: TextStyle(fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Text('This app calculates the user\'s sleep quality and tracks his alcohol consumption',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ), 
                  ),
                  SizedBox(height: 10),
                  Icon(Icons.warning,
                      size: 30, color: Color.fromRGBO(231, 209, 13, 1)),
                  Text('To use this app, you need a Fitbit watch or Impact credentials',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 216, 72, 70),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text('The user have to manually insert his alcohol consumption',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 216, 72, 70),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Sleep quality is calculated considering 5 parameters:',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '1) Sleep Efficiency: is the ratio between the time a person spends asleep, and the total time dedicated to sleep. It is given as a percentage',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    '2) Sleep Latency: is the time it takes a person to fall asleep after turning the lights out',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    '3) Sleep Duration: is the quantity of time that a person sleeps',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    '4) WASO (Wakefulness After Sleep Oncet): It is the total number of minutes that a person is awake after having initially fallen asleep',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    '5) Sleep\'s Phases',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    'The sleep cycle is divided into three phases:',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    'Light Phase (60%): phase when a person is most easily awoken',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    'Deep Phase (15%): phase where breathing and heart rate drop to their lowest levels, and brain activity slows',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    'REM Phase (25%): the stage of sleep with the highest brain activity and often associated with intense dreaming',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.left,
                  ),

                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Not Available"),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const Text(
                ' • ',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Not Available"),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: const Text(
                  'Terms of Service',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
