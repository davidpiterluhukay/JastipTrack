import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../controllers/staff_controller.dart';
import '../models/toko.dart';

class TambahBarangView extends StatefulWidget {
  const TambahBarangView({super.key});

  @override
  State<TambahBarangView> createState() => _TambahBarangViewState();
}

class _TambahBarangViewState extends State<TambahBarangView> {
  final StaffController controller = StaffController();

  final TextEditingController invoiceController = TextEditingController();

  final TextEditingController resiController = TextEditingController();

  List<Toko> daftarToko = [];

  Toko? tokoTerpilih;

  DateTime? tanggalDiterima;

  bool isLoadingToko = true;
  bool isSaving = false;

  List<Customer> daftarCustomer = [];

  Customer? customerTerpilih;

  bool isLoadingCustomer = true;

  @override
  void initState() {
    super.initState();
    _loadToko();
    _loadCustomer();
  }

  Future<void> _loadToko() async {
    try {
      final data = await controller.getToko();

      if (!mounted) return;

      setState(() {
        daftarToko = data;
        isLoadingToko = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingToko = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil daftar toko: $e')),
      );
    }
  }

  Future<void> _loadCustomer() async {
    try {
      final data = await controller.getCustomers();

      if (!mounted) return;

      setState(() {
        daftarCustomer = data;
        isLoadingCustomer = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingCustomer = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil daftar customer: $e')),
      );
    }
  }

  Future<void> _pilihTanggal() async {
    final DateTime? hasil = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (hasil != null) {
      setState(() {
        tanggalDiterima = hasil;
      });
    }
  }

  String _formatTanggal(DateTime tanggal) {
    return '${tanggal.year}-'
        '${tanggal.month.toString().padLeft(2, '0')}-'
        '${tanggal.day.toString().padLeft(2, '0')} '
        '09:00:00';
  }

  Future<void> _simpanBarang() async {
    if (invoiceController.text.trim().isEmpty) {
      _showMessage('Nomor invoice wajib diisi');
      return;
    }

    if (resiController.text.trim().isEmpty) {
      _showMessage('Nomor resi toko wajib diisi');
      return;
    }

    if (tokoTerpilih == null) {
      _showMessage('Silakan pilih toko');
      return;
    }

    if (tanggalDiterima == null) {
      _showMessage('Silakan pilih tanggal diterima');
      return;
    }

    if (customerTerpilih == null) {
      _showMessage('Silakan pilih customer');
      return;
    }

    // Customer sementara belum tersedia.
    setState(() {
      isSaving = true;
    });

    final berhasil = await controller.tambahBarang(
      idCustomer: customerTerpilih!.idCustomer,
      idToko: tokoTerpilih!.idToko,
      noInvoice: invoiceController.text.trim(),
      noResiToko: resiController.text.trim(),
      tanggalDiterima: _formatTanggal(tanggalDiterima!),
    );

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (berhasil) {
      _showMessage('Barang berhasil ditambahkan');

      Navigator.pop(context, true);
    } else {
      _showMessage('Gagal menambahkan barang');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    invoiceController.dispose();
    resiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/images/logo.png'),
        title: const Text('Tambah Barang'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data Barang Masuk',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'Masukkan informasi barang yang diterima oleh Jastip.',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 25),

            // CUSTOMER
            const Text(
              'Customer',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            isLoadingCustomer
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<Customer>(
                    value: customerTerpilih,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Pilih customer',
                      prefixIcon: Icon(Icons.person),
                    ),
                    items: daftarCustomer.map((customer) {
                      return DropdownMenuItem<Customer>(
                        value: customer,
                        child: Text(
                          '${customer.namaCustomer} - **** ${customer.noHp.substring(customer.noHp.length - 4)}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        customerTerpilih = value;
                      });
                    },
                  ),
            const SizedBox(height: 20),

            // TOKO
            const Text('Toko', style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),

            isLoadingToko
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<Toko>(
                    value: tokoTerpilih,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Pilih toko',
                      prefixIcon: Icon(Icons.store),
                    ),
                    items: daftarToko.map((toko) {
                      return DropdownMenuItem<Toko>(
                        value: toko,
                        child: Text(toko.namaToko),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        tokoTerpilih = value;
                      });
                    },
                  ),

            const SizedBox(height: 20),

            // INVOICE
            const Text(
              'Nomor Invoice',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: invoiceController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Contoh: INV-001',
                prefixIcon: Icon(Icons.receipt_long),
              ),
            ),

            const SizedBox(height: 20),

            // RESI
            const Text(
              'Nomor Resi Toko',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: resiController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Contoh: RESI-001',
                prefixIcon: Icon(Icons.local_shipping),
              ),
            ),

            const SizedBox(height: 20),

            // TANGGAL
            const Text(
              'Tanggal Diterima',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            InkWell(
              onTap: _pilihTanggal,
              child: InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  tanggalDiterima == null
                      ? 'Pilih tanggal'
                      : _formatTanggal(tanggalDiterima!),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // SIMPAN
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: isSaving ? null : _simpanBarang,
                icon: isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(isSaving ? 'Menyimpan...' : 'Simpan Barang'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
