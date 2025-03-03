import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF4F5F7),
          contentPadding: const EdgeInsets.all(10),
          hintText: 'Bạn muốn tìm sách gì?',
          hintStyle: const TextStyle(
              color: Color.fromARGB(255, 206, 203, 203),
              fontSize: 18,
              fontWeight: FontWeight.w400),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 15, right: 10),
            child: Icon(
              Icons.search_rounded,
              size: 30,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
