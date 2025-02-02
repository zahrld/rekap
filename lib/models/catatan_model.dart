class Catatan {
  final int? id;
  final int userId;
  final String judul;
  final String? deskripsi;
  final String? tempat;
  final String? anggota;
  final String? gambar;
  final String? createdAt;
  final String tanggal;
  final String penulis;

  Catatan({
    this.id,
    required this.userId,
    required this.judul,
    this.deskripsi,
    this.tempat,
    required this.tanggal,
    this.anggota,
    this.gambar,
    this.createdAt,
    required this.penulis,
  });

  factory Catatan.fromJson(Map<String, dynamic> json) {
    return Catatan(
      id: json['id'],
      userId: json['user_id'],
      judul: json['judul'],
      deskripsi: json['deskripsi'],
      tempat: json['tempat'],
      anggota: json['anggota'],
      gambar: json['gambar'],
      createdAt: json['created_at'],
      tanggal: json['tanggal'],
      penulis: json['penulis'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'judul': judul,
      'deskripsi': deskripsi,
      'tempat': tempat,
      'anggota': anggota,
      'gambar': gambar,
      'penulis': penulis,
    };
  }
}
