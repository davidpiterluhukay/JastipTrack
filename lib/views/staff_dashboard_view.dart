// import 'package:flutter/material.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:jastiptrack/views/daftar_pengiriman_kargo_view.dart';
// import 'package:jastiptrack/views/tambah_barang_view.dart';
// import '../controllers/staff_controller.dart';
// import 'login_view.dart';
// import 'daftar_barang_view.dart';
// import 'daftar_toko_view.dart';

// class StaffDashboardView extends StatefulWidget {
//   const StaffDashboardView({super.key});

//   @override
//   State<StaffDashboardView> createState() => _StaffDashboardViewState();
// }

// class _StaffDashboardViewState extends State<StaffDashboardView> {
//   final GetStorage storage = GetStorage();
//   final StaffController controller = StaffController();

//   Map<String, dynamic> summary = {};

//   bool isLoading = true;
//   String? errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _loadDashboard();
//   }

//   Future<void> _loadDashboard() async {
//     try {
//       final data = await controller.getDashboardSummary();

//       if (!mounted) return;

//       setState(() {
//         summary = data;
//         isLoading = false;
//       });
//     } catch (e) {
//       if (!mounted) return;

//       setState(() {
//         isLoading = false;
//         errorMessage = 'Gagal mengambil data dashboard';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = storage.read('user');

//     final String namaStaf = user != null ? user['nama_staf'] ?? 'Staf' : 'Staf';

//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(70),
//         child: AppBar(
//           flexibleSpace: Container(
//             padding: EdgeInsets.all(8),
//             alignment: Alignment.topLeft,
//             child: Row(
//               children: [
//                 Container(
//                   width: 75,
//                   height: 75,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage('assets/images/logo.png'),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 2),
//                 Container(
//                   width: 160,
//                   height: 30,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage('assets/images/logo2.png'),
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
//           ],
//         ),
//       ),

//       body: RefreshIndicator(
//         onRefresh: _loadDashboard,
//         child: _buildBody(namaStaf),
//       ),
//     );
//   }

//   Widget _buildBody(String namaStaf) {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (errorMessage != null) {
//       return Center(
//         child: Text(errorMessage!, style: const TextStyle(color: Colors.red)),
//       );
//     }

//     final total = summary['total_barang'] ?? 0;

//     final diterima = summary['diterima_jastip'] ?? 0;

//     final dikirim = summary['dikirim_via_kargo'] ?? 0;

//     final tiba = summary['tiba_di_jastip_tujuan'] ?? 0;

//     final selesai = summary['diterima_customer'] ?? 0;

//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         Text(
//           'Halo, $namaStaf 👋',
//           style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),

//         const SizedBox(height: 8),

//         const Text(
//           'Ringkasan pengelolaan barang JastipTrack.',
//           style: TextStyle(color: Colors.grey),
//         ),

//         const SizedBox(height: 25),

//         _buildSummaryCard('Total Barang', total, Icons.inventory_2),

//         const SizedBox(height: 10),

//         _buildSummaryCard('Diterima Jastip', diterima, Icons.move_to_inbox),

//         const SizedBox(height: 10),

//         _buildSummaryCard('Dikirim via Kargo', dikirim, Icons.local_shipping),

//         const SizedBox(height: 10),

//         _buildSummaryCard('Tiba di Jastip Tujuan', tiba, Icons.location_on),

//         const SizedBox(height: 10),

//         _buildSummaryCard('Diterima Customer', selesai, Icons.check_circle),
//         const SizedBox(height: 25),

//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton.icon(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const TambahBarangView(),
//                 ),
//               );
//             },
//             icon: const Icon(Icons.add_box),
//             label: const Text('Tambah Barang'),
//           ),
//         ),
//         const SizedBox(height: 12),

//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton.icon(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const DaftarBarangView(),
//                 ),
//               );
//             },
//             icon: const Icon(Icons.inventory_2),
//             label: const Text('Daftar Barang'),
//           ),
//         ),
//         const SizedBox(height: 12),

//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton.icon(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const DaftarTokoView()),
//               );
//             },
//             icon: const Icon(Icons.store),
//             label: const Text('Daftar Toko'),
//           ),
//         ),

//         const SizedBox(height: 12),

//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton.icon(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const DaftarPengirimanKargoView(),
//                 ),
//               );
//             },
//             icon: const Icon(Icons.local_shipping),
//             label: const Text('Pengiriman Kargo'),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSummaryCard(String title, dynamic value, IconData icon) {
//     return Card(
//       child: ListTile(
//         leading: Icon(icon, size: 40),
//         title: Text(title),
//         trailing: Text(
//           '$value',
//           style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }

//   Future<void> _logout() async {
//     await storage.remove('access_token');
//     await storage.remove('role');
//     await storage.remove('user');

//     if (!mounted) return;

