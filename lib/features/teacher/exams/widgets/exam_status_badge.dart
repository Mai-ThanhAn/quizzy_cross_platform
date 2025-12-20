import 'package:flutter/material.dart';

class ExamStatusBadge extends StatelessWidget {
  final String status;
  final VoidCallback? onTap;

  const ExamStatusBadge({
    super.key,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPublished = status == 'published';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isPublished
              ? Colors.green.shade50
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPublished
                  ? Icons.check_circle_outline
                  : Icons.edit_note_outlined,
              size: 16,
              color: isPublished
                  ? Colors.green.shade700
                  : Colors.grey.shade700,
            ),
            const SizedBox(width: 4),
            Text(
              isPublished ? 'Đang mở' : 'Nháp',
              style: TextStyle(
                color: isPublished
                    ? Colors.green.shade700
                    : Colors.grey.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
