import 'package:app_flutter/apis/workout_api.dart';
import 'package:app_flutter/models/workout.dart';
import 'package:app_flutter/pages/workout_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WorkoutEditPage extends StatefulWidget {
  final int id;
  final bool isEditing;
  const WorkoutEditPage({Key? key, required this.id, required this.isEditing})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _WorkoutEditPageState();
}

class _WorkoutEditPageState extends State<WorkoutEditPage> {
  static const Color textColor = Color(0xFF020A22);
  static const Color backgroundColor = Color(0xFFECF0FE);
  static const Color buttonColor = Color(0xFF698CD3);

  TextEditingController muscleGroupName = TextEditingController();
  MuscleGroup? muscleGroup;

  @override
  void initState() {
    super.initState();
    if (widget.id == 0) {
      muscleGroup = MuscleGroup(
          id: 0, name: "", icon: "", image: "musclegroup_image_default.svg");
    } else {
      _getMuscleGroup(widget.id);
    }
  }

  void _getMuscleGroup(int id) {
    WorkoutApi.fetchMuscleGroup(id).then((result) {
      setState(() {
        muscleGroup = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(45.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                // Add your navigation logic here
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const WorkoutPage(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: buttonColor,
                  size: 38,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/globals/image_add_musclegroup.svg',
                width: 250,
                height: 250,
              ),
            ),
            const SizedBox(height: 10),
            if (widget.isEditing)
              const Text(
                'Update a',
                style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: textColor),
              ),
            if (!widget.isEditing)
              const Text(
                'Create a new',
                style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: textColor),
              ),
            const Text(
              'muscle group',
              style: TextStyle(
                  fontSize: 42, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 40),
            const Text(
              "Name",
              style: TextStyle(fontSize: 18, color: textColor),
            ),
            const SizedBox(height: 2),
            Container(
              width: 300,
              padding: const EdgeInsets.only(
                  left: 10.0, top: 2.0, right: 10.0, bottom: 2.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: muscleGroupName,
                decoration: InputDecoration(
                  hintText: widget.isEditing
                      ? (muscleGroup?.name.isEmpty ?? true
                          ? "wait"
                          : muscleGroup!.name)
                      : 'Enter your new workout name',
                  hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.6),
                      fontSize: 14,
                      fontWeight: FontWeight.w300),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 70),
            ElevatedButton(
              onPressed: () {
                _saveMuscleGroup();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                minimumSize: const Size(290, 45),
              ),
              child: widget.isEditing
                  ? const Text(
                      'Update',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Add',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveMuscleGroup() {
    muscleGroup!.name = muscleGroupName.text;

    if (muscleGroup!.id == 0) {
      WorkoutApi.createMuscleGroup(muscleGroup!).then((result) {
        Navigator.pop(context, true);
      });
    } else {
      WorkoutApi.updateMuscleGroup(widget.id, muscleGroup!).then((result) {
        Navigator.pop(context, true);
      });
    }
  }
}
