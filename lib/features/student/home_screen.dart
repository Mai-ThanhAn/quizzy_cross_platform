import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Trong thực tế, bạn sẽ dùng ViewModel để lấy thông tin user
    // và hiển thị UI phù hợp (Student, Lecturer, Admin)
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ Quizzy'),
        actions: [
          // Nút Logout (AUTH-GEN-Logout)
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () {
              // Logic sẽ được xử lý bởi ViewModel
              // Ví dụ: context.read<AuthViewModel>().logout();
              // Sau đó điều hướng về màn hình Login
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Đăng nhập thành công!',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}