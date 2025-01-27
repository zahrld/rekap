import 'package:flutter/material.dart';
import '../models/survey_model.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';

class DetailKegiatanScreen extends StatelessWidget {
  final Activity activity;
  final User user;

  const DetailKegiatanScreen(
      {super.key, required this.activity, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Kegiatan',
          style: TextStyle(color: Color(0xFF396BB5)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF396BB5)),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan logo
            Center(
              child: Image.asset(
              'lib/images/Sicap_biru.png',
                height: 80,
              ),
            ),
            const SizedBox(height: 24),

            // Judul Kegiatan
            const Text(
              'Judul Kegiatan:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF396BB5),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF396BB5)),
              ),
              child: Text(
                activity.judul,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),

            // Dokumentasi Foto
            if (activity.images != null && activity.images!.isNotEmpty) ...[
              const Text(
                'Dokumentasi:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF396BB5),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF396BB5)),
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
                          width: 250,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 250,
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(Icons.error),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Informasi Waktu dan Tempat
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tanggal:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF396BB5),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF396BB5)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Color(0xFF396BB5),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('dd MMMM yyyy')
                                  .format(activity.tanggal),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Lokasi:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF396BB5),
                        ),
                      ),
                      const SizedBox(height: 8),
            Container(
                        padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF396BB5)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Color(0xFF396BB5),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
              child: Text(
                                activity.tempat,
                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Deskripsi
            const Text(
              'Deskripsi Kegiatan:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF396BB5),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF396BB5)),
              ),
              child: Text(
                activity.deskripsi,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ),
            const SizedBox(height: 20),

            // Tim/Anggota
            const Text(
              'Tim/Anggota:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF396BB5),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF396BB5)),
              ),
              child: Text(
                activity.anggota,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),


            // Info pembuat catatan
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Dibuat oleh ${user.nama}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                  ),
                ),
              ],
            ),
            ),
          ],
        ),
      ),
    );
  }
}
