import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzy_cross_platform/features/auth/viewmodel/login_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewmodel>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ Quizzy'),
        actions: [
          // Logout Button
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: vm.isLoading
                ? null
                : () async {
                    bool success = await vm.logout();
                    if (success) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Đăng xuất thành công!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pushReplacementNamed(context, '/login');
                    } else {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            vm.errorMessage ?? 'Đăng xuất thất bại',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Đăng nhập thành công!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/profile'),
              child: const Text(
                'Thông tin cá nhân',
                style: TextStyle(
                  color: Color.fromARGB(255, 183, 28, 28),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}