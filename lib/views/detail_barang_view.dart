import 'package:flutter/material.dart';

import '../controllers/staff_controller.dart';
import '../models/barang.dart';

class DetailBarangView extends StatefulWidget {
  final Barang barang;

  const DetailBarangView({super.key, required this.barang});

  @override
  State<DetailBarangView> createState() => _DetailBarangViewState();
}

class _DetailBarangViewState extends State<DetailBarangView> {
  final StaffController controller = StaffController();

  bool isLoading = false;

  Barang get barang => widget.barang;

  Color _getStatusColor(String status) {
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

  Future<void> _pilihKargo() async {
    setState(() {
      isLoading = true;
    });

    try {
      final daftarKargo = await controller.getPengirimanKargo();

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      if (daftarKargo.isEmpty) {
        _showMessage('Belum ada pengiriman kargo.');
        return;
      }

      final kargoTerpilih = await showDialog<dynamic>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Pilih Pengiriman Kargo'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: daftarKargo.length,
                itemBuilder: (context, index) {
                  final kargo = daftarKargo[index];

                  return ListTile(
                    leading: const Icon(Icons.local_shipping),
                    title: Text(kargo.noResiKargo),
                    subtitle: Text(
                      kargo.namaJastip ?? 'Jastip tujuan tidak diketahui',
                    ),
                    onTap: () {
                      Navigator.pop(context, kargo);
                    },
                  );
                },
              ),
            ),
          );
        },
      );

      if (kargoTerpilih == null) return;

      final konfirmasi = await _konfirmasi(
        'Kirim via Kargo',
        'Kirim barang ini menggunakan '
            '${kargoTerpilih.noResiKargo}?',
      );

      if (konfirmasi != true) return;

      setState(() {
        isLoading = true;
      });

      final berhasil = await controller.kirimKeKargo(
        idBarang: barang.idBarang,
        idPengiriman: kargoTerpilih.idPengiriman,
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      if (berhasil) {
        _showMessage('Barang berhasil dikirim via kargo.');

        await Future.delayed(const Duration(milliseconds: 800));

        if (!mounted) return;

        Navigator.pop(context, true);
      } else {
        _showMessage('Gagal mengirim barang via kargo.');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      _showMessage('Gagal mengambil daftar kargo.');
      print('ERROR PILIH KARGO: $e');
    }
  }

  Future<void> _ubahStatus() async {
    bool? konfirmasi;

    if (barang.status == 'Diterima Jastip') {
      await _pilihKargo();
      return;
    }

    if (barang.status == 'Dikirim via Kargo') {
      konfirmasi = await _konfirmasi(
        'Tandai Tiba',
        'Apakah barang sudah tiba di Jastip tujuan?',
      );

      if (konfirmasi != true) return;

      await _tandaiTiba();

      return;
    }

    if (barang.status == 'Tiba di Jastip Tujuan') {
      konfirmasi = await _konfirmasi(
        'Serahkan ke Customer',
        'Apakah barang sudah diserahkan kepada customer?',
      );

      if (konfirmasi != true) return;

      await _serahkanKeCustomer();

      return;
    }
  }

  Future<void> _tandaiTiba() async {
    setState(() {
      isLoading = true;
    });

    final berhasil = await controller.tandaiTiba(idBarang: barang.idBarang);

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (berhasil) {
      _showMessage('Barang berhasil ditandai sudah tiba.');
    } else {
      _showMessage('Gagal mengubah status barang.');
    }
  }

  Future<void> _serahkanKeCustomer() async {
    setState(() {
      isLoading = true;
    });

    final berhasil = await controller.serahkanKeCustomer(
      idBarang: barang.idBarang,
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (berhasil) {
      _showMessage('Barang berhasil diserahkan ke customer.');

      await Future.delayed(const Duration(milliseconds: 800));

      if (!mounted) return;

      Navigator.pop(context, true);
    } else {
      _showMessage('Gagal mengubah status barang.');
    }
  }

  Future<bool?> _konfirmasi(String title, String message) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _getButtonText() {
    switch (barang.status) {
      case 'Diterima Jastip':
        return 'Kirim via Kargo';

      case 'Dikirim via Kargo':
        return 'Tandai Tiba';

      case 'Tiba di Jastip Tujuan':
        return 'Serahkan ke Customer';

      default:
        return '';
    }
  }

  IconData _getButtonIcon() {
    switch (barang.status) {
      case 'Diterima Jastip':
        return Icons.local_shipping;

      case 'Dikirim via Kargo':
        return Icons.location_on;

      case 'Tiba di Jastip Tujuan':
        return Icons.check_circle;

      default:
        return Icons.check;
    }
  }

  String _formatTanggal(DateTime tanggal) {
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

    return '${tanggal.day} '
        '${namaBulan[tanggal.month - 1]} '
        '${tanggal.year}, '
        '${tanggal.hour.toString().padLeft(2, '0')}:'
        '${tanggal.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(barang.status);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Barang'),
        leading: Image.asset('assets/images/logo.png'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STATUS
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.local_shipping, size: 40, color: statusColor),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Status Barang',
                            style: TextStyle(color: Colors.grey),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            barang.status,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // INFORMASI BARANG
            const Text(
              'Informasi Barang',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Card(
              child: Column(
                children: [
                  _buildInfo(
                    Icons.confirmation_number,
                    'ID Barang',
                    barang.idBarang.toString(),
                  ),

                  _buildInfo(
                    Icons.receipt_long,
                    'Nomor Invoice',
                    barang.noInvoice,
                  ),

                  _buildInfo(
                    Icons.local_shipping,
                    'Nomor Resi Toko',
                    barang.noResiToko,
                  ),

                  _buildInfo(
                    Icons.calendar_today,
                    'Tanggal Diterima',
                    _formatTanggal(barang.tanggalDiterima),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 3),

            // INFORMASI RELASI
            const Text(
              'Informasi Relasi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Card(
              child: Column(
                children: [
                  _buildInfo(
                    Icons.person,
                    'Customer',
                    barang.customer?.namaCustomer ?? 'Tidak diketahui',
                  ),

                  _buildInfo(
                    Icons.store,
                    'Toko',
                    barang.toko?.namaToko ?? 'Tidak diketahui',
                  ),

                  _buildInfo(
                    Icons.local_shipping,
                    'Pengiriman',
                    barang.idPengiriman?.toString() ?? 'Belum ada',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // TOMBOL PERUBAHAN STATUS
            if (barang.status != 'Diterima Customer')
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : _ubahStatus,
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(_getButtonIcon()),
                  label: Text(isLoading ? 'Memproses...' : _getButtonText()),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        label,
        style: const TextStyle(color: Colors.grey, fontSize: 13),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}
