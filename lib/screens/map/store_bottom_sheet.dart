import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';
import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_ui.dart';

class StoreBottomSheet extends StatelessWidget {
  final Store store;
  final VoidCallback onClose;
  final VoidCallback? onRouteSelect;

  const StoreBottomSheet({
    super.key,
    required this.store,
    required this.onClose,
    this.onRouteSelect,
  });

  static void show(BuildContext context, Store store, {VoidCallback? onRouteSelect}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.35,
        maxChildSize: 0.9,
        builder: (context, scrollController) => _SheetContent(
          store: store,
          scrollController: scrollController,
          onRouteSelect: onRouteSelect,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _SheetContent(store: store, scrollController: ScrollController());
  }
}

class _SheetContent extends StatelessWidget {
  final Store store;
  final ScrollController scrollController;
  final VoidCallback? onRouteSelect;

  const _SheetContent({
    required this.store,
    required this.scrollController,
    this.onRouteSelect,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final zone = MockData.getZoneById(store.zoneId);
    final daysSinceUpdate = store.lastUpdated != null
        ? DateTime.now().difference(store.lastUpdated!).inDays
        : null;
    final isStale = daysSinceUpdate != null && daysSinceUpdate > 7;
    final fmt = NumberFormat('#,###', 'ko_KR');

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 24,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),

          // Hero header (rebrand-style)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withValues(alpha: 0.14),
                  AppColors.accent.withValues(alpha: 0.10),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on_rounded,
                              size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            '${store.zoneId}구역${store.unitNumber != null ? " · ${store.unitNumber}호" : ""}',
                            style: textTheme.labelLarge?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        store.status.label,
                        style: textTheme.labelLarge?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: store.status.color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  store.name,
                  style: textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.8,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  store.category,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (zone != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.map_rounded, size: 16, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          '${zone.name} · ${zone.description}',
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (daysSinceUpdate != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isStale ? AppColors.warningLight : AppColors.successLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isStale
                              ? Icons.warning_amber_rounded
                              : Icons.check_circle_outline_rounded,
                          size: 14,
                          color: isStale ? AppColors.warning : AppColors.success,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          daysSinceUpdate == 0
                              ? '오늘 업데이트됨'
                              : daysSinceUpdate == 1
                                  ? '어제 업데이트됨'
                                  : '$daysSinceUpdate일 전 업데이트',
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isStale ? AppColors.warning : AppColors.success,
                          ),
                        ),
                        if (store.infoSource != null) ...[
                          const SizedBox(width: 6),
                          Text(
                            '· ${store.infoSource}',
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Payment methods
          AppSectionHeader(
            title: '결제 수단',
            subtitle: '가능한 결제 방식을 한눈에 확인하세요',
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: store.paymentMethods
                .map((p) => _PaymentChip(method: p))
                .toList(),
          ),

          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 16),

          // Items
          AppSectionHeader(
            title: '대표 상품',
            subtitle: '많이 찾는 상품부터 확인해보세요',
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
          ),
          const SizedBox(height: 12),
          ...store.items.map(
            (item) => Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.divider,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (item.price != null)
                    Text(
                      '${fmt.format(item.price)}원',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                ],
              ),
            ),
          ),



          const SizedBox(height: 24),

          // Action row
          Row(
            children: [
              Expanded(
                flex: 1,
                child: _SecondaryActionButton(
                  icon: Icons.favorite_border_rounded,
                  label: '단골할래요',
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: _SecondaryActionButton(
                  icon: Icons.edit_note_rounded,
                  label: '정보 수정',
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: AppPrimaryButton(
                  label: '길 안내 시작',
                  onPressed: () {
                    Navigator.pop(context); // close sheet
                    if (onRouteSelect != null) onRouteSelect!();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentChip extends StatelessWidget {
  final PaymentMethod method;
  const _PaymentChip({required this.method});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        method.label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}


class _SecondaryActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SecondaryActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.divider,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
