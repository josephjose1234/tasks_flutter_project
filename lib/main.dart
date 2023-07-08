import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'package:flutter/services.dart';
import 'homepage.dart';
void main() {
  runApp( ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(),
      builder: (context, _) => MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:HomePage()
    );
  }
}
