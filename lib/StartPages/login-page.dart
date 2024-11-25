import 'package:bebks_ebooks/Library/library-page.dart';
import 'package:bebks_ebooks/StartPages/register-page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bebks_ebooks/models/environment.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  bool _isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> loginUser() async {
    try {
      final reqBody = {
        'email': emailController.text,
        'password': passwordController.text
      };

      final response = await http.post(
        Uri.parse('${Environment.apiUrl}/v1/users/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(reqBody)  
        );

      final jsonResponse = jsonDecode(response.body);
      if(jsonResponse['status']){
          final myToken = jsonResponse['token'];
          prefs.setString('token', myToken);
          Navigator.push(context, MaterialPageRoute(builder: (context) => LibraryPage(token: myToken),));
      }else{
        print('Something went wrong');
      }

        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng nhập thành công!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${response.body}')),
        );
      }
      
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        // SnackBar(content: Text('Lỗi kết nối: $e')),
        SnackBar(content: Text('Sai thông tin đăng nhập!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF14161B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Chào mừng trở lại!',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 27,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Đăng nhập để tiếp tục.',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: Color(0xff83899f),
                ),
              ),
              const SizedBox(height: 40),
              _buildTextField(
                hintText: 'Email',
                prefixIcon: Icons.mail_outline_rounded,
                controller: emailController
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: passwordController,
                hintText: 'Mật khẩu',
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true,
              ),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Quên mật khẩu?',
                    style: TextStyle(
                      color: Color(0xFF8C31FF),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildLoginButton(),
              const SizedBox(height: 16),
              const Text(
                'Hoặc đăng nhập bằng',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Color(0xFF9FA5C0),
                ),
              ),
              const SizedBox(height: 16),
              _buildSocialLoginButtons(),
              const SizedBox(height: 16),
              _buildSignUpRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required IconData prefixIcon,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && _isObscure,
      style: const TextStyle(
          color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
        hintText: hintText,
        hintStyle: const TextStyle(
            color: Color(0xff83899f),
            fontSize: 16,
            fontWeight: FontWeight.w400),
        prefixIcon: Icon(prefixIcon, size: 20),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility,
                    size: 20),
                onPressed: () => setState(() => _isObscure = !_isObscure),
              )
            : null,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD0DBEA), width: 1.0),
          borderRadius: BorderRadius.circular(18)
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF8C31FF), width: 2.0),
          borderRadius: BorderRadius.circular(18)
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD0DBEA), width: 1.0),
          borderRadius: BorderRadius.circular(18)
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: loginUser,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8C31FF),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      child: _isLoading
          ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
          : const Text(
              'Đăng nhập',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
    );
  }

  Widget _buildSocialLoginButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSocialButton('Google', 'assets/icons/google-logo.png'),
        _buildSocialButton('Facebook', 'assets/icons/facebook-logo.png'),
        _buildSocialButton('GitHub', 'assets/icons/github-logo.png'),
      ],
    );
  }

  Widget _buildSocialButton(String text, String iconPath) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconPath, height: 24),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Chưa có tài khoản?',
          style: TextStyle(fontSize: 18, color: Color(0xFF9FA5C0)),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const RegisterPage()));
          },
          child: const Text(
            'Đăng ký',
            style: TextStyle(fontSize: 18, color: Color(0xFF8C31FF)),
          ),
        )
      ],
    );
  }
}