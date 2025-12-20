import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quizzy_cross_platform/data/models/quizzes_model.dart';
import 'package:quizzy_cross_platform/features/student/home/viewmodel/student_home_viewmodel.dart';
import 'package:quizzy_cross_platform/features/student/quiz/view/do_quiz_screen.dart';
import 'package:quizzy_cross_platform/features/student/quiz/view/student_class_detail_screen.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentHomeViewModel>().loadDashboard();
    });
  }

  // Helper tạo Gradient ngẫu nhiên
  List<Color> _getGradient(int index) {
    const gradients = [
      [Color(0xFF4A90E2), Color(0xFF00296B)],
      [Color(0xFF11998E), Color(0xFF38EF7D)],
      [Color(0xFFFF512F), Color(0xFFDD2476)],
      [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
    ];
    return gradients[index % gradients.length];
  }

  // Helper tạo màu background cho lớp học
  Color _getClassColor(int index) {
    const colors = [
      Color(0xFFE3F2FD),
      Color(0xFFFFEBEE),
      Color(0xFFE8F5E9),
      Color(0xFFFFF3E0)
    ];
    return colors[index % colors.length];
  }

  Color _getIconColor(int index) {
    const colors = [
      Color(0xFF1E88E5),
      Color(0xFFE53935),
      Color(0xFF43A047),
      Color(0xFFFB8C00)
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StudentHomeViewModel>();
    final dateFormat = DateFormat('HH:mm dd/MM');

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: () => vm.loadDashboard(),
                color: Colors.blueAccent,
                backgroundColor: Colors.white,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Xin chào,",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                vm.userName,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundImage: vm.avatarUrl != null
                                      ? NetworkImage(vm.avatarUrl!)
                                      : null,
                                  backgroundColor: Colors.blue.shade50,
                                  child: vm.avatarUrl == null
                                      ? const Icon(Icons.person, color: Colors.blueAccent)
                                      : null,
                                ),
                              ),
                              if (vm.upcomingExams.any((q) => vm.isUrgent(q)))
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search_rounded, color: Colors.grey),
                            hintText: "Tìm kiếm khóa học, bài thi...",
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      const _SectionTitle(title: "Sắp diễn ra"),
                      const SizedBox(height: 16),

                      if (vm.upcomingExams.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.event_available_rounded, size: 40, color: Colors.blueAccent.withOpacity(0.5)),
                              const SizedBox(height: 8),
                              const Text("Không có bài kiểm tra nào sắp tới", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        )
                      else
                        SizedBox(
                          height: 180,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: vm.upcomingExams.length,
                            itemBuilder: (context, index) {
                              final quiz = vm.upcomingExams[index];
                              final gradient = _getGradient(index);
                              final isUrgent = vm.isUrgent(quiz);

                              return GestureDetector(
                                onTap: () => _showStartQuizDialog(context, quiz),
                                child: Container(
                                  width: 280,
                                  margin: const EdgeInsets.only(right: 16, bottom: 8),
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    gradient: LinearGradient(
                                      colors: gradient,
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: gradient.first.withOpacity(0.4),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.access_time_filled, color: Colors.white, size: 12),
                                                const SizedBox(width: 4),
                                                Text(
                                                  dateFormat.format(quiz.settings.endTime),
                                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (isUrgent)
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.redAccent,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: const Text('GẤP', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                                            )
                                        ],
                                      ),
                                      
                                      Text(
                                        quiz.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          height: 1.2,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),

                                      // Button giả bên trong card
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Làm Bài Ngay",
                                            style: TextStyle(
                                              color: gradient.last,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                      const SizedBox(height: 32),

                      const _SectionTitle(title: "Lớp học của tôi"),
                      const SizedBox(height: 16),

                      if (vm.myClasses.isEmpty)
                        const Center(child: Text("Bạn chưa tham gia lớp học nào.", style: TextStyle(color: Colors.grey))),

                      Column(
                        children: List.generate(vm.myClasses.length, (index) {
                          final cls = vm.myClasses[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    StudentClassDetailScreen.routeName,
                                    arguments: cls,
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: _getClassColor(index),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Icon(
                                          Icons.school_rounded,
                                          color: _getIconColor(index),
                                          size: 28,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cls.name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                Icon(Icons.person_outline_rounded, size: 14, color: Colors.grey[500]),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    "GV: ${cls.lecturerName}",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.grey[600],
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey[300]),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void _showStartQuizDialog(BuildContext context, QuizModel quiz) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Bắt đầu làm bài?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bài thi: ${quiz.title}'),
            const SizedBox(height: 8),
            Text('Thời gian: ${quiz.settings.durationMinutes} phút', style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Huỷ', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(
                context,
                DoQuizScreen.routeName,
                arguments: quiz,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Bắt đầu'),
          ),
        ],
      ),
    );
  }
}

// Widget tiêu đề section nhỏ gọn
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.grey[500],
        letterSpacing: 1.2,
      ),
    );
  }
}