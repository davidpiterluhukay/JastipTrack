import 'customer.dart';
import 'toko.dart';

class Barang {
  final int idBarang;
  final int idCustomer;
  final int idStaf;
  final int idToko;
  final int? idPengiriman;
  final String noInvoice;
  final String noResiToko;
  final DateTime tanggalDiterima;
  final String status;

  final Customer? customer;
  final Toko? toko;

  Barang({
    required this.idBarang,
    required this.idCustomer,
    required this.idStaf,
    required this.idToko,
    this.idPengiriman,
    required this.noInvoice,
    required this.noResiToko,
    required this.tanggalDiterima,
    required this.status,
    this.customer,
    this.toko,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      idBarang: json['id_barang'],
      idCustomer: json['id_customer'],
      idStaf: json['id_staf'],
      idToko: json['id_toko'],
      idPengiriman: json['id_pengiriman'],
      noInvoice: json['no_invoice'],
      noResiToko: json['no_resi_toko'],
      tanggalDiterima: DateTime.parse(json['tanggal_diterima']),
      status: json['status'],
      customer: json['customer'] != null
          ? Customer.fromJson(json['customer'])
          : null,
      toko: json['toko'] != null ? Toko.fromJson(json['toko']) : null,
    );
  }
}
