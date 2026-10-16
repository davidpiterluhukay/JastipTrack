import 'package:flutter/material.dart';
import '../controllers/staff_controller.dart';
import '../models/barang.dart';
import '../models/pengiriman_kargo.dart';

class MuatBarangView extends StatefulWidget {
  final PengirimanKargo kargo;

  const MuatBarangView({super.key, required this.kargo});

  @override
  State<MuatBarangView> createState() => _MuatBarangViewState();
}

class _MuatBarangViewState extends State<MuatBarangView> {
  final StaffController controller = StaffController();

  List<Barang> daftarBarang = [];
  final Set<int> barangTerpilih = {};

  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadBarang();
  }

  Future<void> _loadBarang() async {
    try {
      final data = await controller.getBarang(status: 'Diterima Jastip');

      if (!mounted) return;

      setState(() {
        daftarBarang = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengambil daftar barang')),
      );
    }
  }

  Future<void> _muatBarang() async {
    if (barangTerpilih.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih minimal satu barang')),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    final berhasil = await controller.muatBarang(
      idPengiriman: widget.kargo.idPengiriman,
      barangIds: barangTerpilih.toList(),
    );

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (berhasil) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Barang berhasil dimuat ke kargo')),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat barang ke kargo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Muat Barang : ${widget.kargo.noResiKargo}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : daftarBarang.isEmpty
          ? const Center(child: Text('Tidak ada barang yang dapat dimuat'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: daftarBarang.length,
              itemBuilder: (context, index) {
                final barang = daftarBarang[index];

                final dipilih = barangTerpilih.contains(barang.idBarang);

                return Card(
                  child: CheckboxListTile(
                    value: dipilih,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          barangTerpilih.add(barang.idBarang);
                        } else {
                          barangTerpilih.remove(barang.idBarang);
                        }
                      });
                    },
                    title: Text(
                      barang.noInvoice,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Resi: ${barang.noResiToko}'),
                        Text(
                          'Customer: '
                          '${barang.customer?.namaCustomer ?? '-'}',
                        ),
                        Text(
                          'Toko: '
                          '${barang.toko?.namaToko ?? '-'}',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: isLoading || daftarBarang.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isSaving ? null : _muatBarang,
                    icon: isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.local_shipping),
                    label: Text(
                      isSaving
                          ? 'Memproses...'
                          : 'Muat ${barangTerpilih.length} Barang',
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
