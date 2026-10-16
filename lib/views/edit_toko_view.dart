import 'package:flutter/material.dart';
import '../models/toko.dart';
import '../services/api_service.dart';

class EditTokoView extends StatefulWidget {
  final Toko toko;

  const EditTokoView({super.key, required this.toko});

  @override
  State<EditTokoView> createState() => _EditTokoViewState();
}

class _EditTokoViewState extends State<EditTokoView> {
  final ApiService api = ApiService();
  late TextEditingController namaController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    namaController = TextEditingController(text: widget.toko.namaToko);
  }

  Future<void> _updateToko() async {
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
      await api.put('/api/staf/toko/${widget.toko.idToko}', {
        'nama_toko': namaController.text.trim(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Toko berhasil diperbarui')));

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memperbarui toko: $e')));
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
        title: const Text('Edit Toko'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Toko',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.store),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : _updateToko,
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(isLoading ? 'Menyimpan...' : 'Simpan Perubahan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
