import 'package:bebks_ebooks/pages/auth/presentations/login_page.dart';
import 'package:bebks_ebooks/pages/auth/presentations/register-page.dart';
import 'package:bebks_ebooks/pages/book/book_read.dart';
import 'package:bebks_ebooks/pages/book/chapter_read.dart';
import 'package:bebks_ebooks/pages/others/start_page.dart';
import 'package:bebks_ebooks/pages/layout/presentation/main_layout.dart';
import 'package:bebks_ebooks/pages/screens/home_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter{
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const StartPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/regis',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/library',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/main',
        builder: (context, state) => const MainLayout(),
      ),
      GoRoute(
        path: '/book/:id',
        builder: (context, state) => BookRead(
          bookId: state.pathParameters['id']!
        ),
      ),
      GoRoute(
        path: '/chapter/:id',
        builder: (context, state) => ChapterRead(
          chapterId: state.pathParameters['id']!
        ),
      ),
    ]
  );
}