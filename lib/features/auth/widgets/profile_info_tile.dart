import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/core/constants/colors.dart';

class ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final bool enabled;

  const ProfileInfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.controller,
    this.enabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.iconbackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.blue, size: 25),
          ),

          const SizedBox(width: 12),

          // Label
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.mainfont,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Input
          Expanded(
            child: TextFormField(
              controller: controller,
              enabled: enabled,
              style: const TextStyle(fontSize: 14, color: AppColors.mainfont),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(color: AppColors.hintfont),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
