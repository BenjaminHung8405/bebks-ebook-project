import 'package:bebks_ebooks/config/app_size.dart';
import 'package:bebks_ebooks/pages/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widget/custom_navbar.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    pageController = PageController(initialPage: _currentIndex);
  }

   @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void animateToPage(int page) {
    // Chỉ cho phép chuyển về HomePage
    if (_currentIndex != 0 && _currentIndex != 1 && _currentIndex != 3) {
      pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.decelerate,
      );
      setState(() {
        _currentIndex = 0;
      });
      return;
    }

    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.decelerate,
    );
  }

  @override
  Widget build(BuildContext context) {
    AppSizes().init(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: PageView(
                controller: pageController,
                physics:
                    const NeverScrollableScrollPhysics(), // Chặn vuốt ngang
                onPageChanged: (v) {
                  setState(() {
                    _currentIndex = v;
                  });
                },
                children: const [
                  HomePage()
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomNavBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  if (index == 0 || index == 1 || index == 3) {
                    animateToPage(index);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getAnimatedPositionLeft() {
    return AppSizes.blockSizeHorizontal * (3 + (_currentIndex * 22));
  }
}