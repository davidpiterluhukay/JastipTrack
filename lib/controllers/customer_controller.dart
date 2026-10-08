import '../models/customer_tracking.dart';
import '../services/api_service.dart';

class CustomerController {
  final ApiService api = ApiService();

  Future<List<CustomerTracking>> getTrackingBarang() async {
    try {
      final response = await api.get('/api/customer/tracking');

      final List<dynamic> items = response['data'] ?? [];

      return items.map((item) => CustomerTracking.fromJson(item)).toList();
    } catch (e) {
      print('Gagal mengambil tracking barang: $e');
      rethrow;
    }
  }

  Future<CustomerTracking> getDetailBarang(int idBarang) async {
    try {
      final response = await api.get('/api/customer/tracking/$idBarang');

      return CustomerTracking.fromJson(response['data']);
    } catch (e) {
      print('Gagal mengambil detail barang: $e');
      rethrow;
    }
  }
}
