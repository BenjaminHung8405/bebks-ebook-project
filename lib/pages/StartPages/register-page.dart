import 'dart:convert';

import 'package:bebks_ebooks/pages/StartPages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bebks_ebooks/models/environment.dart';
import 'package:bebks_ebooks/models/colorModel.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isObscure = true;
  bool _isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userController = TextEditingController();

  Future<void> registerUser() async {
    try {
      final reqBody = {
        'name': userController.text,
        'email': emailController.text,
        'password': passwordController.text
      };

      final response = await http.post(
        Uri.parse('${Environment.apiUrl}/v1/users/registration'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(reqBody) 
        );

        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng ký thành công!')),
        );
        Navigator.pushNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${response.body}')),
        );
      }

    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi kết nối: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorModel.primaryColor,
      appBar: AppBar(
        backgroundColor: ColorModel.primaryColor,
        foregroundColor: ColorModel.textColor,
        ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                'Tạo tài khoản của bạn',
                style: TextStyle(
                  color: ColorModel.textColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w700
                  ),
                  
                  ),
              const SizedBox(height: 50),
              _buildTextField(
                hintText: 'Tên người dùng', 
                prefixIcon: Icons.person, 
                controller: userController
                ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: emailController,
                hintText: 'Email', 
                prefixIcon: Icons.mail_outline_rounded,
                ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: passwordController,
                hintText: 'Mật khẩu', 
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true
                ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorModel.secondaryColor,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ), 
                child: _isLoading
                ? CircularProgressIndicator(color: ColorModel.secondaryColor, strokeWidth: 2)
                : Text(
                    'Đăng ký',
                    style: TextStyle(
                        fontSize: 25,
                        color: ColorModel.primaryColor,
                        fontWeight: FontWeight.w700),
                  ),
            ),
            const SizedBox(height: 20),
            _buildReturnLogin()

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
      style: TextStyle(
          color: ColorModel.textColor, fontSize: 18, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
        hintText: hintText,
        hintStyle: TextStyle(
            color: ColorModel.lightTextColor,
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
          borderSide: BorderSide(color: ColorModel.borderColor, width: 1.0),
          borderRadius: BorderRadius.circular(18)
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorModel.secondaryColor, width: 2.0),
          borderRadius: BorderRadius.circular(18)
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorModel.borderColor, width: 1.0),
          borderRadius: BorderRadius.circular(18)
        ),
      ),
    );
  }

  Widget _buildReturnLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Đã có tài khoản?',
          style: TextStyle(fontSize: 18, color: ColorModel.lightTextColor),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
          },
          child: Text(
            'Đăng nhập',
            style: TextStyle(fontSize: 18, color: ColorModel.secondaryColor),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}