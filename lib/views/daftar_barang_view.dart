import 'package:flutter/material.dart';
import 'package:jastiptrack/views/detail_barang_view.dart';
import 'package:jastiptrack/views/tambah_barang_view.dart';
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
      debugPrint('Error loading barang: $e');
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
        return const Color(0xFF2563EB);
      case 'Dikirim via Kargo':
        return const Color(0xFFD97706);
      case 'Tiba di Jastip Tujuan':
        return const Color(0xFF7C3AED);
      case 'Diterima Customer':
        return const Color(0xFF059669);
      default:
        return Colors.grey;
    }
  }

  Color getStatusBgColor(String status) {
    switch (status) {
      case 'Diterima Jastip':
        return const Color(0xFFEFF6FF);
      case 'Dikirim via Kargo':
        return const Color(0xFFFFFBEB);
      case 'Tiba di Jastip Tujuan':
        return const Color(0xFFF5F3FF);
      case 'Diterima Customer':
        return const Color(0xFFECFDF5);
      default:
        return Colors.grey.shade100;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case 'Diterima Jastip':
        return Icons.inventory_2_outlined;
      case 'Dikirim via Kargo':
        return Icons.local_shipping_outlined;
      case 'Tiba di Jastip Tujuan':
        return Icons.location_on_outlined;
      default:
        return Icons.check_circle_outline;
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

    return '${waktu.day} ${namaBulan[waktu.month - 1]} ${waktu.year}, '
        '${waktu.hour.toString().padLeft(2, '0')}:${waktu.minute.toString().padLeft(2, '0')}';
  }

  int _countStatus(String status) {
    if (status.isEmpty) return daftarBarang.length;
    return daftarBarang.where((b) => b.status == status).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          Column(
            children: [
              _buildGradientHeader(),
              _buildSearchAndDropdownSection(),
              _buildHorizontalCapsuleFilter(),
              Expanded(
                child: RefreshIndicator(
                  color: const Color(0xFF0EA5E9),
                  onRefresh: loadBarang,
                  child: buildContent(),
                ),
              ),
            ],
          ),
          _buildFloatingActionButton(),
        ],
      ),
    );
  }

  Widget _buildGradientHeader() {
    return Container(
      width: double.infinity,
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
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  padding: const EdgeInsets.all(8),
                ),
              ),

              const Text(
                'Daftar Barang',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),

              const SizedBox(width: 40),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSearchAndDropdownSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Cari invoice atau resi...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          searchController.clear();
                          loadBarang();
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onSubmitted: (_) => loadBarang(),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                value: statusFilter,
                decoration: InputDecoration(
                  labelText: 'FILTER STATUS',
                  labelStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade400,
                    letterSpacing: 0.5,
                  ),
                  border: InputBorder.none,
                ),
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
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
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalCapsuleFilter() {
    final filters = [
      {'label': 'Semua', 'value': ''},
      {'label': 'Kargo', 'value': 'Dikirim via Kargo'},
      {'label': 'Tiba Jastip', 'value': 'Tiba di Jastip Tujuan'},
      {'label': 'Diterima', 'value': 'Diterima Jastip'},
    ];
    return Container(
      height: 38,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = statusFilter == filter['value'];
          final count = _countStatus(filter['value']!);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                setState(() => statusFilter = filter['value']!);
                loadBarang();
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0F172A) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : Colors.grey.shade200,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${filter['label']} ($count)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Color(0xFF0EA5E9)),
        ),
      );
    }
    if (errorMessage != null) {
      return ListView(
        children: [
          const SizedBox(height: 60),
          Center(
            child: Column(
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 54,
                  color: Colors.redAccent,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Gagal mengambil data barang',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: loadBarang,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0EA5E9),
                    foregroundColor: Colors.white,
                  ),
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
          SizedBox(height: 80),
          Center(
            child: Column(
              children: [
                Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 12),
                Text(
                  'Belum ada data barang terdaftar',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      itemCount: daftarBarang.length,
      itemBuilder: (context, index) {
        final barang = daftarBarang[index];
        final color = getStatusColor(barang.status);
        final bgColor = getStatusBgColor(barang.status);
        final icon = getStatusIcon(barang.status);
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailBarangView(barang: barang),
                ),
              );
              if (result == true) await loadBarang();
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(icon, color: color, size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    barang.status == 'Diterima Jastip'
                                        ? 'NO. RESI JASTIP'
                                        : 'NO. INVOICE',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade400,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    barang.noInvoice,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(icon, size: 12, color: color),
                              const SizedBox(width: 4),
                              Text(
                                barang.status,
                                style: TextStyle(
                                  color: color,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, color: Color(0xFFF1F5F9)),
                  ),
                  _buildManifestRow(
                    'Resi Toko:',
                    barang.noResiToko,
                    isBoldValue: true,
                  ),
                  const SizedBox(height: 8),
                  _buildManifestRow('Toko:', barang.toko?.namaToko ?? '-'),
                  const SizedBox(height: 8),
                  _buildManifestRow(
                    'Customer:',
                    barang.customer?.namaCustomer ?? '-',
                  ),
                  const SizedBox(height: 8),
                  _buildManifestRow(
                    'No. HP:',
                    barang.customer?.noHp ?? '-',
                    isLinkColor: true,
                  ),
                  const SizedBox(height: 8),
                  _buildManifestRow(
                    'Tanggal Diterima:',
                    _formatTanggal(barang.tanggalDiterima),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildManifestRow(
    String label,
    String value, {
    bool isBoldValue = false,
    bool isLinkColor = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBoldValue || isLinkColor
                  ? FontWeight.bold
                  : FontWeight.w500,
              color: isLinkColor
                  ? const Color(0xFF0EA5E9)
                  : const Color(0xFF334155),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return Positioned(
      bottom: 24,
      left: 20,
      right: 20,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0EA5E9), Color(0xFF10B981)],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0EA5E9).withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TambahBarangView(),
                ),
              ).then((_) => loadBarang());
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.add, color: Colors.white),
                      SizedBox(width: 12),
                      Text(
                        'Tambah Barang Baru',
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
      ),
    );
  }
}
