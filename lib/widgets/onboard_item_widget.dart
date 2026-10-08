import 'package:flutter/material.dart';
import 'package:jastiptrack/models/onboard_item.dart';

class OnboardItemWidget extends StatelessWidget {
  const OnboardItemWidget({super.key, required this.item});

  final OnboardItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Image.asset(item.image),
        Image.asset(
          item.image,
          height: 444,
          fit: BoxFit.fill,
        ),
        //SizedBox(height: 20),
        Text(
          item.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: const Color(0xFF5FA6F4),
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: 302,
          child: Text(
            item.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontFamily: 'Poppins',
              color: const Color(0xFF0BE5CC),
            ),
          ),
        ),
      ],
    );
  }
}
