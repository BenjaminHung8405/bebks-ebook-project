import 'package:bebks_ebooks/utils/colorModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:bebks_ebooks/utils/environment.dart';
import 'dart:convert';

import '../../../config/app_size.dart';

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
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          await storage.write(
            key: 'access_token', value: myToken);
          await storage.write(
              key: 'refresh_token', value: myToken);
          await storage.write(
            key: 'userId', value: jsonResponse['id']);
          print(jsonResponse);
          context.pushReplacement('/main');
      }else{
        print('Something went wrong');
      }

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
      backgroundColor: ColorModel.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.blockSizeHorizontal * 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: AppSizes.blockSizeHorizontal * 3),
              Text(
                'Chào mừng trở lại!',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: AppSizes.blockSizeHorizontal * 6,
                  color: ColorModel.textColor,
                ),
              ),
              Text(
                'Đăng nhập để tiếp tục.',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: AppSizes.blockSizeHorizontal * 3.5,
                  color: ColorModel.lightTextColor,
                ),
              ),
              SizedBox(height: AppSizes.blockSizeHorizontal * 8),
              _buildTextField(
                hintText: 'Email',
                prefixIcon: Icons.mail_outline_rounded,
                controller: emailController
              ),
              SizedBox(height: AppSizes.blockSizeHorizontal * 2.5),
              _buildTextField(
                controller: passwordController,
                hintText: 'Mật khẩu',
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true,
              ),
              SizedBox(height: AppSizes.blockSizeHorizontal * 3),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Quên mật khẩu?',
                    style: TextStyle(
                      color: ColorModel.secondaryColor,
                      fontSize: AppSizes.blockSizeHorizontal * 3,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSizes.blockSizeHorizontal * 4),
              _buildLoginButton(),
              SizedBox(height: AppSizes.blockSizeHorizontal * 4),
              Text(
                'Hoặc đăng nhập bằng',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: AppSizes.blockSizeHorizontal * 4,
                  color: ColorModel.lightTextColor,
                ),
              ),
              SizedBox(height: AppSizes.blockSizeHorizontal * 3),
              _buildSocialLoginButtons(),
              SizedBox(height: AppSizes.blockSizeHorizontal * 3),
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

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: loginUser,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorModel.secondaryColor,
        minimumSize: Size(double.infinity, AppSizes.blockSizeHorizontal * 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.blockSizeHorizontal * 5)),
      ),
      child: _isLoading
          ? CircularProgressIndicator(color: ColorModel.primaryColor, strokeWidth: AppSizes.blockSizeHorizontal * 0.5)
          : Text(
              'Đăng nhập',
              style: TextStyle(
                  fontSize: AppSizes.blockSizeHorizontal * 5,
                  color: ColorModel.primaryColor,
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
        padding: EdgeInsets.symmetric(horizontal: AppSizes.blockSizeHorizontal * 1),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorModel.primaryColor,
            padding: EdgeInsets.symmetric(vertical: AppSizes.blockSizeHorizontal * 3, horizontal: AppSizes.blockSizeHorizontal * 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.blockSizeHorizontal * 3),
              side: BorderSide(color: ColorModel.textColor),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconPath, height: AppSizes.blockSizeHorizontal * 5),
              SizedBox(width: AppSizes.blockSizeHorizontal * 1.5),
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: AppSizes.blockSizeHorizontal * 3,
                  color: ColorModel.textColor,
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
        Text(
          'Chưa có tài khoản?',
          style: TextStyle(fontSize: AppSizes.blockSizeHorizontal * 4, color: ColorModel.lightTextColor),
        ),
        TextButton(
          onPressed: () {
            context.push('/regis');
          },
          child: Text(
            'Đăng ký',
            style: TextStyle(fontSize: AppSizes.blockSizeHorizontal * 4, color: ColorModel.secondaryColor),
          ),
        )
      ],
    );
  }
}