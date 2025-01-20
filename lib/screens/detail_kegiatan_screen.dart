import 'package:flutter/material.dart';
import '../models/survey_model.dart';
import 'package:intl/intl.dart';

class DetailKegiatanScreen extends StatelessWidget {
  final Activity activity;

  const DetailKegiatanScreen({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'lib/images/Sicap_biru.png',
              height: 100,
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 20),
            // Gambar dokumentasi
            if (activity.images != null && activity.images!.isNotEmpty)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF396BB5)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: activity.images!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          activity.images![index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            // Diunggah oleh
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF396BB5)),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                'di unggah oleh ${activity.username}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),
            // Judul
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF396BB5)),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                activity.judul,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),
            // Tanggal
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF396BB5)),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                DateFormat('dd / MM / yyyy').format(activity.tanggal),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),
            // Deskripsi
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF396BB5)),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                activity.deskripsi,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),
            // Tempat
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tempat',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF396BB5)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    activity.tempat,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Anggota/Tim
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Anggota / Tim',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF396BB5)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    activity.anggota,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
