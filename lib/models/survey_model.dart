class Activity {
  final int id;
  final String judul;
  final DateTime tanggal;
  final String tempat;
  final String deskripsi;
  final String anggota;
  final List<String> gambar;
  final List<String>? images;
  final String username;

  Activity({
    required this.id,
    required this.judul,
    required this.tanggal,
    required this.tempat,
    required this.deskripsi,
    required this.anggota,
    required this.gambar,
    this.images,
    required this.username,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      judul: json['judul'],
      tanggal: DateTime.parse(json['tanggal']),
      tempat: json['tempat'],
      deskripsi: json['deskripsi'],
      anggota: json['anggota'],
      gambar: json['gambar'] != null
          ? List<String>.from(json['gambar'].split(','))
          : [],
      images: List<String>.from(json['images'] ?? []),
      username: json['username'] ?? '',
    );
  }

  Object? toJson() {}
}
