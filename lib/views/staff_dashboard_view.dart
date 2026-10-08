import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jastiptrack/views/daftar_pengiriman_kargo_view.dart';
import 'package:jastiptrack/views/tambah_barang_view.dart';
import '../controllers/staff_controller.dart';
import 'login_view.dart';
import 'daftar_barang_view.dart';
import 'daftar_toko_view.dart';

class StaffDashboardView extends StatefulWidget {
  const StaffDashboardView({super.key});

  @override
  State<StaffDashboardView> createState() => _StaffDashboardViewState();
}

class _StaffDashboardViewState extends State<StaffDashboardView> {
  final GetStorage storage = GetStorage();
  final StaffController controller = StaffController();

  Map<String, dynamic> summary = {};

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    try {
      final data = await controller.getDashboardSummary();

      if (!mounted) return;

      setState(() {
        summary = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = 'Gagal mengambil data dashboard';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = storage.read('user');

    final String namaStaf = user != null ? user['nama_staf'] ?? 'Staf' : 'Staf';

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          flexibleSpace: Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(width: 2),
                Container(
                  width: 160,
                  height: 30,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo2.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
          ],
        ),
      ),

      body: RefreshIndicator(
        onRefresh: _loadDashboard,
        child: _buildBody(namaStaf),
      ),
    );
  }

  Widget _buildBody(String namaStaf) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Text(errorMessage!, style: const TextStyle(color: Colors.red)),
      );
    }

    final total = summary['total_barang'] ?? 0;

    final diterima = summary['diterima_jastip'] ?? 0;

    final dikirim = summary['dikirim_via_kargo'] ?? 0;

    final tiba = summary['tiba_di_jastip_tujuan'] ?? 0;

    final selesai = summary['diterima_customer'] ?? 0;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Halo, $namaStaf 👋',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        const Text(
          'Ringkasan pengelolaan barang JastipTrack.',
          style: TextStyle(color: Colors.grey),
        ),

        const SizedBox(height: 25),

        _buildSummaryCard('Total Barang', total, Icons.inventory_2),

        const SizedBox(height: 10),

        _buildSummaryCard('Diterima Jastip', diterima, Icons.move_to_inbox),

        const SizedBox(height: 10),

        _buildSummaryCard('Dikirim via Kargo', dikirim, Icons.local_shipping),

        const SizedBox(height: 10),

        _buildSummaryCard('Tiba di Jastip Tujuan', tiba, Icons.location_on),

        const SizedBox(height: 10),

        _buildSummaryCard('Diterima Customer', selesai, Icons.check_circle),
        const SizedBox(height: 25),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TambahBarangView(),
                ),
              );
            },
            icon: const Icon(Icons.add_box),
            label: const Text('Tambah Barang'),
          ),
        ),
        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DaftarBarangView(),
                ),
              );
            },
            icon: const Icon(Icons.inventory_2),
            label: const Text('Daftar Barang'),
          ),
        ),
        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DaftarTokoView()),
              );
            },
            icon: const Icon(Icons.store),
            label: const Text('Daftar Toko'),
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DaftarPengirimanKargoView(),
                ),
              );
            },
            icon: const Icon(Icons.local_shipping),
            label: const Text('Pengiriman Kargo'),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, dynamic value, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 40),
        title: Text(title),
        trailing: Text(
          '$value',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> _logout() async {
    await storage.remove('access_token');
    await storage.remove('role');
    await storage.remove('user');

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
      (route) => false,
    );
  }
}