//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginView()),
//       (route) => false,
//     );
//   }
// }

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
        errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = 'Gagal mengambil data dashboard';
      });
      debugPrint('Dashboard loading error: $e');
    }
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

  @override
  Widget build(BuildContext context) {
    final user = storage.read('user');
    final String namaStaf = user != null ? user['nama_staf'] ?? 'Staf' : 'Staf';

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: RefreshIndicator(
        onRefresh: _loadDashboard,
        color: const Color(0xFF0EA5E9),
        child: _buildBody(namaStaf),
      ),
    );
  }

  Widget _buildBody(String namaStaf) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0EA5E9)),
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                _loadDashboard();
              },
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    final total = summary['total_barang'] ?? 0;
    final diterima = summary['diterima_jastip'] ?? 0;
    final dikirim = summary['dikirim_via_kargo'] ?? 0;
    final tiba = summary['tiba_di_jastip_tujuan'] ?? 0;
    final selesai = summary['diterima_customer'] ?? 0;

    double progressRatio = 0.0;
    int progressPercentage = 0;
    if (total > 0) {
      progressRatio = selesai / total;
      progressPercentage = ((selesai / total) * 100).round();
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          _buildVisualHeader(
            namaStaf,
            total,
            selesai,
            progressRatio,
            progressPercentage,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 14),
                _buildStatusGrid(diterima, dikirim, tiba, selesai),
                const Text(
                  'Aksi Cepat',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),
                _buildPrimaryActionButton(),
                const SizedBox(height: 16),
                _buildQuickNavigationMenu(),
                const SizedBox(height: 32),
                _buildSignOutFooter(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisualHeader(
    String namaStaf,
    int total,
    int selesai,
    double progressRatio,
    int progressPercentage,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 260,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0EA5E9), Color(0xFF06B6D4), Color(0xFF10B981)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        // SizedBox(width: 6),
                        Image(
                          image: AssetImage('assets/images/logo2.png'),
                          width: 80,
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Halo, $namaStaf',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Ringkasan pengelolaan barang JastipTrack hari ini.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 190,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2FE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.inventory_2_outlined,
                            color: Color(0xFF0EA5E9),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Barang',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Semua status paket',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '$total',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progressRatio,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF0EA5E9),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF0EA5E9),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '$selesai dari $total barang sudah diterima customer',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFA7F3D0)),
                      ),
                      child: Text(
                        '$progressPercentage%',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF065F46),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Positioned(child: SizedBox(height: 300)),
      ],
    );
  }

  Widget _buildStatusGrid(int diterima, int dikirim, int tiba, int selesai) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildStatusCard(
          title: 'Diterima Jastip',
          value: '$diterima',
          icon: Icons.inventory_2_outlined,
          iconColor: const Color(0xFF2563EB),
          bgColor: const Color(0xFFEFF6FF),
        ),
        _buildStatusCard(
          title: 'Dikirim via Kargo',
          value: '$dikirim',
          icon: Icons.local_shipping_outlined,
          iconColor: const Color(0xFFD97706),
          bgColor: const Color(0xFFFFFBEB),
        ),
        _buildStatusCard(
          title: 'Tiba di Jastip Tujuan',
          value: '$tiba',
          icon: Icons.location_on_outlined,
          iconColor: const Color(0xFF7C3AED),
          bgColor: const Color(0xFFF5F3FF),
        ),
        _buildStatusCard(
          title: 'Diterima Customer',
          value: '$selesai',
          icon: Icons.check_circle_outline,
          iconColor: const Color(0xFF059669),
          bgColor: const Color(0xFFECFDF5),
        ),
      ],
    );
  }

  Widget _buildStatusCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white,
          width: 2.0, // Adjust the thickness of the stroke here
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: iconColor, size: 20),
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
            ],
          ),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: iconColor.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryActionButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF06B6D4), Color(0xFF10B981)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TambahBarangView()),
            ).then((_) => _loadDashboard());
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Color(0xFF06B6D4),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Text(
                      'Tambah Barang',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.chevron_right, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickNavigationMenu() {
    return Row(
      children: [
        Expanded(
          child: _buildSubNavButton(
            label: 'Daftar Barang',
            icon: Icons.inventory_2_outlined,
            destination: const DaftarBarangView(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSubNavButton(
            label: 'Daftar Toko',
            icon: Icons.storefront_outlined,
            destination: const DaftarTokoView(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSubNavButton(
            label: 'Pengiriman Kargo',
            icon: Icons.local_shipping_outlined,
            destination: const DaftarPengirimanKargoView(),
          ),
        ),
      ],
    );
  }

  Widget _buildSubNavButton({
    required String label,
    required IconData icon,
    required Widget destination,
  }) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            ).then((_) => _loadDashboard());
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: const Color(0xFF0F172A), size: 24),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF334155),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignOutFooter() {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: _logout,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.logout, size: 18, color: Color(0xFF64748B)),
              SizedBox(width: 8),
              Text(
                'Keluar dari Akun Staf',
                style: TextStyle(
                  color: Color(0xFF475569),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
