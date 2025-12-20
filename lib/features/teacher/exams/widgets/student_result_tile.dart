import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'student_result_detail_modal.dart';

class StudentResultTile extends StatelessWidget {
  final dynamic item;

  const StudentResultTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('HH:mm dd/MM');
    final student = item.student;
    final result = item.result;

    final name = student?.fullName ?? 'Sinh viên ẩn';
    final avatarChar = name.isNotEmpty ? name[0] : '?';
    final isUnknown = student == null;

    final score = result.score;
    final scoreColor =
        score >= 8 ? Colors.green : (score < 5 ? Colors.red : Colors.orange);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => showStudentResultDetail(context, item),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor:
                  isUnknown ? Colors.grey.shade300 : Colors.blue.shade100,
              child: Text(
                avatarChar,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color:
                      isUnknown ? Colors.grey : Colors.blue.shade800,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isUnknown ? Colors.grey : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${dateFormat.format(result.submittedAt)}'
                    '${result.isLate ? ' (Muộn)' : ''}',
                    style: TextStyle(
                      fontSize: 13,
                      color:
                          result.isLate ? Colors.red : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: scoreColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${result.score}/${result.maxScore}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: scoreColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
