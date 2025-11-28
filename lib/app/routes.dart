import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/features/auth/view/forgotpassword_screen.dart';
import 'package:quizzy_cross_platform/features/auth/view/login_screen.dart';
import 'package:quizzy_cross_platform/features/auth/view/register_screen.dart';
import 'package:quizzy_cross_platform/features/student/home_screen.dart';
import 'package:quizzy_cross_platform/features/student/welcome_screen.dart';

class AppRoutes {
  static const String welcome = '/';

  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const WelcomeScreen(),
    '/login': (context) => const LoginScreen(),
    '/homestudent': (context) => const HomeScreen(),
    '/register': (context) => const RegisterScreen(),
    '/forgotpass': (context) => const ForgotPasswordScreen(),
  };
}
