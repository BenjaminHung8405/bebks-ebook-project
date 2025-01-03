import 'dart:convert';

import 'package:bebks_ebooks/pages/auth/presentations/login_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:bebks_ebooks/utils/environment.dart';
import 'package:bebks_ebooks/utils/colorModel.dart';

import '../../../config/app_size.dart';

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
        context.push('/login');
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
          padding: EdgeInsets.symmetric(horizontal: AppSizes.blockSizeHorizontal * 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: AppSizes.blockSizeHorizontal * 6),
              Text(
                'Tạo tài khoản của bạn',
                style: TextStyle(
                  color: ColorModel.textColor,
                  fontSize: AppSizes.blockSizeHorizontal * 6,
                  fontWeight: FontWeight.w700
                  ),
                  
                  ),
              SizedBox(height: AppSizes.blockSizeHorizontal * 10),
              _buildTextField(
                hintText: 'Tên người dùng', 
                prefixIcon: Icons.person, 
                controller: userController
                ),
              SizedBox(height: AppSizes.blockSizeHorizontal * 4),
              _buildTextField(
                controller: emailController,
                hintText: 'Email', 
                prefixIcon: Icons.mail_outline_rounded,
                ),
              SizedBox(height: AppSizes.blockSizeHorizontal * 4),
              _buildTextField(
                controller: passwordController,
                hintText: 'Mật khẩu', 
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true
                ),
              SizedBox(height: AppSizes.blockSizeHorizontal * 8),
              ElevatedButton(
                onPressed: registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorModel.secondaryColor,
                  minimumSize: Size(double.infinity, AppSizes.blockSizeHorizontal * 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.blockSizeHorizontal * 5)),
                ), 
                child: _isLoading
                ? CircularProgressIndicator(color: ColorModel.secondaryColor, strokeWidth: AppSizes.blockSizeHorizontal * 0.5)
                : Text(
                    'Đăng ký',
                    style: TextStyle(
                        fontSize: AppSizes.blockSizeHorizontal * 5,
                        color: ColorModel.primaryColor,
                        fontWeight: FontWeight.w700),
                  ),
            ),
            SizedBox(height: AppSizes.blockSizeHorizontal * 4),
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
          color: ColorModel.textColor, fontSize: AppSizes.blockSizeHorizontal * 4, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: AppSizes.blockSizeHorizontal * 2.5, horizontal: 0),
        hintText: hintText,
        hintStyle: TextStyle(
            color: ColorModel.lightTextColor,
            fontSize: AppSizes.blockSizeHorizontal * 4,
            fontWeight: FontWeight.w400),
        prefixIcon: Icon(prefixIcon, size: AppSizes.blockSizeHorizontal * 4),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility,
                    size: AppSizes.blockSizeHorizontal * 4),
                onPressed: () => setState(() => _isObscure = !_isObscure),
              )
            : null,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: ColorModel.borderColor, width: AppSizes.blockSizeHorizontal * 0.2),
          borderRadius: BorderRadius.circular(AppSizes.blockSizeHorizontal * 4)
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorModel.secondaryColor, width: AppSizes.blockSizeHorizontal * 0.2),
          borderRadius: BorderRadius.circular(AppSizes.blockSizeHorizontal * 4)
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorModel.borderColor, width: AppSizes.blockSizeHorizontal * 0.2),
          borderRadius: BorderRadius.circular(AppSizes.blockSizeHorizontal * 4)
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
          style: TextStyle(fontSize: AppSizes.blockSizeHorizontal * 4, color: ColorModel.lightTextColor),
        ),
        TextButton(
          onPressed: () {
            context.push('/login');
          },
          child: Text(
            'Đăng nhập',
            style: TextStyle(fontSize: AppSizes.blockSizeHorizontal * 4, color: ColorModel.secondaryColor),
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