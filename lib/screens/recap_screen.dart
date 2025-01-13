import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

class RecapScreen extends StatefulWidget {
  final int userId;

  const RecapScreen({
    super.key,
    required this.userId,
  });

  @override
  State<RecapScreen> createState() => _RecapScreenState();
}

class _RecapScreenState extends State<RecapScreen> {
  List<Activity> activities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchActivities();
  }

  Future<void> fetchActivities() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.get(
        Uri.parse(
            '${ApiConfig.baseUrl}/read_catatan.php?user_id=${widget.userId.toString()}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw Exception('Response kosong dari server');
        }

        final data = jsonDecode(response.body);
        print('Decoded data: $data');

        if (data['success'] == true && data['data'] != null) {
          setState(() {
            activities = (data['data'] as List)
                .map((item) => Activity.fromJson(item))
                .toList();
            isLoading = false;
          });
        } else {
          setState(() {
            activities = [];
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load activities: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching activities: $e');
      setState(() {
        activities = [];
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekap Catatan'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : activities.isEmpty
              ? const Center(child: Text('Belum ada catatan'))
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    final activity = activities[index];
                    return Card(
                      child: ListTile(
                        leading: activity.gambar.isNotEmpty
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(
                                  '${ApiConfig.baseUrl}/${activity.gambar[0]}',
                                ),
                              )
                            : const CircleAvatar(
                                child: Icon(Icons.location_on),
                              ),
                        title: Text(activity.judul),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(activity.tempat),
                            Text(activity.tanggal.toString().split(' ')[0]),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // Implementasi edit catatan
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                // Implementasi hapus catatan
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          // Tampilkan detail catatan
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

class Activity {
  final int id;
  final int userId;
  final String judul;
  final DateTime tanggal;
  final String tempat;
  final String deskripsi;
  final String anggota;
  final List<String> gambar;

  Activity({
    required this.id,
    required this.userId,
    required this.judul,
    required this.tanggal,
    required this.tempat,
    required this.deskripsi,
    required this.anggota,
    required this.gambar,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    try {
      return Activity(
        id: int.parse(json['id']?.toString() ?? '0'),
        userId: int.parse(json['user_id']?.toString() ?? '0'),
        judul: json['judul']?.toString() ?? '',
        tanggal: DateTime.tryParse(json['tanggal']?.toString() ?? '') ??
            DateTime.now(),
        tempat: json['tempat']?.toString() ?? '',
        deskripsi: json['deskripsi']?.toString() ?? '',
        anggota: json['anggota']?.toString() ?? '',
        gambar:
            (json['gambar'] as List?)?.map((e) => e.toString()).toList() ?? [],
      );
    } catch (e) {
      print('Error parsing Activity: $e');
      print('JSON data: $json');
      rethrow;
    }
  }
}
