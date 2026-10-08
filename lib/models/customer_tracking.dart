import 'customer_kargo.dart';

class CustomerTracking {
  final int idBarang;
  final String namaToko;
  final String noInvoice;
  final String noResiToko;
  final String status;
  final DateTime tanggalDiterima;
  final CustomerKargo? kargo;

  CustomerTracking({
    required this.idBarang,
    required this.namaToko,
    required this.noInvoice,
    required this.noResiToko,
    required this.status,
    required this.tanggalDiterima,
    this.kargo,
  });

  factory CustomerTracking.fromJson(Map<String, dynamic> json) {
    return CustomerTracking(
      idBarang: int.parse(json['id_barang'].toString()),
      namaToko: json['nama_toko'].toString(),
      noInvoice: json['no_invoice'].toString(),
      noResiToko: json['no_resi_toko'].toString(),
      status: json['status'].toString(),
      tanggalDiterima: DateTime.parse(json['tanggal_diterima'].toString()),
      kargo: json['kargo'] != null
          ? CustomerKargo.fromJson(json['kargo'])
          : null,
    );
  }
}
