import 'package:flutter/material.dart';

class titleWidget extends StatelessWidget {
  const titleWidget({
    required this.title,
    this.padding = 10,
    this.size = 20
  });

  final String title;
  final double padding;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: padding),
      child: Text(
        title,
        style: TextStyle(
          color:  Color(0xFF14161B),
          fontSize: size,
          fontWeight: FontWeight.w600
        ),
      ),
    );
  }
}