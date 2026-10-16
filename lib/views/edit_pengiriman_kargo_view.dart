import 'package:flutter/material.dart';
import '../controllers/staff_controller.dart';
import '../models/pengiriman_kargo.dart';

class EditPengirimanKargoView extends StatefulWidget {
  final PengirimanKargo kargo;

  const EditPengirimanKargoView({super.key, required this.kargo});

  @override
  State<EditPengirimanKargoView> createState() =>
      _EditPengirimanKargoViewState();
}

class _EditPengirimanKargoViewState extends State<EditPengirimanKargoView> {
  final StaffController controller = StaffController();

  late TextEditingController noResiController;

  late DateTime tanggalKirim;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    noResiController = TextEditingController(text: widget.kargo.noResiKargo);

    tanggalKirim = widget.kargo.tanggalKirim.toLocal();
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

  Future<void> _simpan() async {
    if (noResiController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nomor resi kargo wajib diisi')),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    final berhasil = await controller.updatePengirimanKargo(
      idPengiriman: widget.kargo.idPengiriman,
      noResiKargo: noResiController.text.trim(),
      tanggalKirim: _formatTanggal(tanggalKirim),
    );

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (berhasil) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengiriman kargo berhasil diperbarui')),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui pengiriman kargo')),
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
        title: const Text('Edit Pengiriman Kargo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: noResiController,
              decoration: const InputDecoration(
                labelText: 'No. Resi Kargo',
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
                label: Text(isSaving ? 'Menyimpan...' : 'Simpan Perubahan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
