import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzy_cross_platform/data/models/classes_model.dart';
import 'package:quizzy_cross_platform/data/models/quizzes_model.dart';
import 'package:quizzy_cross_platform/data/models/users_model.dart';
import 'package:quizzy_cross_platform/features/teacher/classes/viewmodel/class_detail_viewmodel.dart';
import 'package:quizzy_cross_platform/features/teacher/exams/widgets/teacher_exam_card.dart';

class ClassDetailScreen extends StatefulWidget {
  final ClassModel classModel;
  const ClassDetailScreen({super.key, required this.classModel});

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Use for manage tab index
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _currentIndex = _tabController.index);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClassDetailViewModel>().fetchStudents(
            widget.classModel.studentIds,
          );

      context.read<ClassDetailViewModel>().fetchExams(widget.classModel.id);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Helper UI: Container đổ bóng
  Widget _buildShadowContainer({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ClassDetailViewModel>();
    final cls = widget.classModel;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Nền xám hiện đại
      appBar: AppBar(
        title: const Text(
          'Chi Tiết Lớp Học',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
              onPressed: vm.isLoading
                  ? null
                  : () async {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          title: const Text('Xóa lớp học?'),
                          content: const Text(
                            'Hành động này không thể hoàn tác. Mọi dữ liệu liên quan sẽ bị mất.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(ctx);
                                final vm = context.read<ClassDetailViewModel>();
                                final success = await vm.deleteClass(
                                  widget.classModel.id,
                                );

                                if (success && context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Đã xóa lớp học thành công'),
                                    ),
                                  );
                                } else if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        vm.errorMessage ?? 'Xóa thất bại',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                'Xóa Lớp',
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: _buildHeaderInfo(context, cls),
          ),

          // Custom TabBar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.blueAccent,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blueAccent,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'Sinh viên', icon: Icon(Icons.people_alt_outlined)),
                Tab(text: 'Bài kiểm tra', icon: Icon(Icons.assignment_outlined)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                vm.isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
                    : _buildStudentList(vm.students),

                vm.isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
                    : _buildExamList(vm.exams),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 1
          ? Container(
             decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
                borderRadius: BorderRadius.circular(16),
              ),
            child: FloatingActionButton.extended(
                onPressed: () async {
                  Navigator.pushNamed(
                    context,
                    '/create_exam',
                    arguments: widget.classModel.id,
                  );
                },
                label: const Text('Tạo đề thi', style: TextStyle(fontWeight: FontWeight.bold)),
                icon: const Icon(Icons.add_rounded),
                backgroundColor: Colors.blueAccent,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
          )
          : null,
    );
  }

  Widget _buildHeaderInfo(BuildContext context, ClassModel cls) {
    return _buildShadowContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cls.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Học kỳ: ${cls.semester}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600], fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              // Icon trang trí
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.school_rounded, color: Colors.blueAccent, size: 28),
              )
            ],
          ),
          const SizedBox(height: 20),
          
          // Copy Code Area
          InkWell(
            onTap: () async {
              await context.read<ClassDetailViewModel>().copyClassCode(
                    cls.code,
                  );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã sao chép mã lớp vào bộ nhớ tạm'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Text('Mã tham gia:', style: TextStyle(color: Colors.grey)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      cls.code,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const Icon(Icons.copy_rounded, size: 20, color: Colors.blueAccent),
                  const SizedBox(width: 4),
                  const Text('Sao chép', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList(List<UserModel> students) {
    if (students.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Icon(Icons.people_outline, size: 48, color: Colors.grey[400]),
             const SizedBox(height: 12),
             Text('Lớp chưa có sinh viên', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
             boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: CircleAvatar(
              backgroundColor: Colors.primaries[index % Colors.primaries.length].withOpacity(0.2),
              child: Text(
                student.fullName.isNotEmpty ? student.fullName[0].toUpperCase() : '?',
                style: TextStyle(
                  color: Colors.primaries[index % Colors.primaries.length],
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            title: Text(student.fullName, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(student.email, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
          ),
        );
      },
    );
  }

  Widget _buildExamList(List<QuizModel> exams) {
    if (exams.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orangeAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.assignment_add, size: 40, color: Colors.orangeAccent),
            ),
            const SizedBox(height: 16),
            const Text(
              'Chưa có bài kiểm tra',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () async {
                Navigator.pushNamed(
                  context,
                  '/create_exam',
                  arguments: widget.classModel.id,
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
              child: const Text('Tạo đề ngay'),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: exams.length,
      itemBuilder: (context, index) {
        final quiz = exams[index];
        return TeacherExamCard(
          quiz: quiz,
          onTap: () {
            Navigator.pushNamed(context, '/exam_detail', arguments: quiz.id);
          },
        );
      },
    );
  }
}