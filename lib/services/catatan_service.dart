import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/catatan_model.dart';

class CatatanService {
  Future<bool> createCatatan(Catatan catatan) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.createCatatan),
        body: catatan.toJson(),
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

  Future<List<Catatan>> getCatatanByUserId(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.getCatatan}?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Catatan.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
