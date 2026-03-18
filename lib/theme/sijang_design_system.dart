import 'package:flutter/material.dart';

/// SDS (Sijang Design System) v7
/// 
/// 앱 전체의 일관된 고품격 미학을 유지하기 위한 통합 디자인 시스템 토큰입니다.
class SDS {
  // --- Border Radius ---
  static const double radiusS = 12.0;
  static const double radiusM = 20.0;
  static const double radiusL = 34.0;
  static const double radiusXL = 48.0;
  static const double radiusCapsule = 100.0;

  // --- Spacing ---
  static const double gutter = 20.0;
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double spaceXL = 40.0;

  // --- Shadows (Cinematic Depth) ---
  static List<BoxShadow> shadowSoft = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> shadowPremium = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 30,
      offset: const Offset(0, 12),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.02),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> shadowAccent(Color accent) => [
    BoxShadow(
      color: accent.withValues(alpha: 0.12),
      blurRadius: 40,
      offset: const Offset(0, 16),
      spreadRadius: -4,
    ),
  ];

  // --- Glassmorphism ---
  static Decoration glassDecoration({
    double opacity = 0.7,
    double blur = 18.0,
    Color? border,
  }) {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(radiusM),
      border: Border.all(
        color: border ?? Colors.white.withValues(alpha: 0.4),
        width: 1.5,
      ),
    );
  }

  // --- Animation Settings ---
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationNormal = Duration(milliseconds: 400);
  static const Duration durationSlow = Duration(milliseconds: 800);
  static const Curve curveStandard = Curves.easeInOutCubic;
  static const Curve curveEntrance = Curves.easeOutQuart;
}
