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
    Key? key,
    required this.username,
    required this.userId,
  }) : super(key: key);

  @override
  State<CatatanSurvei> createState() => _CatatanSurveiState();
}

class _CatatanSurveiState extends State<CatatanSurvei> {
  List<Activity> _activities = [];
  List<Activity> _filteredActivities = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserNotes();
  }

  Future<void> _loadUserNotes() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.getCatatan}?user_id=${widget.userId}'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _activities = data.map((json) => Activity.fromJson(json)).toList();
          _filteredActivities = _activities;
          _isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat data');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _activities.isEmpty
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
                                        activity: activity),
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
