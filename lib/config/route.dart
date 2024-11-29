import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:bebks_ebooks/StartPages/login_page.dart';
import 'package:bebks_ebooks/StartPages/start_page.dart';
import 'package:bebks_ebooks/pages/book_read.dart';
import 'package:bebks_ebooks/pages/library_page.dart'; 

GoRouter createRouter(String token){
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const StartPage(),
        // redirect: (context, state) async {
        //   if (token.isNotEmpty && !JwtDecoder.isExpired(token)) {
        //     return '/library';
        //   }
        //   return null;
        // },
      ),
      GoRoute(
        path: '/library',
        name: 'library',
        builder: (context, state) {
          return LibraryPage(token: token);
        },
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/read/:id',
        name: 'read',
        builder: (context, state) {
          final id = state.pathParameters['id'] as String;
          return BookRead(bookId: id,);
        },
      ),
    ],
    redirect: (context, state) async {
      // Using `of` method creates a dependency of StreamAuthScope. It will
      // cause go_router to reparse current route if StreamAuth has new sign-in
      // information.
      final bool loggedIn = (token.isNotEmpty && !JwtDecoder.isExpired(token));
      final bool loggingIn = state.matchedLocation == '/';
      if (!loggedIn) {
        return '/';
      }

      // if the user is logged in but still on the login page, send them to
      // the home page
      if (loggingIn) {
        return '/library';
      }

      // no need to redirect at all
      return null;
    },
    errorBuilder: (context, state) => Scaffold(body: Center(child: Text('Page not found'))),
  );
}