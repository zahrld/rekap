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

  Future<int> getJumlahCatatan(int userId) async {
    try {
      final url = '${ApiConfig.getCountUserCatatan}?user_id=$userId';
      print('Fetching jumlah catatan from: $url'); // Debug log
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}'); // Debug log
      print('Response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final jumlah = data['jumlah'] ?? 0;
        print('Jumlah catatan: $jumlah'); // Debug log
        return jumlah;
      }
      return 0;
    } catch (e) {
      print('Error fetching jumlah catatan: $e');
      return 0;
    }
  }

  Future<List<Activity>> getUserCatatan(int userId) async {
    try {
      final url = '${ApiConfig.getUserCatatan}?user_id=$userId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Activity.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching user catatan: $e');
      return [];
    }
  }
}
