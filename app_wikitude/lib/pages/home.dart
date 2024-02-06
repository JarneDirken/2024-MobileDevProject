import 'arexercise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:augmented_reality_plugin_wikitude/wikitude_plugin.dart';
import 'package:augmented_reality_plugin_wikitude/wikitude_response.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color backgroundColor = Color(0xFFECF0FE);
  static const Color textColor = Color(0xFF020A22);
  static const Color buttonColor = Color(0xFF698CD3);
  List<String> features = ["image_tracking"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/globals/Fitness_tracker-bro.svg',
              width: 400,
              height: 400,
            ),
            const SizedBox(height: 0),
            const Text(
              'Energize your life!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'If you want to be a hit in life,',
              style: TextStyle(
                fontSize: 18,
                color: textColor,
                fontWeight: FontWeight.w300,
              ),
            ),
            const Text(
              'you gotta be fit and fine.',
              style: TextStyle(
                fontSize: 18,
                color: textColor,
                fontWeight: FontWeight.w300,
              ),
            ),
            const Text(
              'So start scanning!',
              style: TextStyle(
                fontSize: 18,
                color: textColor,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: navigateToExercise,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                minimumSize: const Size(250, 60),
              ),
              child: const Text(
                'Start Scanning',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToExercise() {
    debugPrint("We're going to the exercise");

    checkDeviceCompatibility().then((value) => {
          if (value.success)
            {
              requestARPermissions().then((value) => {
                    if (value.success)
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ArExercisePage()),
                        )
                      }
                    else
                      {
                        debugPrint("AR permissions denied"),
                        debugPrint(value.message)
                      }
                  })
            }
          else
            {debugPrint("Device incompatible"), debugPrint(value.message)}
        });
  }

  Future<WikitudeResponse> checkDeviceCompatibility() async {
    return await WikitudePlugin.isDeviceSupporting(features);
  }

  Future<WikitudeResponse> requestARPermissions() async {
    return await WikitudePlugin.requestARPermissions(features);
  }
}