class CustomerKargo {
  final int idPengiriman;
  final String noResiKargo;
  final DateTime tanggalKirim;
  final DateTime? tanggalTiba;
  final String namaJastip;
  final String alamatJastip;

  CustomerKargo({
    required this.idPengiriman,
    required this.noResiKargo,
    required this.tanggalKirim,
    this.tanggalTiba,
    required this.namaJastip,
    required this.alamatJastip,
  });

  factory CustomerKargo.fromJson(Map<String, dynamic> json) {
    final jastip = json['jastip_tujuan'];

    return CustomerKargo(
      idPengiriman: int.parse(json['id_pengiriman'].toString()),
      noResiKargo: json['no_resi_kargo'].toString(),
      tanggalKirim: DateTime.parse(json['tanggal_kirim'].toString()),
      tanggalTiba: json['tanggal_tiba'] != null
          ? DateTime.parse(json['tanggal_tiba'].toString())
          : null,
      namaJastip: jastip != null ? jastip['nama_jastip'].toString() : '-',
      alamatJastip: jastip != null ? jastip['alamat'].toString() : '-',
    );
  }
}
