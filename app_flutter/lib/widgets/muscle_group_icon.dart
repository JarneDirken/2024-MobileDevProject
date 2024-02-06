import 'package:flutter/material.dart';

class MuscleGroupIconWidget extends StatelessWidget {
  final String muscleGroupName;

  const MuscleGroupIconWidget(
      {Key? key, required this.muscleGroupName}) 
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String initials = '';

    // Split the muscle group name into words
    List<String> words = muscleGroupName.split(' ');

    // Take the first letter of the first word
    if (words.isNotEmpty) {
      initials += words[0][0].toUpperCase();

      // Take the first letter of the second word if it exists
      if (words.length > 1) {
        initials += words[1][0].toUpperCase();
      }
    }

    return CircleAvatar(
      backgroundColor: const Color(0xffF5F8FE), // You can set your desired background color
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 20.0,
          color: Color(0xff677AA9),
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}