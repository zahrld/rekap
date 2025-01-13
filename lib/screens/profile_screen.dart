import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late TextEditingController _noTeleponController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.user.nama);
    _emailController = TextEditingController(text: widget.user.email);
    _noTeleponController = TextEditingController(text: widget.user.noTelepon);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                labelText: 'Nama Lengkap',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              readOnly: true, // Buat readonly karena ini hanya tampilan
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.email),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noTeleponController,
              decoration: InputDecoration(
                labelText: 'Nomor Telepon',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.phone),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              readOnly: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  // Tampilkan dialog konfirmasi
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Konfirmasi Logout'),
                      content: const Text('Apakah Anda yakin ingin keluar?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text('Ya, Keluar'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    // Di sini bisa ditambahkan proses logout ke API jika diperlukan

                    if (mounted) {
                      // Kembali ke halaman login dan hapus semua halaman sebelumnya
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login',
                        (route) => false,
                      );
                    }
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12.0),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _noTeleponController.dispose();
    super.dispose();
  }
}
