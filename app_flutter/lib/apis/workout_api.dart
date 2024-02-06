import 'package:http/http.dart' as http;
import 'dart:convert';
import "../models/workout.dart";

class WorkoutApi {
  static String server = '4306-91-181-117-196.ngrok-free.app';

  // muscle groups

  static Future<List<MuscleGroup>> fetchMuscleGroups() async {
    var url = Uri.https(server, '/musclegroups');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((workout) => MuscleGroup.fromJson(workout))
          .toList();
    } else {
      throw Exception('Failed to load muscle groups');
    }
  }

  static Future<MuscleGroup> fetchMuscleGroup(int id) async {
    var url = Uri.https(server, '/musclegroups/$id');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return MuscleGroup.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load muscle group');
    }
  }

  static Future<MuscleGroup> updateMuscleGroup(
      int id, MuscleGroup muscleGroup) async {
    var url = Uri.https(server, '/musclegroups/$id');

    final http.Response response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(muscleGroup),
    );
    if (response.statusCode == 200) {
      return MuscleGroup.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update muscle group');
    }
  }

  static Future<MuscleGroup> createMuscleGroup(MuscleGroup muscleGroup) async {
    var url = Uri.https(server, '/musclegroups');

    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(muscleGroup),
    );
    if (response.statusCode == 201) {
      return MuscleGroup.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create muscle group');
    }
  }

  // exercises

  static Future<List<Exercise>> fetchExercisesForMuscleGroup(
      int muscleGroupId) async {
    var url = Uri.https(
        server, '/exercises', {'musclegroupId': muscleGroupId.toString()});

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((exercise) => Exercise.fromJson(exercise))
          .toList();
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  static Future<Exercise> createExercise(Exercise exercise) async {
    var url = Uri.https(server, '/exercises');

    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(exercise),
    );
    if (response.statusCode == 201) {
      return Exercise.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create exercise');
    }
  }

  static Future<Exercise> fetchExercise(int exerciseId) async {
    var url = Uri.https(server, '/exercises/$exerciseId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Exercise.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load exercise');
    }
  }

  static Future deleteExercise(int id) async {
    var url = Uri.https(server, '/exercises/$id');

    final http.Response response = await http.delete(url);
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete exercises');
    }
  }
}
