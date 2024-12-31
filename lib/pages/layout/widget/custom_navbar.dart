import 'package:bebks_ebooks/models/colorModel.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kBottomNavigationBarHeight + 15,
      decoration: BoxDecoration(
        color: ColorModel.primaryColor,
        boxShadow: [
          BoxShadow(
            color: ColorModel.secondaryColor.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, -3),
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, -3),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        children: [
          BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: ColorModel.buttonColor,
            unselectedItemColor: ColorModel.lightTextColor,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedFontSize: 0,
            unselectedFontSize: 0,
            enableFeedback: true,
            items: <BottomNavigationBarItem>[
              _buildNavItem(
                context,
                IconlyLight.home,
                IconlyBold.home,
                'Home',
                currentIndex == 0,
              ),
              _buildNavItem(
                context,
                IconlyLight.search,
                IconlyBold.search,
                'Search',
                currentIndex == 1,
              ),
              _buildNavItem(
                context,
                IconlyLight.bookmark,
                IconlyBold.bookmark,
                'Bookmark',
                currentIndex == 2,
              ),
              _buildNavItem(
                context,
                IconlyLight.profile,
                IconlyBold.profile,
                'Profile',
                currentIndex == 3,
              ),
            ],
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    BuildContext context,
    IconData icon,
    IconData activeIcon,
    String label,
    bool isSelected,
  ) {
    return BottomNavigationBarItem(
      icon: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: isSelected ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 200),
        builder: (context, value, child) {
          return Container(
            padding: EdgeInsets.all(8 + (value * 2)),
            decoration: BoxDecoration(
              color:
                  ColorModel.buttonColor.withOpacity(0.1 * value),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 28 + (value * 2),
              color: isSelected
                  ? ColorModel.buttonColor
                  : ColorModel.lightTextColor,
            ),
          );
        },
      ),
      activeIcon: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: ColorModel.buttonColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          activeIcon,
          size: 30,
          color: ColorModel.buttonColor,
        ),
      ),
      label: '',
    );
  }
}