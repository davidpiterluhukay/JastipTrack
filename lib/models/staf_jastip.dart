class StafJastip {
  final int idStaf;
  final String namaStaf;
  final String noHp;

  StafJastip({
    required this.idStaf,
    required this.namaStaf,
    required this.noHp,
  });

  factory StafJastip.fromJson(Map<String, dynamic> json) {
    return StafJastip(
      idStaf: int.parse(json['id_staf'].toString()),
      namaStaf: json['nama_staf'].toString(),
      noHp: json['no_hp'].toString(),
    );
  }
}