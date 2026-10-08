import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'login_view.dart';
import 'package:jastiptrack/views/onboarding_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final GetStorage storage = GetStorage();

  double sx = 0, sy = 0;

  @override
  void initState() {
    super.initState();
    _cekSession();
  }

  void _cekSession() {
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      final token = storage.read('access_token');
      final role = storage.read('role');

      if (token != null && token.toString().isNotEmpty) {
        if (role == 'customer') {
          // Nanti diarahkan ke CustomerDashboardView
          // Untuk sementara kembali ke LoginView
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginView()),
          );
        } else if (role == 'staf') {
          // Nanti diarahkan ke StaffDashboardView
          // Untuk sementara kembali ke LoginView
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginView()),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingView()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    sx = MediaQuery.of(context).size.width;
    sy = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: sx * 90 / 100,
          height: sy * 80 / 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 130,
                height: 170,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo3.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo2.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
