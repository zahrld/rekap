class Dokumentasi {
  final int id;
  final String judul;
  final String deskripsi;
  final String gambarUrl;
  final String createdAt;

  Dokumentasi({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.gambarUrl,
    required this.createdAt,
  });

  factory Dokumentasi.fromJson(Map<String, dynamic> json) {
    return Dokumentasi(
      id: json['id'],
      judul: json['judul'],
      deskripsi: json['deskripsi'],
      gambarUrl: json['gambar_url'],
      createdAt: json['created_at'],
    );
  }
} 