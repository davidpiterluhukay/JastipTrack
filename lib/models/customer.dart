class Customer {
  final int idCustomer;
  final String namaCustomer;
  final String noHp;

  Customer({
    required this.idCustomer,
    required this.namaCustomer,
    required this.noHp,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      idCustomer: int.parse(json['id_customer'].toString()),
      namaCustomer: json['nama_customer'].toString(),
      noHp: json['no_hp'].toString(),
    );
  }
}
