import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dokumentasi.dart';

class DokumentasiService {
  static const String baseUrl = 'http://your-api-base-url'; // Ganti dengan URL API Anda

  Future<List<Dokumentasi>> getDokumentasiList() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/dokumentasi'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body)['data'];
        return jsonData.map((item) => Dokumentasi.fromJson(item)).toList();
      } else {
        throw Exception('Gagal mengambil data dokumentasi');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
} 