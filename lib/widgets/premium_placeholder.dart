import 'package:flutter/material.dart';

class PremiumPlaceholder extends StatelessWidget {
  final String category;
  final double width;
  final double height;
  final double borderRadius;
  final IconData? fallbackIcon;

  const PremiumPlaceholder({
    super.key,
    required this.category,
    this.width = 64,
    this.height = 64,
    this.borderRadius = 16,
    this.fallbackIcon,
  });

  @override
  Widget build(BuildContext context) {
    // Generate beautiful gradients based on the category string
    List<Color> gradientColors;
    IconData icon;

    if (category.contains('먹거리')) {
      gradientColors = [const Color(0xFFFFF3E6), const Color(0xFFFFE2CC)];
      icon = Icons.restaurant_rounded;
    } else if (category.contains('수산물')) {
      gradientColors = [const Color(0xFFEAFBF2), const Color(0xFFD7F6E5)];
      icon = Icons.set_meal_rounded;
    } else if (category.contains('정육')) {
      gradientColors = [const Color(0xFFFFECEE), const Color(0xFFFFDADF)];
      icon = Icons.kebab_dining_rounded;
    } else if (category.contains('과일')) {
      gradientColors = [const Color(0xFFE6FAF9), const Color(0xFFD0F6F4)];
      icon = Icons.apple_rounded;
    } else {
      gradientColors = [const Color(0xFFF6F7F9), const Color(0xFFF0F3F6)];
      icon = fallbackIcon ?? Icons.storefront_rounded;
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
      ),
      child: Center(
        child: Icon(
          icon,
          size: width * 0.45,
          color: Colors.black.withValues(alpha: 0.25),
        ),
      ),
    );
  }


}
