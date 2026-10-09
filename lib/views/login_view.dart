import 'package:flutter/material.dart';
import 'customer_dashboard_view.dart';
import 'staff_dashboard_view.dart';
import '../controllers/auth_controller.dart';
import 'registrasi_customer_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthController controller = AuthController();

  final TextEditingController noHpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  Future<void> login() async {
    if (noHpController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No HP dan password wajib diisi')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final berhasil = await controller.login(
      noHpController.text.trim(),
      passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (!mounted) return;

    if (berhasil) {
      final role = controller.getRole();

      if (role == 'customer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const CustomerDashboardView(),
          ),
        );
      } else if (role == 'staf') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StaffDashboardView()),
        );
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Akun belum terdaftar')));
    }
  }

  @override
  void dispose() {
    noHpController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 40, bottom: 20),
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/logo2.png',
                width: 240,
                height: 50,
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/images/logo3.png',
                  width: 150,
                  height: 220,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 30, top: 10),
              alignment: Alignment.center,
              child: SizedBox(
                width: 312, // Keeps everything perfectly uniform at 312px
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Input Nomor HP
                    TextField(
                      controller: noHpController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'No HP',
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

                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: isLoading ? null : login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5FA6F4),
                        padding: const EdgeInsets.symmetric(vertical: 20),
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
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'LOGIN',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),

                    const SizedBox(height: 12),

                    // Tombol Registrasi
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegistrasiCustomerView(),
                          ),
                        );
                      },
                      child: const Text(
                        'Belum punya akun? Daftar',
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
