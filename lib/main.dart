import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';  
import 'config/route.dart';

Future main() async {
  // To load the .env file contents into dotenv.
  // NOTE: fileName defaults to .env and can be omitted in this case.
  // Ensure that the filename corresponds to the path in step 1 and 2.
  try {
    await dotenv.load();
  } catch (e) {
    throw Exception('Error loading .env file: $e');
  }
  
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final token = prefs.getString('token');
  bool isTokenValid = token != null && token.isNotEmpty && !JwtDecoder.isExpired(token);

  runApp(MyApp(token: isTokenValid ? token : '',));
}

class MyApp extends StatelessWidget {
  final token;
  const MyApp({
    @required this.token,
    Key? key
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final router = createRouter(token);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF-Pro',
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF14161B)),
        scaffoldBackgroundColor: Color(0xFF14161B),
        useMaterial3: true,
        ),
      // routerConfig: router,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      // home: (token.isNotEmpty && !JwtDecoder.isExpired(token)) ? LibraryPage(token: token) : StartPage(),
    );
  }
}
