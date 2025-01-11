import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/survey_model.dart';

class SurveyService {
  Future<bool> createSurvey(Survey survey) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.createSurvey),
        body: survey.toJson(),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result['success'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<List<Survey>> getSurveys() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.getSurveys));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Survey.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
