import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:quizzy_cross_platform/app/app.dart';
import 'package:quizzy_cross_platform/features/auth/viewmodel/login_viewmodel.dart';
import 'package:quizzy_cross_platform/features/auth/viewmodel/register_viewmodel.dart';
import 'package:quizzy_cross_platform/features/auth/viewmodel/profie_viewmodel.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewmodel()),
        ChangeNotifierProvider(create: (_) => ProfieViewmodel()),
        
      ],
    child: MyApp()
    ),
  );
}