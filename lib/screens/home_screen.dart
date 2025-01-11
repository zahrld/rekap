import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'add_note_screen.dart';
import 'recap_screen.dart';
import '../models/user_model.dart';

class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survei Lokasi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(user: user),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.add_location, size: 32),
                title: const Text('Tambah Catatan'),
                subtitle: const Text('Tambah catatan survei lokasi baru'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddNoteScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.list_alt, size: 32),
                title: const Text('Rekap Catatan'),
                subtitle: const Text('Lihat semua catatan survei'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RecapScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
