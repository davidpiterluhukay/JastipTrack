import '../services/api_service.dart';
import '../models/customer.dart';
import '../models/toko.dart';
import '../models/barang.dart';
import '../models/pengiriman_kargo.dart';
import '../models/jastip_tujuan.dart';

class StaffController {
  final ApiService api = ApiService();

  Future<Map<String, dynamic>> getDashboardSummary() async {
    try {
      final response = await api.get('/api/staf/dashboard/summary');

      return response['data'] ?? {};
    } catch (e) {
      print('Gagal mengambil dashboard staf: $e');
      rethrow;
    }

    /*
    try {
      final response = await api.get('/api/staf/dashboard/summary');

      print('RESPONSE DASHBOARD: $response');

      return response['data'] ?? {};
    } catch (e) {
      print('Gagal mengambil dashboard staf: $e');
      rethrow;
    }
    */
  }

  Future<bool> tambahBarang({
    required int idCustomer,
    required int idToko,
    required String noInvoice,
    required String noResiToko,
    required String tanggalDiterima,
  }) async {
    try {
      await api.post('/api/staf/barang', {
        'id_customer': idCustomer,
        'id_toko': idToko,
        'no_invoice': noInvoice,
        'no_resi_toko': noResiToko,
        'tanggal_diterima': tanggalDiterima,
      });

      return true;
    } catch (e) {
      print('Gagal menambah barang: $e');
      return false;
    }
  }

  Future<List<Customer>> getCustomers() async {
    try {
      final response = await api.get('/api/staf/customer');

      final List<dynamic> items = response['data'] ?? [];

      return items.map((item) => Customer.fromJson(item)).toList();
    } catch (e) {
      print('Gagal mengambil daftar customer: $e');
      rethrow;
    }
  }

  Future<List<Toko>> getToko() async {
    try {
      final response = await api.get('/api/staf/toko');

      final List<dynamic> items = response['data'] ?? [];

      return items.map((item) => Toko.fromJson(item)).toList();
    } catch (e) {
      print('Gagal mengambil daftar toko: $e');
      rethrow;
    }
  }

  Future<List<Barang>> getBarang({String? status, String? search}) async {
    try {
      String endpoint = '/api/staf/barang';

      final params = <String, String>{};

      if (status != null && status.isNotEmpty) {
        params['status'] = status;
      }

      if (search != null && search.isNotEmpty) {
        params['search'] = search;
      }

      if (params.isNotEmpty) {
        endpoint += '?${Uri(queryParameters: params).query}';
      }

      final response = await api.get(endpoint);

      final List<dynamic> items = response['data'] ?? [];

      print('RESPONSE BARANG: $response');

      return items.map((item) => Barang.fromJson(item)).toList();
    } catch (e) {
      print('Gagal mengambil daftar barang: $e');
      rethrow;
    }
  }

  Future<bool> hapusToko(int idToko) async {
    try {
      await api.delete('/api/staf/toko/$idToko');
      return true;
    } catch (e) {
      print('Gagal menghapus toko: $e');
      return false;
    }
  }

  Future<bool> kirimKeKargo({
    required int idBarang,
    required int idPengiriman,
  }) async {
    try {
      await api.patch('/api/staf/barang/$idBarang/kirim-kargo', {
        'id_pengiriman': idPengiriman,
      });

      return true;
    } catch (e) {
      print('Gagal mengirim barang ke kargo: $e');
      return false;
    }
  }

  Future<bool> tandaiTiba({required int idBarang, String? tanggalTiba}) async {
    try {
      await api.patch(
        '/api/staf/barang/$idBarang/tiba',
        tanggalTiba != null ? {'tanggal_tiba': tanggalTiba} : null,
      );

      return true;
    } catch (e) {
      print('Gagal menandai barang tiba: $e');
      return false;
    }
  }

  Future<List<JastipTujuan>> getJastipTujuan() async {
    try {
      final response = await api.get('/api/staf/jastip-tujuan');

      final List<dynamic> items = response['data'] ?? [];

      return items.map((item) => JastipTujuan.fromJson(item)).toList();
    } catch (e) {
      print('Gagal mengambil daftar jastip tujuan: $e');
      rethrow;
    }
  }

  Future<bool> tambahPengirimanKargo({
    required int idJastip,
    required String noResiKargo,
    required String tanggalKirim,
  }) async {
    try {
      await api.post('/api/staf/kargo', {
        'id_jastip': idJastip,
        'no_resi_kargo': noResiKargo,
        'tanggal_kirim': tanggalKirim,
      });

      return true;
    } catch (e) {
      print('Gagal menambah pengiriman kargo: $e');
      return false;
    }
  }

  Future<bool> serahkanKeCustomer({required int idBarang}) async {
    try {
      await api.patch('/api/staf/barang/$idBarang/serahkan-customer');

      return true;
    } catch (e) {
      print('Gagal menyerahkan barang ke customer: $e');
      return false;
    }
  }

  Future<List<PengirimanKargo>> getPengirimanKargo() async {
    try {
      final response = await api.get('/api/staf/kargo');

      print('=== RESPONSE KARGO ===');
      print(response);

      final List<dynamic> items = response['data'] ?? [];

      return items.map((item) => PengirimanKargo.fromJson(item)).toList();
    } catch (e) {
      print('Gagal mengambil daftar pengiriman kargo: $e');
      rethrow;
    }
  }

  Future<bool> hapusPengirimanKargo(int idPengiriman) async {
    try {
      await api.delete('/api/staf/kargo/$idPengiriman');

      return true;
    } catch (e) {
      print('Gagal menghapus pengiriman kargo: $e');
      return false;
    }
  }

  Future<bool> muatBarang({
    required int idPengiriman,
    required List<int> barangIds,
  }) async {
    try {
      await api.post('/api/staf/kargo/$idPengiriman/muat-barang', {
        'barang_ids': barangIds,
      });

      return true;
    } catch (e) {
      print('Gagal memuat barang ke kargo: $e');
      return false;
    }
  }

  /*

  Future<Map<String, dynamic>> getDetailPengirimanKargo(
    int idPengiriman,
  ) async {
    try {
      final response = await api.get('/api/staf/kargo/$idPengiriman');

      return response['data'] ?? {};
    } catch (e) {
      print('Gagal mengambil detail kargo: $e');
      rethrow;
    }
  }
*/
  Future<Map<String, dynamic>> getDetailPengirimanKargo(
    int idPengiriman,
  ) async {
    try {
      final response = await api.get('/api/staf/kargo/$idPengiriman');

      print('=== DETAIL KARGO ===');
      print(response);

      return response['data'] ?? {};
    } catch (e) {
      print('Gagal mengambil detail kargo: $e');
      rethrow;
    }
  }

  Future<bool> updatePengirimanKargo({
    required int idPengiriman,
    required String noResiKargo,
    required String tanggalKirim,
  }) async {
    try {
      await api.put('/api/staf/kargo/$idPengiriman', {
        'no_resi_kargo': noResiKargo,
        'tanggal_kirim': tanggalKirim,
      });

      return true;
    } catch (e) {
      print('Gagal memperbarui pengiriman kargo: $e');
      return false;
    }
  }

  Future<bool> tandaiSemuaBarangTiba(List<int> barangIds) async {
    try {
      for (final idBarang in barangIds) {
        await api.patch('/api/staf/barang/$idBarang/tiba');
      }

      return true;
    } catch (e) {
      print('Gagal menandai semua barang tiba: $e');
      return false;
    }
  }
}
