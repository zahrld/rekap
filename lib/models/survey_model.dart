class Survey {
  final String id;
  final String lokasi;
  final String keterangan;
  final DateTime tanggal;

  Survey({
    required this.id,
    required this.lokasi,
    required this.keterangan,
    required this.tanggal,
  });

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      id: json['id'],
      lokasi: json['lokasi'],
      keterangan: json['keterangan'],
      tanggal: DateTime.parse(json['tanggal']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lokasi': lokasi,
      'keterangan': keterangan,
      'tanggal': tanggal.toIso8601String(),
    };
  }
}
