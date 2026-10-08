class PengirimanKargo {
  final int idPengiriman;
  final int idJastip;
  final String noResiKargo;
  final DateTime tanggalKirim;
  final DateTime? tanggalTiba;

  final String? namaJastip;
  final String? alamatJastip;

  PengirimanKargo({
    required this.idPengiriman,
    required this.idJastip,
    required this.noResiKargo,
    required this.tanggalKirim,
    this.tanggalTiba,
    this.namaJastip,
    this.alamatJastip,
  });

  factory PengirimanKargo.fromJson(Map<String, dynamic> json) {
    final jastip = json['jastip_tujuan'];

    return PengirimanKargo(
      idPengiriman: int.parse(json['id_pengiriman'].toString()),
      idJastip: int.parse(json['id_jastip'].toString()),
      noResiKargo: json['no_resi_kargo'].toString(),
      tanggalKirim: DateTime.parse(json['tanggal_kirim'].toString()),
      tanggalTiba: json['tanggal_tiba'] != null
          ? DateTime.parse(json['tanggal_tiba'].toString())
          : null,

      namaJastip: jastip != null ? jastip['nama_jastip']?.toString() : null,

      alamatJastip: jastip != null ? jastip['alamat']?.toString() : null,
    );
  }
}
