import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../config/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import '../models/catatan_model.dart';

class AddNoteScreen extends StatefulWidget {
  final String username;
  final int userId;

  const AddNoteScreen({
    super.key,
    required this.username,
    required this.userId,
  });

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _tempatController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _anggotaController = TextEditingController();
  final List<String> _anggotaList = [];
  final List<dynamic> _imageFiles = [];
  DateTime _selectedDate = DateTime.now();

  // Data user tetap tersimpan tapi tidak ditampilkan
  late final String _username;
  late final int _userId;

  @override
  void initState() {
    super.initState();
    // Simpan data user saat inisialisasi
    _username = widget.username;
    _userId = widget.userId;
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();

    if (kIsWeb) {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _imageFiles.add(image);
        });
      }
    } else {
      final List<XFile> images = await picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _imageFiles.addAll(images);
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('id', 'ID'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addAnggota() {
    if (_anggotaController.text.isNotEmpty) {
      setState(() {
        _anggotaList.add(_anggotaController.text);
        _anggotaController.clear();
      });
    }
  }

  Widget _buildImagePreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Grid untuk menampilkan foto yang sudah dipilih
        if (_imageFiles.isNotEmpty)
          Container(
            height: 120,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: _imageFiles.length,
              itemBuilder: (context, index) {
                final imageFile = _imageFiles[index];
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: kIsWeb
                            ? Image.network(
                                imageFile.path,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(imageFile.path),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _imageFiles.removeAt(index);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        const SizedBox(height: 8),
        // Tombol tambah foto
        ElevatedButton.icon(
          onPressed: _pickImages,
          icon: const Icon(Icons.add_photo_alternate),
          label: const Text('Tambah Foto'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 45),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Tanggal',
          border: OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('dd-MM-yyyy').format(_selectedDate),
            ),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  Future<void> _submitCatatan() async {
    // Tambahkan anggota yang ada di field ke daftar anggota
    if (_anggotaController.text.isNotEmpty) {
      _anggotaList.add(_anggotaController.text.trim());
      _anggotaController.clear(); // Kosongkan field setelah ditambahkan
    }

    if (_formKey.currentState!.validate()) {
      try {
        var request =
            http.MultipartRequest('POST', Uri.parse(ApiConfig.createCatatan));

        // Data teks
        Map<String, String> fields = {
          'user_id': _userId.toString(),
          'judul': _judulController.text.trim(),
          'tanggal': DateFormat('yyyy-MM-dd').format(_selectedDate),
          'tempat': _tempatController.text.trim(),
          'deskripsi': _deskripsiController.text.trim(),
          'anggota': _anggotaList.isEmpty ? '-' : _anggotaList.join(', '),
          'status': '1',
          'nama_user': widget.username,
        };

        request.fields.addAll(fields);

        // Handle file gambar
        if (_imageFiles.isNotEmpty) {
          for (var imageFile in _imageFiles) {
            try {
              if (kIsWeb) {
                var bytes = await imageFile.readAsBytes();
                var multipartFile = http.MultipartFile.fromBytes(
                  'images[]',
                  bytes,
                  filename:
                      'image_${DateTime.now().millisecondsSinceEpoch}.jpg',
                  contentType: MediaType('image', 'jpeg'),
                );
                request.files.add(multipartFile);
              } else {
                var fileName = imageFile.path.split('/').last;
                var mimeType = lookupMimeType(imageFile.path);
                var contentType = MediaType.parse(mimeType ?? 'image/jpeg');

                request.files.add(
                  await http.MultipartFile.fromPath(
                    'images[]',
                    imageFile.path,
                    filename:
                        'image_${DateTime.now().millisecondsSinceEpoch}_$fileName',
                    contentType: contentType,
                  ),
                );
              }
              print('Berhasil menambahkan file gambar ke request');
            } catch (e) {
              print('Error saat mengunggah gambar: $e');
            }
          }
        }

        // Debug informasi request
        print('URL API: ${request.url}');
        print('Fields yang dikirim: ${request.fields}');
        print('Jumlah file yang akan diunggah: ${request.files.length}');
        request.files.forEach((file) {
          print('File: ${file.filename}, Field: ${file.field}');
        });

        // Kirim request
        var streamedResponse = await request.send();
        var responseData = await streamedResponse.stream.bytesToString();

        print('Status code: ${streamedResponse.statusCode}');
        print('Response headers: ${streamedResponse.headers}');
        print('Response body: $responseData');

        // Coba parse JSON
        Map<String, dynamic> jsonResponse;
        try {
          if (responseData.isNotEmpty) {
            jsonResponse = json.decode(responseData);
            print('Response JSON: $jsonResponse');
          } else {
            throw Exception('Response kosong dari server');
          }
        } catch (e) {
          print('Error parsing JSON: $e');
          print('Response data yang tidak bisa di-parse: $responseData');
          throw Exception('Format response tidak valid: $e');
        }

        // Cek status response
        if (streamedResponse.statusCode == 200) {
          if (jsonResponse['success'] == true) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Catatan berhasil disimpan')),
              );
              Navigator.pop(context, true);
            }
          } else {
            throw Exception(
                jsonResponse['message'] ?? 'Gagal menyimpan catatan');
          }
        } else {
          throw Exception('Server error: ${streamedResponse.statusCode}');
        }
      } catch (e) {
        print('Error dalam proses submit: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    }
  }

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
            const Text(
              'Tambah Kegiatan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Username field (readonly/disabled)
                  TextFormField(
                    initialValue: widget.username,
                    enabled: false, // Tidak bisa diedit
                    decoration: InputDecoration(
                      labelText: 'Author',
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white, // Warna sama dengan field lain
                      suffixIcon: const Icon(
                        Icons.lock_outline, // Icon gembok
                        color: Color(0xFF396BB5),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Foto Dokumentasi:  (maks. 4)',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      _buildImagePreview(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _judulController,
                    decoration: const InputDecoration(
                      labelText: 'Judul Rekapan',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Judul tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDatePicker(),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _tempatController,
                    decoration: const InputDecoration(
                      labelText: 'Tempat',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tempat tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _deskripsiController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Deskripsi tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Daftar Anggota:'),
                      const SizedBox(height: 8),
                      ..._anggotaList.map((anggota) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Chip(
                              label: Text(anggota),
                              onDeleted: () {
                                setState(() {
                                  _anggotaList.remove(anggota);
                                });
                              },
                            ),
                          )),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _anggotaController,
                              decoration: const InputDecoration(
                                labelText: 'Tambah Anggota',
                                border: OutlineInputBorder(),
                              ),
                              onEditingComplete: _addAnggota,
                              onFieldSubmitted: (_) => _addAnggota(),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle),
                            onPressed: _addAnggota,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitCatatan,
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text('Simpan Catatan',
                            style: TextStyle(fontSize: 16)),
                      ),
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
