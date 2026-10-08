class JastipTujuan {
  final int idJastip;
  final String namaJastip;
  final String alamat;

  JastipTujuan({
    required this.idJastip,
    required this.namaJastip,
    required this.alamat,
  });

  factory JastipTujuan.fromJson(Map<String, dynamic> json) {
    return JastipTujuan(
      idJastip: int.parse(json['id_jastip'].toString()),
      namaJastip: json['nama_jastip'].toString(),
      alamat: json['alamat'].toString(),
    );
  }
}
