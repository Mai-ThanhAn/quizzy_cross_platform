import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzy_cross_platform/features/teacher/home/viewmodel/teacher_home_viewmodel.dart';

class TeacherDashboardTab extends StatefulWidget {
  final void Function(int index) onChangeTab;

  const TeacherDashboardTab({
    super.key,
    required this.onChangeTab,
  });

  @override
  State<TeacherDashboardTab> createState() => _TeacherDashboardTabState();
}

class _TeacherDashboardTabState extends State<TeacherDashboardTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeacherHomeViewModel>().loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TeacherHomeViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: vm.isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
            : RefreshIndicator(
                onRefresh: vm.loadDashboardData,
                color: Colors.blueAccent,
                backgroundColor: Colors.white,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Header(userName: vm.userName),
                      const SizedBox(height: 32),

                      const _SectionTitle(title: 'Tổng quan'),
                      const SizedBox(height: 16),
                      _StatsOverview(
                        classCount: vm.totalClasses,
                        examCount: vm.totalExams,
                      ),
                      
                      const SizedBox(height: 32),

                      const _SectionTitle(title: 'Thao tác nhanh'),
                      const SizedBox(height: 16),
                      _PrimaryActions(
                        onCreateClass: () {
                          Navigator.pushNamed(context, '/create_class');
                        },
                        onCreateExam: () {
                           // Logic giữ nguyên theo yêu cầu
                           // Giả sử chuyển sang tab Đề thi để tạo
                           // Hoặc điều hướng trực tiếp nếu flow app cho phép
                          widget.onChangeTab(1); 
                        },
                      ),
                      
                      const SizedBox(height: 32),

                      const _SectionTitle(title: 'Truy cập'),
                      const SizedBox(height: 16),

                      _QuickNavItem(
                        icon: Icons.school_rounded,
                        title: 'Lớp của tôi',
                        subtitle: 'Quản lý danh sách lớp và sinh viên',
                        color: Colors.purpleAccent,
                        onTap: () => widget.onChangeTab(0),
                      ),
                      _QuickNavItem(
                        icon: Icons.assignment_rounded,
                        title: 'Bài kiểm tra',
                        subtitle: 'Danh sách bài thi và chấm điểm',
                        color: Colors.orangeAccent,
                        onTap: () => widget.onChangeTab(1),
                      ),
                      _QuickNavItem(
                        icon: Icons.account_balance_rounded,
                        title: 'Ngân hàng câu hỏi',
                        subtitle: 'Kho lưu trữ đề thi và câu hỏi',
                        color: Colors.blueAccent,
                        onTap: () => widget.onChangeTab(3),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

/* =========================
   ========== UI ===========
   ========================= */

class _Header extends StatelessWidget {
  final String userName;

  const _Header({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chào mừng trở lại,',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blueAccent.withOpacity(0.2), width: 2),
          ),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blueAccent.withOpacity(0.1),
            child: const Icon(Icons.person, color: Colors.blueAccent),
          ),
        ),
      ],
    );
  }
}

class _StatsOverview extends StatelessWidget {
  final int classCount;
  final int examCount;

  const _StatsOverview({
    required this.classCount,
    required this.examCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Lớp học',
            value: classCount.toString(),
            icon: Icons.class_rounded,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            label: 'Bài kiểm tra',
            value: examCount.toString(),
            icon: Icons.assignment_turned_in_rounded,
            color: Colors.orangeAccent,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryActions extends StatelessWidget {
  final VoidCallback onCreateClass;
  final VoidCallback onCreateExam;

  const _PrimaryActions({
    required this.onCreateClass,
    required this.onCreateExam,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PrimaryButton(
            icon: Icons.add_rounded,
            label: 'Tạo Lớp',
            onTap: onCreateClass,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _PrimaryButton(
            icon: Icons.note_add_rounded,
            label: 'Soạn Đề',
            onTap: onCreateExam,
            color: Colors.green, // Dùng màu xanh lá cho khác biệt
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _PrimaryButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 32, color: color),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickNavItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color color;

  const _QuickNavItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 24, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey[300]),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

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
        letterSpacing: 1.2
      ),
    );
  }
}