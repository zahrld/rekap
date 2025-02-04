import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'add_note_screen.dart';
import 'recap_screen.dart';
import '../models/user_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'catatan_survei.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'calendar_screen.dart';

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
  int jumlahCatatan = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header berwarna biru
          Container(
            color: Colors.blue[700],
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Baris pertama: Logo dan Profile
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Logo SICAP
                        Image.asset(
                          'lib/images/Sicap_putih.png',
                          height: 70,
                        ),

                        // Icon Profile
                        GestureDetector(
                          onTapDown: (_) =>
                              setState(() => isProfileHovered = true),
                          onTapUp: (_) =>
                              setState(() => isProfileHovered = false),
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
                              color: isProfileHovered
                                  ? Colors.white
                                  : Colors.white,
                              border: Border.all(color: Colors.blue[300]!),
                              borderRadius: BorderRadius.circular(
                                  35), // Memperbesar border radius
                              boxShadow: isProfileHovered
                                  ? [
                                      BoxShadow(
                                          color: Colors.blue[100]!,
                                          blurRadius: 8)
                                    ]
                                  : null,
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 30, // Memperbesar radius
                              child: Icon(
                                Icons.person,
                                color: isProfileHovered
                                    ? Colors.blue[700]
                                    : Colors.blue[700],
                                size: 30, // Memperbesar ukuran icon
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Baris kedua: Hi Username
                    const SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Hi ${widget.user.nama}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
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
                    // Card untuk Catatan Saya
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CatatanSurvei(
                              username: widget.user.nama,
                              userId: int.parse(widget.user.id),
                              user: widget.user,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
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
                            Icon(
                              Icons.book,
                              color: Colors.blue[700],
                              size: 40, // Memperbesar icon
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Catatan Saya",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Tombol Catatan Baru
                    GestureDetector(
                      onTapDown: (_) => setState(() => isCatatanHovered = true),
                      onTapUp: (_) => setState(() => isCatatanHovered = false),
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
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        decoration: BoxDecoration(
                          color: Colors.blue[700],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 40, // Memperbesar icon
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Catatan Baru',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Tombol Rekap
                    GestureDetector(
                      onTapDown: (_) => setState(() => isRekapHovered = true),
                      onTapUp: (_) => setState(() => isRekapHovered = false),
                      onTapCancel: () => setState(() => isRekapHovered = false),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecapScreen(
                              userId: int.parse(widget.user.id),
                              user: widget.user,
                              namaUser: widget.user.nama,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        decoration: BoxDecoration(
                          color: Colors.blue[700],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.refresh,
                              color: Colors.white,
                              size: 40, // Memperbesar icon
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Rekap',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Tombol Kalender
                    GestureDetector(
                      onTapDown: (_) =>
                          setState(() => isKalenderHovered = true),
                      onTapUp: (_) => setState(() => isKalenderHovered = false),
                      onTapCancel: () =>
                          setState(() => isKalenderHovered = false),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CalendarScreen(
                              user: widget.user,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        decoration: BoxDecoration(
                          color: Colors.blue[700],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                              size: 40, // Memperbesar icon
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Kalender',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
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
