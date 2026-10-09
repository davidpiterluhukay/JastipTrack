import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'login_view.dart';

class RegistrasiCustomerView extends StatefulWidget {
  const RegistrasiCustomerView({super.key});

  @override
  State<RegistrasiCustomerView> createState() => _RegistrasiCustomerViewState();
}

class _RegistrasiCustomerViewState extends State<RegistrasiCustomerView> {
  final AuthController controller = AuthController();

  final namaController = TextEditingController();
  final noHpController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  Future<void> _register() async {
    if (namaController.text.trim().isEmpty ||
        noHpController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Semua data wajib diisi')));
      return;
    }

    setState(() {
      isLoading = true;
    });

    final berhasil = await controller.register(
      namaCustomer: namaController.text.trim(),
      noHp: noHpController.text.trim(),
      password: passwordController.text,
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (berhasil) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registrasi berhasil')));

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrasi gagal. Nomor HP mungkin sudah terdaftar.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    namaController.dispose();
    noHpController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Opacity(
            opacity: 0.25, // 25% Opacity
            child: Image.asset(
              'assets/images/Topilustration.png',
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 40),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 30),
                          Text(
                            'Registrasi Customer',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                              color: Color(0xFF5FA6F4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 302,
                            child: Text(
                              'Buat akun untuk mencatat pesanan, memantau pengiriman, dan melayani pelanggan dengan lebih mudah.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 10,
                                fontFamily: 'Poppins',
                                color: Color(0xFF0BE5CC),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: 312,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment
                              .start, // Starts child widgets at the very top
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: namaController,
                              decoration: InputDecoration(
                                labelText: 'Nama Customer',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2.0,
                                  ),
                                ),
                                prefixIcon: const Icon(Icons.person),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: noHpController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Nomor HP',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2.0,
                                  ),
                                ),
                                prefixIcon: const Icon(Icons.phone),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: passwordController,
                              obscureText: obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2.0,
                                  ),
                                ),
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 40),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 312,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5FA6F4),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                textStyle: const TextStyle(fontSize: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'Daftar',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          // const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginView(),
                                ),
                              );
                            },
                            child: const Text(
                              'Sudah memiliki akun? Masuk',
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Poppins',
                                color: Color.fromARGB(255, 19, 188, 165),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
