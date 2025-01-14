import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/survey_model.dart';

class SurveyService {
  Future<bool> createSurvey(Activity survey) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.createSurvey),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(survey.toJson()),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result['success'] == true;
      }
      return false;
    } catch (e) {
      print('Error creating survey: $e');
      return false;
    }
  }

  Future<List<Activity>> getSurveys() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.getSurveys));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Activity.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching surveys: $e');
      return [];
    }
  }
}
