import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzy_cross_platform/features/auth/viewmodel/login_viewmodel.dart';
import 'package:quizzy_cross_platform/features/auth/viewmodel/profie_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _roleCtrl;
  late final TextEditingController _studentIdCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _roleCtrl = TextEditingController();
    _studentIdCtrl = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfieViewmodel>().fechUserProfile();
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _roleCtrl.dispose();
    _studentIdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pvm = context.watch<ProfieViewmodel>();
    final lvm = context.watch<LoginViewmodel>();
    if (pvm.currentUser != null) {
      _nameCtrl.text = pvm.currentUser!.fullName;
      _emailCtrl.text = pvm.currentUser!.email;
      _roleCtrl.text = pvm.currentUser!.role == 'student' ? 'Sinh viên' : 'Giảng viên';
      _studentIdCtrl.text = pvm.currentUser!.studentId ?? '';
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ cá nhân'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Đăng xuất",
            onPressed: () => lvm.logout(),
          )
        ],
      ),
      body: pvm.isLoading && pvm.currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : pvm.errorMessage != null
              ? Center(child: Text('Lỗi: ${pvm.errorMessage}'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Avatar
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(""),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.camera_alt, size: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Full Name
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Họ và tên',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Email (Read-only)
                      TextFormField(
                        controller: _emailCtrl,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.black12,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Role (Read-only)
                      TextFormField(
                        controller: _roleCtrl,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Vai trò',
                          prefixIcon: Icon(Icons.badge),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.black12,
                        ),
                      ),
                      
                      // Student
                      if (pvm.currentUser?.role == 'student') ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _studentIdCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Mã số sinh viên',
                            prefixIcon: Icon(Icons.school),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
    );
  }
}