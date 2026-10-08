// ignore: file_names
import 'package:flutter/material.dart';
import 'login_view.dart';
import 'registrasi_customer_view.dart';

class OnboardingEndView extends StatefulWidget {
  const OnboardingEndView({super.key});

  @override
  State<OnboardingEndView> createState() => _OnboardingEndViewState();
}

class _OnboardingEndViewState extends State<OnboardingEndView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: Column(children: [
          Opacity(
            opacity: 0.25, // 25% Opacity
            child: Image.asset(
              'assets/images/Topilustration.png',
            ),
          ),
          Image.asset(
            'assets/images/ilustration4.png',
            height: 444,
          ),
          Text(
            'Mulai Perjalanan Jastipmu',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: const Color(0xFF5FA6F4),
            ),
          ),
          // SizedBox(height: 10),
          SizedBox(
            width: 302,
            child: Text(
              'Jelajahi aplikasi terlebih dahulu, atau buat akun untuk mulai mengelola pesanan jastip dengan lebih mudah.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontFamily: 'Poppins',
                color: const Color(0xFF0BE5CC),
              ),
            ),
          ),
          SizedBox(height: 60),
          SizedBox(
            width: 330,
            child: FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegistrasiCustomerView(),
                  ),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF5FA6F4),
                padding: const EdgeInsets.symmetric(vertical: 20),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: Text(
                'langsung Daftar',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

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
              style: TextStyle(color: Color.fromARGB(255, 19, 188, 165)),
            ),
          ),
        ]),
      ),
    );
  }
}
