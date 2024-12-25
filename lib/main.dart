import 'package:flutter/material.dart';
import 'package:medical_app/pages/main_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Убрали надпись Debug
      title: 'Digital Library',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(26, 111, 238, 100),
          primary: const Color.fromRGBO(26, 111, 238, 100),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        canvasColor: Colors.white,
        appBarTheme: const AppBarTheme(color: Colors.white),
        fontFamily: 'Montserrat',
      ),
      home: const MainPage(),
    );
  }
}
