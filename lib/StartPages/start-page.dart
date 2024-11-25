// import 'package:bebks_ebooks/Library/library-page.dart';
import 'package:bebks_ebooks/StartPages/login-page.dart';
import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14161B),
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
                  color: Colors.white,
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
                  color: Color(0xff83899f),
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
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w600
              ),
            ),
            icon: Icon(
              Icons.book,
              color: Colors.white,
            ),
            style: ElevatedButton.styleFrom(
                minimumSize: Size(330, 48),
                backgroundColor: Color(0xFF8C31FF),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                )
            ),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginPage()
                  )
              );
            },

          )
        ],
      ),
    );
  }
}
