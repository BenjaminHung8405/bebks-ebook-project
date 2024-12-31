import 'package:bebks_ebooks/pages/auth/presentations/login_page.dart';
import 'package:flutter/material.dart';
import 'package:bebks_ebooks/models/colorModel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      checkCredentials();
    });
  }

  Future<void> checkCredentials() async {
    try {
      final accessToken = await storage.read(key: 'access_token');
      if (accessToken != null) {
        context.pushReplacement('/main');
      } else {
        context.pushReplacement('/login');
      }
    } catch (e) {
      context.pushReplacement('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorModel.primaryColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Image(
              image: AssetImage('assets/images/language-book1.png'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: Text(
              textAlign: TextAlign.center,
              'Đọc sách cùng BEBKs',
              style: TextStyle(
                  color: ColorModel.textColor,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  height: 1.3
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Text(
              textAlign: TextAlign.center,
              'Đọc sách rất quan trọng. Nếu biết cách đọc cả thế giới sẽ mở ra với bạn',
              style: TextStyle(
                  color: ColorModel.lightTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400
              ),
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton.icon(
            label: Text(
              'Cùng bắt đầu nào',
              style: TextStyle(
                  color: ColorModel.primaryColor,
                  fontSize: 23,
                  fontWeight: FontWeight.w600
              ),
            ),
            icon: Icon(
              Icons.book,
              color: ColorModel.primaryColor,
            ),
            style: ElevatedButton.styleFrom(
                minimumSize: Size(330, 48),
                backgroundColor: ColorModel.secondaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                )
            ),
            onPressed: () async {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginPage()
                  )
              );
              // context.goNamed('login');
            },

          )
        ],
      ),
    );
  }
}
