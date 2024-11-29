import 'package:bebks_ebooks/pages/StartPages/login_page.dart';
import 'package:bebks_ebooks/pages/StartPages/register-page.dart';
import 'package:bebks_ebooks/pages/StartPages/start_page.dart';
import 'package:bebks_ebooks/pages/book/book_read.dart';
import 'package:bebks_ebooks/pages/book/chapter_read.dart';
import 'package:bebks_ebooks/pages/library_page.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const StartPage(),
  '/login': (context) => const LoginPage(),
  '/register': (context) => const RegisterPage(),
};

Route<dynamic> generateRoute(RouteSettings settings) {
  if (settings.name?.startsWith('/book/') ?? false) {
    final bookId = settings.name!.split('/').last;
    return MaterialPageRoute(
      builder: (context) => BookRead(bookId: bookId,),
      settings: settings,
    );
  }

  if (settings.name?.startsWith('/chapter/') ?? false) {
    final chapterId = settings.name!.split('/').last;
    return MaterialPageRoute(
      builder: (context) => ChapterRead(chapterId: chapterId,),
      settings: settings,
    );
  }

  if (settings.name?.startsWith('/library/') ?? false) {
    final myToken = settings.name!.split('/').last;
    return MaterialPageRoute(
      builder: (context) => LibraryPage(token: myToken),
      settings: settings,
    );
  }

  return MaterialPageRoute(
    builder: (_) =>
        const Scaffold(body: Center(child: Text('Route not found'))),
  );
}

