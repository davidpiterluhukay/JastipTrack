import 'package:flutter/material.dart';
import '../controllers/staff_controller.dart';
import '../models/jastip_tujuan.dart';

class TambahPengirimanKargoView extends StatefulWidget {
  const TambahPengirimanKargoView({super.key});

  @override
  State<TambahPengirimanKargoView> createState() =>
      _TambahPengirimanKargoViewState();
}

class _TambahPengirimanKargoViewState extends State<TambahPengirimanKargoView> {
  final StaffController controller = StaffController();

  final noResiController = TextEditingController();

  List<JastipTujuan> daftarJastip = [];
  JastipTujuan? jastipTerpilih;

  DateTime tanggalKirim = DateTime.now();

  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadJastip();
  }

  Future<void> _loadJastip() async {
    try {
      final data = await controller.getJastipTujuan();

      if (!mounted) return;

      setState(() {
        daftarJastip = data;
        isLoading = false;

        if (data.isNotEmpty) {
          jastipTerpilih = data.first;
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengambil daftar jastip tujuan')),
      );
    }
  }

  Future<void> _pilihTanggal() async {
    final hasil = await showDatePicker(
      context: context,
      initialDate: tanggalKirim,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (hasil != null) {
      setState(() {
        tanggalKirim = DateTime(
          hasil.year,
          hasil.month,
          hasil.day,
          tanggalKirim.hour,
          tanggalKirim.minute,
        );
      });
    }
  }

  String _formatTanggal(DateTime tanggal) {
    return '${tanggal.year}-'
        '${tanggal.month.toString().padLeft(2, '0')}-'
        '${tanggal.day.toString().padLeft(2, '0')} '
        '${tanggal.hour.toString().padLeft(2, '0')}:'
        '${tanggal.minute.toString().padLeft(2, '0')}:00';
  }

  String _formatTanggalTampilan(DateTime tanggal) {
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

    return '${tanggal.day} '
        '${namaBulan[tanggal.month - 1]} '
        '${tanggal.year}, '
        '${tanggal.hour.toString().padLeft(2, '0')}:'
        '${tanggal.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _simpan() async {
    if (jastipTerpilih == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih jastip tujuan terlebih dahulu')),
      );
      return;
    }

    if (noResiController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nomor resi kargo wajib diisi')),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    final berhasil = await controller.tambahPengirimanKargo(
      idJastip: jastipTerpilih!.idJastip,
      noResiKargo: noResiController.text.trim(),
      tanggalKirim: _formatTanggal(tanggalKirim),
    );

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (berhasil) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengiriman kargo berhasil ditambahkan')),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menambahkan pengiriman kargo')),
      );
    }
  }

  @override
  void dispose() {
    noResiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pengiriman Kargo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  DropdownButtonFormField<JastipTujuan>(
                    initialValue: jastipTerpilih,
                    decoration: const InputDecoration(
                      labelText: 'Jastip Tujuan',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    items: daftarJastip.map((jastip) {
                      return DropdownMenuItem<JastipTujuan>(
                        value: jastip,
                        child: Text(jastip.namaJastip),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        jastipTerpilih = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: noResiController,
                    decoration: const InputDecoration(
                      labelText: 'No. Resi Kargo',
                      hintText: 'Contoh: CARGO-JKT-0002',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.local_shipping),
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _pilihTanggal,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Tanggal Kirim',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(_formatTanggalTampilan(tanggalKirim)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isSaving ? null : _simpan,
                      icon: isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: Text(
                        isSaving ? 'Menyimpan...' : 'Simpan Pengiriman',
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
