import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../models/catatan_model.dart';
import '../services/catatan_service.dart';

class CatatanScreen extends StatefulWidget {
  final int userId;
  final String username;

  const CatatanScreen(
      {super.key, required this.userId, required this.username});

  @override
  State<CatatanScreen> createState() => _CatatanScreenState();
}

class _CatatanScreenState extends State<CatatanScreen> {
  final CatatanService _catatanService = CatatanService();
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _tempatController = TextEditingController();
  final List<String> _anggotaList = [];
  final _anggotaController = TextEditingController();
  DateTime? _selectedDate;
  File? _imageFile;
  List<Catatan> _catatanList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCatatan();
  }

  Future<void> _loadCatatan() async {
    setState(() => _isLoading = true);
    try {
      final catatan = await _catatanService.getCatatanByUserId(widget.userId);
      setState(() => _catatanList = catatan);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitCatatan() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final catatan = Catatan(
          userId: widget.userId,
          judul: _judulController.text,
          deskripsi: _deskripsiController.text,
          tempat: _tempatController.text,
          tanggal: _selectedDate != null
              ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
              : DateFormat('yyyy-MM-dd').format(DateTime.now()),
          anggota: _anggotaList.join(', '),
          gambar: _imageFile?.path,
          penulis: widget.username,
        );

        final success = await _catatanService.createCatatan(catatan);
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Catatan berhasil disimpan')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _judulController,
                    decoration: const InputDecoration(labelText: 'Judul'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Judul tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _deskripsiController,
                    decoration: const InputDecoration(labelText: 'Deskripsi'),
                    maxLines: 3,
                  ),
                  TextFormField(
                    controller: _tempatController,
                    decoration: const InputDecoration(labelText: 'Tempat'),
                  ),
                  TextFormField(
                    controller: _anggotaController,
                    decoration: const InputDecoration(labelText: 'Anggota'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submitCatatan,
                    child: const Text('Simpan Catatan'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _catatanList.length,
                      itemBuilder: (context, index) {
                        final catatan = _catatanList[index];
                        return Card(
                          child: ListTile(
                            title: Text(catatan.judul),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.person,
                                        size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Dibuat oleh ${catatan.penulis}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF396BB5),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Tanggal: ${catatan.tanggal}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                if (catatan.deskripsi != null)
                                  Text(catatan.deskripsi!),
                                if (catatan.tempat != null)
                                  Text('Tempat: ${catatan.tempat}'),
                                if (catatan.anggota != null)
                                  Text('Anggota: ${catatan.anggota}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    _tempatController.dispose();
    _anggotaController.dispose();
    super.dispose();
  }
}
