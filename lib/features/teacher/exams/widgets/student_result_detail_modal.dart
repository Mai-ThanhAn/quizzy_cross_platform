import 'package:flutter/material.dart';

void showStudentResultDetail(BuildContext context, dynamic item) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Chi tiết bài làm',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              itemCount: item.result.answers.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 12),
              itemBuilder: (context, index) {
                final ans = item.result.answers[index];
                return Row(
                  children: [
                    Icon(
                      ans.isCorrect
                          ? Icons.check_circle_outline
                          : Icons.cancel_outlined,
                      color:
                          ans.isCorrect ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Câu ${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Text(
                      ans.isCorrect ? 'Đúng' : 'Sai',
                      style: TextStyle(
                        color:
                            ans.isCorrect ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}
