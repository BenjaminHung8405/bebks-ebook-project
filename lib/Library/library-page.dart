import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
class LibraryPage extends StatefulWidget {
  final token;
  const LibraryPage({@required this.token,Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late String email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String,dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

    email = jwtDecodedToken['email'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14161B),
      body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled)
          => [SliverAppBar(
            backgroundColor: const Color(0xFF14161B),
            automaticallyImplyLeading: false,
            floating: true,
            snap: true,
            centerTitle: true,
            title: const Text(
              'Thư viện',
              style: TextStyle(
                  color: Color(0xFF83899F),
                  fontSize: 25,
                  fontWeight: FontWeight.w400
              ),
            ),
          )],
          body: ListView()
      ),
    );
  }
  
}
