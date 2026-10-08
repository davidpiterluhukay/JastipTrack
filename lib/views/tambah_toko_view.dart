import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TambahTokoView extends StatefulWidget {
  const TambahTokoView({super.key});

  @override
  State<TambahTokoView> createState() => _TambahTokoViewState();
}

class _TambahTokoViewState extends State<TambahTokoView> {
  final ApiService api = ApiService();
  final TextEditingController namaController = TextEditingController();

  bool isLoading = false;

  Future<void> _simpanToko() async {
    if (namaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nama toko wajib diisi')));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await api.post('/api/staf/toko', {
        'nama_toko': namaController.text.trim(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Toko berhasil ditambahkan')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menambahkan toko: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    namaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Toko'),
        leading: Image.asset('assets/images/logo.png'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Toko',
                hintText: 'Contoh: Uniqlo',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.store),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : _simpanToko,
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(isLoading ? 'Menyimpan...' : 'Simpan Toko'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
