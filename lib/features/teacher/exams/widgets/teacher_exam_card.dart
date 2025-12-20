import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quizzy_cross_platform/data/models/quizzes_model.dart';

class TeacherExamCard extends StatelessWidget {
  final QuizModel quiz;
  final VoidCallback onTap;

  const TeacherExamCard({super.key, required this.quiz, required this.onTap});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'published':
        return Colors.green;
      case 'closed':
        return Colors.red;
      default:
        return Colors.grey;
      }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'published':
        return 'Đang mở';
      case 'closed':
        return 'Đã đóng';
      default:
        return 'Nháp';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(quiz.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16), // Tăng khoảng cách giữa các thẻ
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Bo góc mềm mại hơn
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // Bóng rất nhẹ
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Padding rộng rãi
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Header: Status & Duration ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Status Badge (Capsule Style)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1), // Nền nhạt
                        borderRadius: BorderRadius.circular(30), // Bo tròn viên thuốc
                      ),
                      child: Text(
                        _getStatusText(quiz.status),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    // Duration with Icon
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded, size: 16, color: Colors.blueAccent),
                        const SizedBox(width: 4),
                        Text(
                          '${quiz.settings.durationMinutes} phút',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // --- Title ---
                Text(
                  quiz.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.3, // Tăng khoảng cách dòng
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 12),
                
                // --- Footer: Date ---
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 16, color: Colors.grey[400]),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Bắt đầu: ${DateFormat.MMMMEEEEd('vi_VN').format(quiz.settings.startTime)}',
                        style: TextStyle(
                          fontSize: 13, 
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    // Mũi tên chỉ dẫn nhỏ
                    Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey[300]),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}