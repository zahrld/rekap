class Activity {
  final String judul;
  final DateTime tanggal;
  final String tempat;
  final String deskripsi;
  final String anggota;
  final List<String>? images;
  final String penulis;

  Activity({
    required this.judul,
    required this.tanggal,
    required this.tempat,
    required this.deskripsi,
    required this.anggota,
    this.images,
    required this.penulis,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      judul: json['judul'],
      tanggal: DateTime.parse(json['tanggal']),
      tempat: json['tempat'],
      deskripsi: json['deskripsi'],
      anggota: json['anggota'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      penulis: json['penulis'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'judul': judul,
      'tanggal': tanggal.toIso8601String(),
      'tempat': tempat,
      'deskripsi': deskripsi,
      'anggota': anggota,
      'images': images,
      'penulis': penulis,
    };
  }
}
