class User {
  final String id;
  final String nama;
  final String email;
  final String noTelepon;
  final String password;
  User({
    required this.id,
    required this.nama,
    required this.email,
    required this.noTelepon,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      nama: json['nama'].toString(),
      email: json['email'].toString(),
      noTelepon: json['no_telepon'].toString(),
      password: json['password'].toString(),
    );
  }
}
