import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../config/api_config.dart';
import '../models/survey_model.dart';
import 'detail_kegiatan_screen.dart';

class CatatanSurvei extends StatefulWidget {
  final String username;
  final int userId;

  const CatatanSurvei({
    super.key,
    required this.username,
    required this.userId,
  });

  @override
  State<CatatanSurvei> createState() => _CatatanSurveiState();
}

class _CatatanSurveiState extends State<CatatanSurvei> {
  late Future<List<Activity>> futureActivities;
  List<Activity> _activities = [];
  List<Activity> _filteredActivities = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureActivities = fetchUserNotes(widget.userId);
    futureActivities.then((activities) {
      setState(() {
        _activities = activities;
        _filteredActivities = activities;
      });
    });
  }

  Future<List<Activity>> fetchUserNotes(int userId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.getUserCatatan}?user_id=$userId'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Activity.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load activities');
    }
  }

  void _filterActivities(String query) {
    final filtered = _activities.where((activity) {
      final titleLower = activity.judul.toLowerCase();
      final dateFormatted = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(activity.tanggal).toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower) || dateFormatted.contains(searchLower);
    }).toList();

    setState(() {
      _filteredActivities = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Survei Saya'),
      ),
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
            child: FutureBuilder<List<Activity>>(
              future: futureActivities,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Belum ada catatan'));
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: _filteredActivities.length,
                    itemBuilder: (context, index) {
                      final activity = _filteredActivities[index];
                      final formattedDate = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(activity.tanggal);
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
                                builder: (context) => DetailKegiatanScreen(activity: activity),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
