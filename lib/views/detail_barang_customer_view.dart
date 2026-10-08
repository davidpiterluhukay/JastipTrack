import 'package:flutter/material.dart';
import '../controllers/customer_controller.dart';
import '../models/customer_tracking.dart';

class DetailBarangCustomerView extends StatefulWidget {
  final int idBarang;

  const DetailBarangCustomerView({super.key, required this.idBarang});

  @override
  State<DetailBarangCustomerView> createState() =>
      _DetailBarangCustomerViewState();
}

class _DetailBarangCustomerViewState extends State<DetailBarangCustomerView> {
  final CustomerController controller = CustomerController();

  CustomerTracking? barang;

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await controller.getDetailBarang(widget.idBarang);

      if (!mounted) return;

      setState(() {
        barang = data;
        isLoading = false;
      });
    } catch (e) {
      print('ERROR DETAIL CUSTOMER: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = 'Gagal mengambil detail barang';
      });
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

    return '${waktu.day} ${namaBulan[waktu.month - 1]} '
        '${waktu.year}, '
        '${waktu.hour.toString().padLeft(2, '0')}:'
        '${waktu.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Barang'),
        leading: Image.asset('assets/images/logo.png'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildKargoSection(CustomerTracking data) {
    if (data.kargo == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informasi Pengiriman Kargo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.grey),
                  SizedBox(width: 10),
                  Expanded(child: Text('Barang belum dikirim melalui kargo.')),
                ],
              ),
            ],
          ),
        ),
      );
    }

    final kargo = data.kargo!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informasi Pengiriman Kargo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            _buildInfo('No. Resi Kargo', kargo.noResiKargo),

            _buildInfo('Tanggal Kirim', _formatTanggal(kargo.tanggalKirim)),

            _buildInfo(
              'Tanggal Tiba',
              kargo.tanggalTiba != null
                  ? _formatTanggal(kargo.tanggalTiba!)
                  : 'Belum tiba',
            ),

            _buildInfo('Jastip Tujuan', kargo.namaJastip),

            _buildInfo('Alamat', kargo.alamatJastip),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(String status) {
    const statuses = [
      'Diterima Jastip',
      'Dikirim via Kargo',
      'Tiba di Jastip Tujuan',
      'Diterima Customer',
    ];

    final currentIndex = statuses.indexOf(status);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Status Perjalanan Barang',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            ...List.generate(statuses.length, (index) {
              final sudahLewat = index <= currentIndex;
              final terakhir = index == statuses.length - 1;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Icon(
                        sudahLewat
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        size: 24,
                      ),

                      if (!terakhir) Container(width: 2, height: 40),
                    ],
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2, bottom: 16),
                      child: Text(
                        statuses[index],
                        style: TextStyle(
                          fontWeight: sudahLewat
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 50, color: Colors.red),
            const SizedBox(height: 10),
            Text(errorMessage!),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loadDetail,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (barang == null) {
      return const Center(child: Text('Data barang tidak ditemukan'));
    }

    final data = barang!;

    return RefreshIndicator(
      onRefresh: _loadDetail,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildStatusCard(data.status),
          const SizedBox(height: 16),

          _buildTimeline(data.status),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Barang',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  _buildInfo('No. Invoice', data.noInvoice),

                  _buildInfo('No. Resi Toko', data.noResiToko),

                  _buildInfo('Nama Toko', data.namaToko),

                  _buildInfo(
                    'Tanggal Diterima',
                    _formatTanggal(data.tanggalDiterima),
                  ),

                  _buildInfo('Status', data.status),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          _buildKargoSection(data),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String status) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.local_shipping, size: 50),

            const SizedBox(height: 10),

            const Text('Status Barang', style: TextStyle(fontSize: 16)),

            const SizedBox(height: 8),

            Text(
              status,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
