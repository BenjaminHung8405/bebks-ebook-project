import 'package:bebks_ebooks/pages/StartPages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:bebks_ebooks/models/colorModel.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

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
