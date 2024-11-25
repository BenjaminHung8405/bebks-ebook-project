import 'package:bebks_ebooks/StartPages/login-page.dart';
import 'package:flutter/material.dart';
import 'package:bebks_ebooks/StartPages/start-page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';  

Future main() async {
  // To load the .env file contents into dotenv.
  // NOTE: fileName defaults to .env and can be omitted in this case.
  // Ensure that the filename corresponds to the path in step 1 and 2.
  try {
    await dotenv.load();
  } catch (e) {
    throw Exception('Error loading .env file: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF-Pro',
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF14161B)),
        scaffoldBackgroundColor: Color(0xFF14161B),
        useMaterial3: true,
        ),
      home: StartPage(),
    );
  }
}
