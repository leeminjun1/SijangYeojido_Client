import 'package:flutter/material.dart';

class AppColors {
  // Rebrand: Toss-like clarity + NaverMap trust + Baemin friendly accent
  // Neutral base (Toss-ish)
  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF191F28);
  static const Color textSecondary = Color(0xFF6B7684);
  static const Color textTertiary = Color(0xFFB0B8C1);
  static const Color border = Color(0xFFE5E8EB);
  static const Color divider = Color(0xFFF2F4F6);

  // Primary (Naver green)
  static const Color primary = Color(0xFF03C75A);
  static const Color primaryLight = Color(0xFFEAFBF2);

  // Accent (Baemin mint)
  static const Color accent = Color(0xFF2AC1BC);
  static const Color accentLight = Color(0xFFE6FAF9);

  // System colors
  static const Color success = Color(0xFF3182F6); // Toss blue
  static const Color successLight = Color(0xFFE8F3FF);
  static const Color warning = Color(0xFFFFB020);
  static const Color warningLight = Color(0xFFFFF6E5);
  static const Color danger = Color(0xFFF04452);
  static const Color dangerLight = Color(0xFFFFECEE);

  // Legacy aliases (keep to reduce churn)
  static const Color orange = warning;
  static const Color blue = success;
  static const Color blueLight = successLight;
  // Market zone colors
  static const Color zoneA = Color(0xFFEAFBF2); // green tint
  static const Color zoneB = Color(0xFFE8F3FF); // blue tint
  static const Color zoneC = Color(0xFFE6FAF9); // mint tint
  static const Color zoneD = Color(0xFFFFF6E5); // warm tint
  static const Color mapBackground = Color(0xFFF0F3F6);
  static const Color aisle = Color(0xFFF6F7F9);

  // Shadow & shimmer
  static const Color cardShadow = Color(0x0F000000);
  static const Color cardShadowLight = Color(0x08000000);
}
