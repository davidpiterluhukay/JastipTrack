import 'package:flutter/material.dart';
import 'package:jastiptrack/widgets/onboard_item_widget.dart';
import '../models/onboard_item.dart';
import 'onboardingEnd_view.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  final List<OnboardItem> _pages = [
    OnboardItem(
      image: 'assets/images/ilustration1.png',
      title: 'Kelola Pesanan Jastip Lebih Mudah',
      description:
          'Catat semua request barang, daftar belanja, dan status pembayaran dengan rapi dalam satu aplikasi.',
    ),
    OnboardItem(
      image: 'assets/images/ilustration2.png',
      title: 'Pantau Status Real Time',
      description:
          'Update status barang real time, mulai dari "dibeli", "dipacking", hingga "dikirim" agar pembeli selalu mendapat info terbaru.',
    ),
    OnboardItem(
      image: 'assets/images/ilustration3.png',
      title: 'Siap Kembangkan Bisnis Jastipmu?',
      description:
          'Daftar sekarang untuk mengatur pesanan lebih efisien dan berikan pelayanan terbaik untuk pelangganmu.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => OnboardingEndView()),
      );
      // Handle the last page action, e.g., navigate to another screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: Column(spacing: 20, children: [
          Image.asset(
            'assets/images/Topilustration.png',
          ),
          Flexible(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (value) => setState(() {
                _currentPage = value;
              }),
              itemBuilder: (context, index) {
                return OnboardItemWidget(item: _pages[index]);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: List.generate(
              _pages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _currentPage == index ? 30 : 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? const Color(0xFF5FA6F4)
                      : const Color(0xFF0BE5CC),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 330,
            child: FilledButton(
              onPressed: _next,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF5FA6F4),
                padding: const EdgeInsets.symmetric(vertical: 20),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: Text(
                _currentPage == _pages.length - 1 ? 'Mulai' : 'Selanjutnya',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
