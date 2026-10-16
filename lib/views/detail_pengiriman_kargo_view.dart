import 'package:flutter/material.dart';

import '../controllers/staff_controller.dart';
import '../models/pengiriman_kargo.dart';

class DetailPengirimanKargoView extends StatefulWidget {
  final PengirimanKargo kargo;

  const DetailPengirimanKargoView({super.key, required this.kargo});

  @override
  State<DetailPengirimanKargoView> createState() =>
      _DetailPengirimanKargoViewState();
}

class _DetailPengirimanKargoViewState extends State<DetailPengirimanKargoView> {
  final StaffController controller = StaffController();

  bool isLoading = true;
  String? errorMessage;

  Map<String, dynamic>? detailKargo;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    try {
      final data = await controller.getDetailPengirimanKargo(
        widget.kargo.idPengiriman,
      );

      if (!mounted) return;

      setState(() {
        detailKargo = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _tandaiKargoTiba() async {
    final data = detailKargo ?? {};
    final barang = data['barang'] as List<dynamic>? ?? [];

    if (barang.isEmpty) {
      _showMessage('Tidak ada barang dalam kargo.');
      return;
    }

    final barangIds = barang
        .map((item) => int.parse(item['id_barang'].toString()))
        .toList();

    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tandai Kargo Tiba'),
          content: Text(
            'Apakah kargo ini sudah tiba di Jastip tujuan?\n\n'
            '${barang.length} barang akan diubah menjadi '
            '"Tiba di Jastip Tujuan".',
          ),
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
              child: const Text('Ya, Tiba'),
            ),
          ],
        );
      },
    );

    if (konfirmasi != true) return;

    setState(() {
      isLoading = true;
    });

    final berhasil = await controller.tandaiSemuaBarangTiba(barangIds);

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (berhasil) {
      _showMessage('Semua barang berhasil ditandai sudah tiba.');

      await Future.delayed(const Duration(milliseconds: 800));

      if (!mounted) return;

      Navigator.pop(context, true);
    } else {
      _showMessage('Gagal mengubah status barang.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _formatTanggal(String? tanggal) {
    if (tanggal == null || tanggal.isEmpty) {
      return '-';
    }

    try {
      final date = DateTime.parse(tanggal).toLocal();

      const bulan = [
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

      return '${date.day} ${bulan[date.month - 1]} ${date.year} '
          '${date.hour.toString().padLeft(2, '0')}:'
          '${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return tanggal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengiriman Kargo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'Gagal mengambil data:\n$errorMessage',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final data = detailKargo ?? {};

    final barang = data['barang'] as List<dynamic>? ?? [];

    final jastip = data['jastip_tujuan'] as Map<String, dynamic>? ?? {};

    return RefreshIndicator(
      onRefresh: _loadDetail,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoKargo(data, jastip),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : _tandaiKargoTiba,
              icon: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.location_on),
              label: Text(isLoading ? 'Memproses...' : 'Tandai Kargo Tiba'),
            ),
          ),

          const SizedBox(height: 24),

          Text('Barang yang Dimuat (${barang.length})'),

          const SizedBox(height: 12),

          if (barang.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text('Belum ada barang yang dimuat ke kargo.'),
                ),
              ),
            )
          else
            ...barang.map(
              (item) => _buildBarangCard(item as Map<String, dynamic>),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoKargo(
    Map<String, dynamic> data,
    Map<String, dynamic> jastip,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.local_shipping, size: 40),

            const SizedBox(height: 12),

            Text(
              data['no_resi_kargo']?.toString() ?? '-',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const Divider(height: 24),

            _buildInfoRow(
              Icons.location_on,
              'Jastip Tujuan',
              jastip['nama_jastip']?.toString() ?? '-',
            ),

            _buildInfoRow(
              Icons.home,
              'Alamat',
              jastip['alamat']?.toString() ?? '-',
            ),

            _buildInfoRow(
              Icons.calendar_today,
              'Tanggal Kirim',
              _formatTanggal(data['tanggal_kirim']?.toString()),
            ),

            _buildInfoRow(
              Icons.event_available,
              'Tanggal Tiba',
              _formatTanggal(data['tanggal_tiba']?.toString()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),

                const SizedBox(height: 2),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarangCard(Map<String, dynamic> barang) {
    final toko = barang['toko'] as Map<String, dynamic>? ?? {};

    final customer = barang['customer'] as Map<String, dynamic>? ?? {};

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.inventory_2),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    barang['no_invoice']?.toString() ?? '-',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 20),

            _buildInfoRow(
              Icons.person,
              'Customer',
              customer['nama_customer']?.toString() ?? '-',
            ),

            _buildInfoRow(
              Icons.store,
              'Toko',
              toko['nama_toko']?.toString() ?? '-',
            ),

            _buildInfoRow(
              Icons.qr_code,
              'Resi Toko',
              barang['no_resi_toko']?.toString() ?? '-',
            ),

            _buildInfoRow(
              Icons.calendar_today,
              'Diterima',
              _formatTanggal(barang['tanggal_diterima']?.toString()),
            ),

            _buildInfoRow(
              Icons.info_outline,
              'Status',
              barang['status']?.toString() ?? '-',
            ),
          ],
        ),
      ),
    );
  }
}
