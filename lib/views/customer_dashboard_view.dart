import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'detail_barang_customer_view.dart';
import '../controllers/customer_controller.dart';
import '../models/customer_tracking.dart';
import 'login_view.dart';

class CustomerDashboardView extends StatefulWidget {
  const CustomerDashboardView({super.key});

  @override
  State<CustomerDashboardView> createState() => _CustomerDashboardViewState();
}

class _CustomerDashboardViewState extends State<CustomerDashboardView> {
  final GetStorage storage = GetStorage();
  final CustomerController controller = CustomerController();

  List<CustomerTracking> daftarBarang = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBarang();
  }

  Future<void> _loadBarang() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await controller.getTrackingBarang();

      if (!mounted) return;

      setState(() {
        daftarBarang = data;
        isLoading = false;
      });
    } catch (e) {
      print('ERROR CUSTOMER DASHBOARD: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = 'Gagal mengambil data barang';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = storage.read('user');

    final String namaCustomer = user != null
        ? user['nama_customer'] ?? 'Customer'
        : 'Customer';

    return Scaffold(
      appBar: AppBar(
        title: const Text('JastipTrack'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: _loadBarang,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, $namaCustomer 👋',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Pantau status barang Anda di sini.',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),

              const SizedBox(height: 25),

              // Jumlah barang
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Icon(Icons.inventory_2, size: 45),

                      const SizedBox(width: 20),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Barang Saya',
                            style: TextStyle(fontSize: 16),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            '${daftarBarang.length} Barang',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Tracking Barang',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Text(errorMessage!, style: const TextStyle(color: Colors.red)),
      );
    }

    if (daftarBarang.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 100),
          Center(
            child: Column(
              children: [
                Icon(Icons.inventory_2_outlined, size: 70, color: Colors.grey),
                SizedBox(height: 10),
                Text(
                  'Belum ada barang',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
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

        return GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    DetailBarangCustomerView(idBarang: barang.idBarang),
              ),
            );

            _loadBarang();
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),

            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.inventory_2)),

              title: Text(
                barang.noInvoice,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),

                  Text('Toko: ${barang.namaToko}'),

                  Text('Resi: ${barang.noResiToko}'),

                  const SizedBox(height: 5),

                  Text(
                    barang.status,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              isThreeLine: true,
            ),
          ),
        );
      },
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
