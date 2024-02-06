import 'package:app_flutter/pages/exercise_page.dart';
import 'package:app_flutter/pages/workout_edit_page.dart';
import 'package:app_flutter/widgets/muscle_group_icon.dart';
import 'package:flutter/material.dart';
import 'package:app_flutter/models/workout.dart';

class MuscleGroupListWidget extends StatefulWidget {
  final List<MuscleGroup> muscleGroupList;
  final bool isEditing;
  final Function refreshMuscleGroups;

  const MuscleGroupListWidget({
    super.key,
    required this.muscleGroupList,
    required this.isEditing,
    required this.refreshMuscleGroups,
  });

  @override
  State<StatefulWidget> createState() => _MuscleGroupListWidgetState();
}

class _MuscleGroupListWidgetState extends State<MuscleGroupListWidget> {
  static const Color textColor = Color(0xFF020A22);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext builderContext) {
        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children:
              _buildMuscleGroupItems(builderContext, widget.muscleGroupList),
        );
      },
    );
  }

  List<Row> _buildMuscleGroupItems(
      BuildContext context, List<MuscleGroup> muscleGroupList) {
    List<Row> rows = [];

    _navigateToDetail(int id) async {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ExercisePage(
                  muscleGroup: id,
                )),
      );
    }

    _navigateToEditor(int id) async {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkoutEditPage(
                  id: id,
                  isEditing: widget.isEditing,
                )),
      );
      widget.refreshMuscleGroups();
    }

    for (int i = 0; i < muscleGroupList.length; i += 2) {
      List<Widget> containers = [];

      if (i < muscleGroupList.length) {
        final muscleGroup = muscleGroupList[i];
        final isEditable = widget.isEditing;

        containers.add(
          GestureDetector(
            onTap: isEditable
                ? () {
                    _navigateToEditor(muscleGroup.id);
                  }
                : () {
                    _navigateToDetail(muscleGroup.id);
                  },
            child: Container(
              width: 125,
              height: 120,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  muscleGroup.icon!.isEmpty
                      ? SizedBox(
                          width: 55,
                          height: 55,
                          child: MuscleGroupIconWidget(
                            muscleGroupName: muscleGroup.name,
                          ),
                        )
                      : Image.asset(
                          'assets/icons/${muscleGroup.icon}',
                          width: 55,
                          height: 55,
                        ),
                  Text(
                    muscleGroup.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _MuscleGroupListWidgetState.textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      if (i + 1 < muscleGroupList.length) {
        final muscleGroup = muscleGroupList[i + 1];
        final isEditable = widget.isEditing;

        containers.add(
          GestureDetector(
            onTap: isEditable
                ? () {
                    _navigateToEditor(muscleGroup.id);
                  }
                : () {
                    _navigateToDetail(muscleGroup.id);
                  },
            child: Container(
              width: 125,
              height: 120,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  muscleGroup.icon!.isEmpty
                      ? SizedBox(
                          width: 55,
                          height: 55,
                          child: MuscleGroupIconWidget(
                            muscleGroupName: muscleGroup.name,
                          ),
                        )
                      : Image.asset(
                          'assets/icons/${muscleGroup.icon}',
                          width: 55,
                          height: 55,
                        ),
                  Text(
                    muscleGroup.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _MuscleGroupListWidgetState.textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: containers,
        ),
      );
    }

    return rows;
  }
}
