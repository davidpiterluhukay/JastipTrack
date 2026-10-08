class Toko {
  final int idToko;
  final String namaToko;

  Toko({
    required this.idToko,
    required this.namaToko,
  });

  factory Toko.fromJson(Map<String, dynamic> json) {
    return Toko(
      idToko: int.parse(json['id_toko'].toString()),
      namaToko: json['nama_toko'].toString(),
    );
  }
}