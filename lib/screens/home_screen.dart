import 'package:flutter/material.dart';
import '../config/api_config.dart';
import 'profile_screen.dart';
import 'add_note_screen.dart';
import 'recap_screen.dart';
import '../models/user_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'catatan_survei.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isProfileHovered = false;
  bool isCatatanHovered = false;
  bool isRekapHovered = false;
  bool isKalenderHovered = false;
  int noteCount = 0;

  Future<void> _fetchNoteCount() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.getCountUserCatatan}?user_id=${widget.user.id}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Data received: $data'); // Debugging log
        setState(() {
          noteCount = data['total'];
        });
      } else {
        throw Exception('Failed to load note count');
      }
    } catch (e) {
      print('Error fetching note count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Bagian atas berwarna biru
          Container(
            color: Colors.blue,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    // Logo SICAP
                    Image.asset(
                      'lib/images/sicap_putih.png',
                      height: 40, // Sesuaikan ukuran sesuai kebutuhan
                    ),
                    const SizedBox(width: 10),

                    // Hi Username
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.blue[300]!),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Hi ${widget.user.nama}',
                              style: GoogleFonts.poppins(
                                  fontSize: 20, color: Colors.blue[300]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTapDown: (_) => setState(() => isProfileHovered = true),
                      onTapUp: (_) => setState(() => isProfileHovered = false),
                      onTapCancel: () =>
                          setState(() => isProfileHovered = false),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(user: widget.user),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isProfileHovered ? Colors.white : Colors.white,
                          border: Border.all(color: Colors.blue[300]!),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: isProfileHovered
                              ? [
                                  BoxShadow(
                                      color: Colors.blue[100]!, blurRadius: 8)
                                ]
                              : null,
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 25,
                          child: Icon(
                            Icons.person,
                            color: isProfileHovered
                                ? Colors.blue[700]
                                : Colors.blue[300],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Konten utama dengan latar belakang putih
          Expanded(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Card untuk jumlah catatan dan menu buttons
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CatatanSurvei(
                              username: widget.user.nama,
                              userId: int.parse(widget.user.id),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            // Card untuk jumlah catatan
                            Container(
                              width: double.infinity, // Memastikan lebar penuh
                              padding: const EdgeInsets.symmetric(vertical: 25),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.blue[300]!),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "$noteCount",
                                    style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    "Catatan Kegiatan Survei",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Menu buttons dengan ukuran yang sama
                    GestureDetector(
                      onTapDown: (_) =>
                          setState(() => isCatatanHovered = true),
                      onTapUp: (_) =>
                          setState(() => isCatatanHovered = false),
                      onTapCancel: () =>
                          setState(() => isCatatanHovered = false),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddNoteScreen(
                              username: widget.user.nama,
                              userId: int.parse(widget.user.id),
                            ),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        decoration: BoxDecoration(
                          color: isCatatanHovered
                              ? Colors.white
                              : Colors.blue[700],
                          border: Border.all(
                            color: isCatatanHovered
                                ? Colors.blue[700]!
                                : Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: isCatatanHovered
                                  ? Colors.blue[700]
                                  : Colors.white,
                              size: 30,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Catatan Baru',
                              style: TextStyle(
                                color: isCatatanHovered
                                    ? Colors.blue[700]
                                    : Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    GestureDetector(
                      onTapDown: (_) =>
                          setState(() => isRekapHovered = true),
                      onTapUp: (_) =>
                          setState(() => isRekapHovered = false),
                      onTapCancel: () =>
                          setState(() => isRekapHovered = false),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecapScreen(
                                userId: int.parse(widget.user.id)),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        decoration: BoxDecoration(
                          color: isRekapHovered
                              ? Colors.white
                              : Colors.blue[700],
                          border: Border.all(
                            color: isRekapHovered
                                ? Colors.blue[700]!
                                : Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.refresh,
                              color: isRekapHovered
                                  ? Colors.blue[700]
                                  : Colors.white,
                              size: 30,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Rekap',
                              style: TextStyle(
                                color: isRekapHovered
                                    ? Colors.blue[700]
                                    : Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    GestureDetector(
                      onTapDown: (_) =>
                          setState(() => isKalenderHovered = true),
                      onTapUp: (_) =>
                          setState(() => isKalenderHovered = false),
                      onTapCancel: () =>
                          setState(() => isKalenderHovered = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        decoration: BoxDecoration(
                          color: isKalenderHovered
                              ? Colors.white
                              : Colors.blue[700],
                          border: Border.all(
                            color: isKalenderHovered
                                ? Colors.blue[700]!
                                : Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: isKalenderHovered
                                  ? Colors.blue[700]
                                  : Colors.white,
                              size: 30,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Kalender',
                              style: TextStyle(
                                color: isKalenderHovered
                                    ? Colors.blue[700]
                                    : Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
