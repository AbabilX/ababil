import 'package:flutter/material.dart';
import 'package:ababil_flutter/ui/screens/home_screen.dart';
import 'package:ababil_flutter/ui/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AbabilApp());
}

class AbabilApp extends StatelessWidget {
  const AbabilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ababil',
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
