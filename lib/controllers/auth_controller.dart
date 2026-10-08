import 'package:get_storage/get_storage.dart';
import '../services/api_service.dart';

class AuthController {
  final ApiService api = ApiService();
  final GetStorage storage = GetStorage();

  Future<bool> login(String noHp, String password) async {
    try {
      final response = await api.post('/api/auth/login', {
        'no_hp': noHp,
        'password': password,
      });

      final data = response['data'];

      await storage.write('access_token', data['access_token']);

      await storage.write('role', data['role']);

      await storage.write('user', data['user']);

      return true;
    } catch (e) {
      print('Login gagal: $e');
      return false;
    }
  }

  Future<bool> register({
    required String namaCustomer,
    required String noHp,
    required String password,
  }) async {
    try {
      await api.post('/api/auth/register', {
        'nama_customer': namaCustomer,
        'no_hp': noHp,
        'password': password,
        'password_confirmation': password,
      });

      return true;
    } catch (e) {
      print('Registrasi gagal: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await storage.remove('access_token');
    await storage.remove('role');
    await storage.remove('user');
  }

  bool isLoggedIn() {
    final token = storage.read('access_token');

    return token != null && token.toString().isNotEmpty;
  }

  String? getRole() {
    return storage.read('role');
  }

  dynamic getUser() {
    return storage.read('user');
  }
}
