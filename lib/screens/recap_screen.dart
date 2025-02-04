import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:rekap_kominfo/models/user_model.dart';
import '../config/api_config.dart';
import 'detail_kegiatan_screen.dart';
import '../models/survey_model.dart';

class RecapScreen extends StatefulWidget {
  final int userId;
  final User user;

  const RecapScreen({
    super.key,
    required this.userId,
    required this.user, required String namaUser,
  });

  @override
  State<RecapScreen> createState() => _RecapScreenState();
}

class _RecapScreenState extends State<RecapScreen> {
  late Future<List<Activity>> futureActivities;
  List<Activity> _activities = [];
  List<Activity> _filteredActivities = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchActivities(widget.userId);
  }

  Future<void> fetchActivities(int userId) async {
    try {
      final response =
          await http.get(Uri.parse('${ApiConfig.getCatatan}?user_id=$userId'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          List<dynamic> data = jsonResponse['data'];
          List<Activity> activities =
              data.map((json) => Activity.fromJson(json)).toList();
          setState(() {
            _activities = activities;
            _filteredActivities = activities;
          });
        } else {
          throw Exception('Gagal mengambil data: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Gagal mengambil data, status: ${response.statusCode}');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $error')),
      );
    }
  }

  void _filterActivities(String query) {
    final filtered = _activities.where((activity) {
      final titleLower = activity.judul.toLowerCase();
      final dateFormatted = DateFormat('EEEE, d MMMM yyyy', 'id_ID')
          .format(activity.tanggal)
          .toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower) ||
          dateFormatted.contains(searchLower);
    }).toList();

    setState(() {
      _filteredActivities = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rekap Kegiatan')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Cari catatan',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterActivities,
            ),
          ),
          Expanded(
            child: _activities.isEmpty
                ? const Center(child: Text('Belum ada catatan'))
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: _filteredActivities.length,
                    itemBuilder: (context, index) {
                      final activity = _filteredActivities[index];
                      final formattedDate =
                          DateFormat('EEEE, d MMMM yyyy', 'id_ID')
                              .format(activity.tanggal);

                      return Card(
                        child: ListTile(
                          title: Text(
                            activity.judul,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(formattedDate),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailKegiatanScreen(
                                  activity: activity,
                                  user: widget.user,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
