import 'package:flutter/material.dart';
import 'package:jastiptrack/views/detail_pengiriman_kargo_view.dart';
import 'package:jastiptrack/views/muat_barang_view.dart' show MuatBarangView;
import 'edit_pengiriman_kargo_view.dart';
import '../controllers/staff_controller.dart';
import '../models/pengiriman_kargo.dart';
import 'tambah_pengiriman_kargo_view.dart';

class DaftarPengirimanKargoView extends StatefulWidget {
  const DaftarPengirimanKargoView({super.key});

  @override
  State<DaftarPengirimanKargoView> createState() =>
      _DaftarPengirimanKargoViewState();
}

class _DaftarPengirimanKargoViewState extends State<DaftarPengirimanKargoView> {
  final StaffController controller = StaffController();

  List<PengirimanKargo> daftarKargo = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadKargo();
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

  Future<void> _loadKargo() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await controller.getPengirimanKargo();

      if (!mounted) return;

      setState(() {
        daftarKargo = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = 'Gagal mengambil data pengiriman kargo';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TambahPengirimanKargoView(),
            ),
          );

          if (result == true) {
            _loadKargo();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Kargo'),
      ),
      appBar: AppBar(
        title: const Text('Pengiriman Kargo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: RefreshIndicator(onRefresh: _loadKargo, child: _buildBody()),
    );
  }

  Future<void> _hapusKargo(PengirimanKargo kargo) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Pengiriman Kargo'),
          content: Text(
            'Apakah Anda yakin ingin menghapus '
            'pengiriman "${kargo.noResiKargo}"?',
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
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (konfirmasi != true) return;

    final berhasil = await controller.hapusPengirimanKargo(kargo.idPengiriman);

    if (!mounted) return;

    if (berhasil) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengiriman kargo berhasil dihapus')),
      );

      _loadKargo();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus pengiriman kargo')),
      );
    }
  }

  Widget _buildBody() {
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
                Text(errorMessage!),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _loadKargo,
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (daftarKargo.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 100),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.local_shipping_outlined,
                  size: 60,
                  color: Colors.grey,
                ),
                SizedBox(height: 10),
                Text('Belum ada pengiriman kargo'),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: daftarKargo.length,
      itemBuilder: (context, index) {
        final kargo = daftarKargo[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.local_shipping)),

            title: Text(
              kargo.noResiKargo,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),

                //Text('ID Pengiriman: ${kargo.idPengiriman}'),
                Text('Jastip Tujuan: ${kargo.namaJastip ?? '-'}'),

                Text('Alamat: ${kargo.alamatJastip ?? '-'}'),

                Text('Tanggal Kirim: ${_formatTanggal(kargo.tanggalKirim)}'),

                Text(
                  'Tanggal Tiba: ${kargo.tanggalTiba != null ? _formatTanggal(kargo.tanggalTiba!) : 'Belum tiba'}',
                ),
              ],
            ),

            trailing: PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'detail') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailPengirimanKargoView(kargo: kargo),
                    ),
                  );
                }

                if (value == 'muat') {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MuatBarangView(kargo: kargo),
                    ),
                  );

                  if (result == true) {
                    _loadKargo();
                  }
                }

                if (value == 'edit') {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditPengirimanKargoView(kargo: kargo),
                    ),
                  );

                  if (result == true) {
                    _loadKargo();
                  }
                }

                if (value == 'hapus') {
                  _hapusKargo(kargo);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'detail',
                  child: Row(
                    children: [
                      Icon(Icons.visibility),
                      SizedBox(width: 10),
                      Text('Detail'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'muat',
                  child: Row(
                    children: [
                      Icon(Icons.inventory_2),
                      SizedBox(width: 10),
                      Text('Muat Barang'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 10),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'hapus',
                  child: Row(
                    children: [
                      Icon(Icons.delete),
                      SizedBox(width: 10),
                      Text('Hapus'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
