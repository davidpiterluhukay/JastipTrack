import 'package:flutter/material.dart';
import 'edit_toko_view.dart';

import '../controllers/staff_controller.dart';
import '../models/toko.dart';
import 'tambah_toko_view.dart';

class DaftarTokoView extends StatefulWidget {
  const DaftarTokoView({super.key});

  @override
  State<DaftarTokoView> createState() => _DaftarTokoViewState();
}

class _DaftarTokoViewState extends State<DaftarTokoView> {
  final StaffController controller = StaffController();

  List<Toko> daftarToko = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadToko();
  }

  Future<void> _loadToko() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await controller.getToko();

      if (!mounted) return;

      setState(() {
        daftarToko = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = 'Gagal mengambil daftar toko';
      });
    }
  }

  Future<void> _hapusToko(Toko toko) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Toko'),
          content: Text(
            'Apakah Anda yakin ingin menghapus toko "${toko.namaToko}"?',
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

    final berhasil = await controller.hapusToko(toko.idToko);

    if (!mounted) return;

    if (berhasil) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Toko berhasil dihapus')));

      _loadToko();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal menghapus toko')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Toko'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: RefreshIndicator(onRefresh: _loadToko, child: _buildBody()),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahTokoView()),
          );

          if (result == true) {
            _loadToko();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Toko'),
      ),
    );
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
                  onPressed: _loadToko,
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (daftarToko.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 100),
          Center(
            child: Column(
              children: [
                Icon(Icons.store_outlined, size: 60, color: Colors.grey),
                SizedBox(height: 10),
                Text('Belum ada toko'),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: daftarToko.length,
      itemBuilder: (context, index) {
        final toko = daftarToko[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.store)),

            title: Text(
              toko.namaToko,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            subtitle: Text('ID Toko: ${toko.idToko}'),

            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditTokoView(toko: toko),
                      ),
                    );

                    if (result == true) {
                      _loadToko();
                    }
                  },
                ),

                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _hapusToko(toko);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
