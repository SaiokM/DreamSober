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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.all(12), // Set margins on all sides
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Column(
                  children: const [
                    Text(
                      'Welcome to DreamSober!',
                      style: TextStyle(
                          fontSize: 25,
                          color: Color.fromRGBO(62, 39, 35, 1),
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    Text(
                      'This app calculates the user\'s sleep quality and tracks his alcohol consumption',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 10),
                    Icon(Icons.warning,
                        size: 30, color: Color.fromRGBO(231, 209, 13, 1)),
                    Text(
                      'To use this app, you need a Fitbit watch or Impact credentials\n',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 216, 72, 70),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'The user have to manually insert his alcohol consumption',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Sleep quality is calculated considering 5 parameters:\n'
                      '1) Sleep Efficiency: is the ratio between the time a person spends asleep, and the total time dedicated to sleep. It is given as a percentage\n'
                      '2) Sleep Latency: is the time it takes a person to fall asleep after turning the lights out\n'
                      '3) Sleep Duration: is the quantity of time that a person sleeps\n'
                      '4) WASO (Wakefulness After Sleep Oncet): It is the total number of minutes that a person is awake after having initially fallen asleep\n'
                      '5) Sleep\'s Phases',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    Text(
                      'The sleep cycle is divided into three phases:\n'
                      'Light Phase (60%): phase when a person is most easily awoken\n'
                      'Deep Phase (15%): phase where breathing and heart rate drop to their lowest levels, and brain activity slows\n'
                      'REM Phase (25%): the stage of sleep with the highest brain activity and often associated with intense dreaming',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
        ),
      ),
    );
  }
}
