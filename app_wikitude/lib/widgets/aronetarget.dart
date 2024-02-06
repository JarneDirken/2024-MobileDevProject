// ignore_for_file: use_build_context_synchronously

import 'package:app_wikitude/models/workout.dart';
import 'package:app_wikitude/pages/exercisedetail.dart';
import 'package:augmented_reality_plugin_wikitude/architect_widget.dart';
import 'package:augmented_reality_plugin_wikitude/startupConfiguration.dart';
import 'package:flutter/material.dart';

import '../apis/workout_api.dart';
import '../models/arimageresponse.dart';

class ArOneTargetWidget extends StatefulWidget {
  const ArOneTargetWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _ArOneTargetWidgetState();
}

class _ArOneTargetWidgetState extends State<ArOneTargetWidget>
    with WidgetsBindingObserver {
  late ArchitectWidget architectWidget;
  String wikitudeTrialLicenseKey =
      "05m3ik7jy8Ip/hoRgpAs/yTab8PPOrPA5h2GddiYoP2D/QD/kfhiRjkW/1UaotVAZ3+db3aJ+Q0bc/6yXOkZWMVQq+ckAIJFqFuKP/Ts/N/WoeOaH01KlMaFh9DnmI0Ls41Tu6DhSMZlzpfza2HZFua2PMaKL3aD0TgLI7SKHJ5TYWx0ZWRfXxSB7Rx+OccwOz2vIlkWx7oqDxXE9CGpYAm47mRD6Gpn1AeWrVGEjauQwfzSxmRrjPi1GixSV8kgZ+5Dg68rGj+W+NATxa+1eptmXr208w4ZsrzojlnyFuNqstS6xzlR88dWKdGZH7kKP2+lQjlinm9YZixeIWr8EvytGBNFR+/kK0bNfc69vALLRUN2R2sv1MUDZPRSrAKPGzQc+IpkFF8f7gjs5QQy4tsrbWX5RJMlSpV7xOYLY0JjhKCILyGelhZl8vcGGVgIqvErQfTQiNPtUPljB2n4j+le3k8r5vR52HEEr427ihVKvj+dYC0WI4j8vrCtXGjIIGAda8b8cEvrhqDuncoL7OEOgLKFJxEg2ERqBE+NkXBjbGySGdrLe9PFSqODU43NSNQdcsPZ+kkhkvOtllmunWQM6X3QRzpjgDwQaeJD9i/Iqroq/Q6Ju/b41Qi3WXpZAaNY/DWBXj1yV4YYCymiSgnj0dCz9e9ar1T1NBNbjQOXTKMMeCj1Er196ClShKp9HVH6RubBftYVhDOIGsW2iP0rhaNDhqj591MN0zZ+rGAW2UIMZCf1ovELGshDCKjObSqh/Usp9dZFmRXR2hK2X7ntRlOe+83Zrkyqp3CTCscsHNbnL/TTrM0xPlzjP9HIsnj/Oc+goYfEFfJ5/hUYgA==";
  StartupConfiguration startupConfiguration = StartupConfiguration(
      cameraPosition: CameraPosition.BACK,
      cameraResolution: CameraResolution.AUTO);
  List<String> features = ["image_tracking"];

  void onJSONObjectReceived(Map<String, dynamic> jsonObject) async {
    var imageScanned = ARImageResponse.fromJson(jsonObject);
    var existingExercise = await WorkoutApi.fetchExercise(imageScanned.id);
    var currentContext = context;

    if (existingExercise != null) {
      // Exercise exists, navigate to the exercise detail page
      Navigator.push(
        currentContext,
        MaterialPageRoute(
          builder: (context) => ExerciseDetailPage(
            exerciseId: existingExercise.id,
            musclegroupId: existingExercise.musclegroupId,
            url: existingExercise.url,
            )));
    } else {
      // Exercise does not exist, post it to the API
      var newExercise = Exercise(
        id: imageScanned.id,
        musclegroupId: imageScanned.musclegroupId,
        name: imageScanned.name,
        description: imageScanned.description,
        focus: imageScanned.focus,
        image: imageScanned.image,
        url: imageScanned.url,
      );

      var postedExercise = await WorkoutApi.createExercise(newExercise);
      
      if (postedExercise != null) {
        // Successfully posted, navigate to the exercise detail page
        Navigator.push(
          currentContext,
          MaterialPageRoute(
            builder: (context) => ExerciseDetailPage(
              exerciseId: postedExercise.id,
              musclegroupId: postedExercise.musclegroupId,
              url: postedExercise.url,
            ),
          ),
        );
      } else {
        debugPrint("Failed creating the exercise");
      }
    }
  }
  
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    architectWidget = ArchitectWidget(
      onArchitectWidgetCreated: onArchitectWidgetCreated,
      licenseKey: wikitudeTrialLicenseKey,
      startupConfiguration: startupConfiguration,
      features: features,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.black),
      child: architectWidget, //ar widget
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        architectWidget.pause();
        break;
      case AppLifecycleState.resumed:
        architectWidget.resume();
        break;

      default:
    }
  }

  @override
  void dispose() {
    architectWidget.pause();
    architectWidget.destroy();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> onArchitectWidgetCreated() async {
    architectWidget.load(
        "samples/01_ImageTracking_1_RedirectToPage/index.html",
        onLoadSuccess,
        onLoadFailed);
    architectWidget.resume();
    architectWidget.setJSONObjectReceivedCallback(
      (result) => onJSONObjectReceived(result));
  }
  

  Future<void> onLoadSuccess() async {
    debugPrint("Successfully loaded Architect World");
  }

  Future<void> onLoadFailed(String error) async {
    debugPrint("Failed to load Architect World");
    debugPrint(error);
  }
}