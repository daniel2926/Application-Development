import 'package:flutter/material.dart';
import 'package:flutter_pad_1/constants/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final bool isAvailable;

  const StatusBadge({super.key, required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isAvailable ? active : inActive, 
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isAvailable ? 'For Sale' : 'Sold Out',
        style: badgetText, // Predefined style
      ),
    );
  }
}