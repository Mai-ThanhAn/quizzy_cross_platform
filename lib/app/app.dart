import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/app/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Lexend', 
        useMaterial3: true
        ),
      initialRoute:  AppRoutes.welcome,
      routes: AppRoutes.routes,
    );
  }
}