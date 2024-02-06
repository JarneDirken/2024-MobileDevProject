import 'package:app_wikitude/pages/arexercise.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../apis/workout_api.dart';
import '../models/workout.dart';

class ExerciseDetailPage extends StatefulWidget {
  final int exerciseId;
  final int musclegroupId;
  final String url;

  const ExerciseDetailPage({
    super.key,
    required this.exerciseId,
    required this.musclegroupId,
    required this.url,
  });

  @override
  State<StatefulWidget> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  static const Color textColor = Color(0xFF020A22);
  static const Color backgroundColor = Color(0xFFECF0FE);
  static const Color buttonColor = Color(0xFF698CD3);
  static const Color bgColor = Color(0xFFCEDBFD);

  Exercise? exercise;
  Map<int, String> muscleGroupNames = {};
  String muscleGroupName = "";
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _fetchMuscleGroups();
    _getExercise(widget.exerciseId);
  }

  Future<void> _fetchMuscleGroups() async {
    try {
      List<MuscleGroup> muscleGroups = await WorkoutApi.fetchMuscleGroups();

      // Find the muscle group with the matching ID
      for (var group in muscleGroups) {
        if (group.id == widget.musclegroupId) {
          setState(() {
            muscleGroupName = group.name;
          });
          break;
        }
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

  void _getExercise(int id) {
    WorkoutApi.fetchExercise(id).then((result) {
      // call the api to fetch the user data
      setState(() {
        exercise = result;
      });
    });
    _initializePlayer();
  }

  void _initializePlayer() {
    if (widget.url.isNotEmpty) {
      final videoId = YoutubePlayer.convertUrlToId(widget.url);
      _controller = YoutubePlayerController(
        initialVideoId: videoId!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          showLiveFullscreenButton: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (exercise == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(45.0),
          child: Stack(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ArExercisePage(),
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
                        const Spacer(),
                        Text(
                          exercise!.name,
                          style: const TextStyle(
                              fontSize: 16,
                              color: textColor,
                              fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            _showDeleteConfirmationDialog();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            minimumSize: const Size(40, 45),
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Image.asset(
                      'assets/images/${exercise!.image}',
                      width: 230,
                      height: 230,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Description",
                  style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(exercise!.description),
                const SizedBox(height: 10),
                const Text(
                  "Muscle group",
                  style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 38, vertical: 6),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    muscleGroupName.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: buttonColor),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Tutorial",
                  style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                if (widget.url.isNotEmpty)
                  YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    bottomActions: [
                      CurrentPosition(),
                      ProgressBar(
                        isExpanded: true,
                        colors: const ProgressBarColors(
                          playedColor: buttonColor,
                          handleColor: buttonColor,
                        ),
                      ),
                      FullScreenButton()
                    ],
                  )
                else
                  const Text("No video"),
              ],
            )
          ]),
        ),
      );
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: Text("Are you sure you want to delete ${exercise!.name}"),
          actions: <Widget>[
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                _deleteExercise();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteExercise() {
    WorkoutApi.deleteExercise(widget.exerciseId).then((result) {
      Navigator.pop(context, true);
    });
  }
}
