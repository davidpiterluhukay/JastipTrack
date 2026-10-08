import 'package:flutter/material.dart';
import 'package:jastiptrack/views/detail_barang_view.dart';

import '../controllers/staff_controller.dart';
import '../models/barang.dart';

class DaftarBarangView extends StatefulWidget {
  const DaftarBarangView({super.key});

  @override
  State<DaftarBarangView> createState() => _DaftarBarangViewState();
}

class _DaftarBarangViewState extends State<DaftarBarangView> {
  final StaffController controller = StaffController();

  List<Barang> daftarBarang = [];

  bool isLoading = true;
  String? errorMessage;

  String statusFilter = '';
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadBarang();
  }

  Future<void> loadBarang() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await controller.getBarang(
        status: statusFilter,
        search: searchController.text.trim(),
      );

      setState(() {
        daftarBarang = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Diterima Jastip':
        return Colors.blue;
      case 'Dikirim via Kargo':
        return Colors.orange;
      case 'Tiba di Jastip Tujuan':
        return Colors.purple;
      case 'Diterima Customer':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatTanggal(DateTime tanggal) {
    final waktu = tanggal.toLocal();

    const namaBulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${waktu.day} '
        '${namaBulan[waktu.month - 1]} '
        '${waktu.year}, '
        '${waktu.hour.toString().padLeft(2, '0')}:'
        '${waktu.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Barang'),
        leading: Image.asset('assets/images/logo.png'),
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Cari invoice atau resi...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: loadBarang,
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => loadBarang(),
            ),
          ),

          // Filter status
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonFormField<String>(
              initialValue: statusFilter,
              decoration: const InputDecoration(
                labelText: 'Filter Status',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: '', child: Text('Semua Status')),
                DropdownMenuItem(
                  value: 'Diterima Jastip',
                  child: Text('Diterima Jastip'),
                ),
                DropdownMenuItem(
                  value: 'Dikirim via Kargo',
                  child: Text('Dikirim via Kargo'),
                ),
                DropdownMenuItem(
                  value: 'Tiba di Jastip Tujuan',
                  child: Text('Tiba di Jastip Tujuan'),
                ),
                DropdownMenuItem(
                  value: 'Diterima Customer',
                  child: Text('Diterima Customer'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  statusFilter = value ?? '';
                });

                loadBarang();
              },
            ),
          ),

          const SizedBox(height: 10),

          // Data
          Expanded(
            child: RefreshIndicator(
              onRefresh: loadBarang,
              child: buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return ListView(
        children: [
          const SizedBox(height: 100),
          Center(
            child: Column(
              children: [
                const Icon(Icons.error_outline, size: 50, color: Colors.red),
                const SizedBox(height: 10),
                const Text('Gagal mengambil data barang'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: loadBarang,
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (daftarBarang.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 100),
          Center(
            child: Column(
              children: [
                Icon(Icons.inventory_2_outlined, size: 60, color: Colors.grey),
                SizedBox(height: 10),
                Text('Belum ada barang'),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: daftarBarang.length,
      itemBuilder: (context, index) {
        final barang = daftarBarang[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailBarangView(barang: barang),
                ),
              );

              if (result == true) {
                await loadBarang();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          barang.noInvoice,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: getStatusColor(barang.status)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          barang.status,
                          style: TextStyle(
                            color: getStatusColor(barang.status),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Resi Toko: ${barang.noResiToko}'),
                  const SizedBox(height: 5),
                  Text(
                    'Toko: ${barang.toko!.namaToko}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Customer: ${barang.customer!.namaCustomer}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 3),
                  Text('No. HP: ${barang.customer!.noHp}'),
                  const SizedBox(height: 5),
                  Text(
                    'Tanggal Diterima: ${_formatTanggal(barang.tanggalDiterima)}',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
