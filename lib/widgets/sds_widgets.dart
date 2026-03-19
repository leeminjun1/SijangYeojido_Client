import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/sijang_design_system.dart';
import 'shrinkable_button.dart';

/// SDS (Sijang Design System) Core Widgets
/// Highly refined, premium UI components following TDS patterns.

/// --- SDS List Row ---
/// A standardized row for lists with various padding and icon options.
class SDSListRow extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;
  final double paddingLevel; // 1: S, 2: M, 3: L, 4: XL

  const SDSListRow({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.showDivider = false,
    this.paddingLevel = 2,
  });

  @override
  Widget build(BuildContext context) {
    double verticalPadding;
    switch (paddingLevel) {
      case 1: verticalPadding = 14.0; break; // S (approx 44-48dp total)
      case 3: verticalPadding = SDS.space24; break; // L
      case 4: verticalPadding = SDS.space32; break; // XL
      case 2:
      default: verticalPadding = SDS.space18; break; // M (More spacious)
    }

    final row = Container(
      padding: EdgeInsets.symmetric(horizontal: SDS.gutter, vertical: verticalPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: showDivider ? const Border(bottom: BorderSide(color: AppColors.divider, width: 0.8)) : null,
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: SDS.space16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.4,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: SDS.space12),
            trailing!,
          ] else if (onTap != null) ...[
            const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 24),
          ],
        ],
      ),
    );

    if (onTap == null) return row;
    return ShrinkableButton(onTap: onTap, child: row);
  }
}

/// --- SDS Button ---
/// Premium button with scale animation and sophisticated gradients.
class SDSButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isPrimary;
  final IconData? icon;
  final Color? color;

  const SDSButton({
    super.key,
    required this.label,
    this.onTap,
    this.isPrimary = true,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = color ?? (isPrimary ? AppColors.primary : AppColors.background);
    final textColor = isPrimary ? Colors.white : AppColors.textPrimary;

    return ShrinkableButton(
      onTap: onTap,
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          color: themeColor,
          borderRadius: BorderRadius.circular(SDS.radiusM),
          boxShadow: isPrimary ? SDS.shadowAccent(themeColor) : null,
          border: isPrimary ? null : Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: textColor),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: textColor,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// --- SDS Top Bar (Immersive) ---
/// Transparent navigation bar with glassmorphism support.
class SDSTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool showBackButton;
  final Color? backgroundColor;

  const SDSTopBar({
    super.key,
    this.title,
    this.actions,
    this.showBackButton = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          height: 56 + MediaQuery.of(context).padding.top,
          color: backgroundColor ?? AppColors.surface.withValues(alpha: 0.85),
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Stack(
            children: [
              // --- Title ---
              if (title != null)
                Center(
                  child: Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),

              // --- Content Row ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    if (showBackButton)
                      ShrinkableButton(
                        onTap: () => Navigator.maybePop(context),
                        child: const SizedBox(
                          width: 44,
                          height: 44,
                          child: Icon(Icons.arrow_back_ios_new_rounded,
                              size: 20, color: AppColors.textPrimary),
                        ),
                      ),
                    const Spacer(),
                    if (actions != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: actions!,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

/// --- SDS Staggered Entrance Animation ---
class SDSFadeIn extends StatelessWidget {
  final Widget child;
  final Duration delay;
  final Offset offset;

  const SDSFadeIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 30),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: SDS.durationNormal,
      curve: SDS.curveEntrance,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: offset * (1 - value),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

/// --- SDS Floating Tabbar ---
/// A premium, floating capsule-style tab bar following TDS guidelines.
class SDSFloatingTabbar extends StatelessWidget {
  final int currentIndex;
  final List<SDSFloatingTabItem> items;
  final Function(int) onTap;

  const SDSFloatingTabbar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      height: 64,
      decoration: SDS.glassDecoration(
        radius: SDS.radiusCapsule,
        opacity: 0.92,
        blur: 24,
      ).copyWith(
        boxShadow: SDS.shadowPremium,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = currentIndex == index;

          return Expanded(
            child: ShrinkableButton(
              onTap: () => onTap(index),
              shrinkScale: 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedScale(
                    scale: isSelected ? 1.1 : 1.0,
                    duration: SDS.durationFast,
                    curve: Curves.easeOutBack,
                    child: Icon(
                      isSelected ? item.activeIcon : item.icon,
                      color: isSelected ? AppColors.primary : AppColors.textTertiary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedDefaultTextStyle(
                    duration: SDS.durationFast,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                      color: isSelected ? AppColors.primary : AppColors.textTertiary,
                      letterSpacing: -0.5,
                    ),
                    child: Text(item.label),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class SDSFloatingTabItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const SDSFloatingTabItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

/// --- Premium Placeholder ---
/// A sophisticated placeholder for store images with category icons.
class PremiumPlaceholder extends StatelessWidget {
  final String category;
  final double width;
  final double height;
  final double borderRadius;

  const PremiumPlaceholder({
    super.key,
    required this.category,
    this.width = 48,
    this.height = 48,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Icon(
          _iconForCategory(category),
          color: AppColors.primary,
          size: width * 0.5,
        ),
      ),
    );
  }

  IconData _iconForCategory(String category) {
    if (category.contains('먹거리')) return Icons.restaurant_rounded;
    if (category.contains('수산')) return Icons.set_meal_rounded;
    if (category.contains('정육')) return Icons.kebab_dining_rounded;
    if (category.contains('과일') || category.contains('채소')) return Icons.eco_rounded;
    return Icons.storefront_rounded;
  }
}
