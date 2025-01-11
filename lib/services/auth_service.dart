import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('Sending login data:');
      print({
        'email': email,
        'password': password,
      });

      final response = await http.post(
        Uri.parse(ApiConfig.login),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'email': email,
          'password': password,
        },
      );

      print('Login response:');
      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        print('Decoded response: $decodedResponse');
        return decodedResponse;
      }
      return {'success': false, 'message': 'Login failed: ${response.body}'};
    } catch (e) {
      print('Login error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> register({
    required String nama,
    required String email,
    required String noTelepon,
    required String password,
  }) async {
    try {
      print('Sending register data:');
      print({
        'nama': nama,
        'email': email,
        'no_telepon': noTelepon,
        'password': password,
      });

      final response = await http.post(
        Uri.parse(ApiConfig.register),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'nama': nama,
          'email': email,
          'no_telepon': noTelepon,
          'password': password,
        },
      );

      print('Register response:');
      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        print('Decoded response: $decodedResponse');
        return decodedResponse;
      }
      return {'success': false, 'message': 'Register failed: ${response.body}'};
    } catch (e) {
      print('Register error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }
}
