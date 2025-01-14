import 'package:flutter/material.dart';
import '../models/survey_model.dart';

class DetailKegiatanScreen extends StatelessWidget {
  final Activity activity;

  const DetailKegiatanScreen({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(activity.judul),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tanggal: ${activity.tanggal.toString().split(' ')[0]}'),
            const SizedBox(height: 8),
            Text('Tempat: ${activity.tempat}'),
            const SizedBox(height: 8),
            Text('Deskripsi: ${activity.deskripsi}'),
            const SizedBox(height: 8),
            Text('Anggota: ${activity.anggota}'),
            // Tambahkan detail lain yang diperlukan
          ],
        ),
      ),
    );
  }
} 