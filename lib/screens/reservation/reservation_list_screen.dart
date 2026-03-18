import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../../models/models.dart';
import '../../data/mock_data.dart';
import '../pickup/pickup_screen.dart';
import '../../widgets/app_ui.dart';

class ReservationListScreen extends StatefulWidget {
  const ReservationListScreen({super.key});

  @override
  State<ReservationListScreen> createState() => _ReservationListScreenState();
}

class _ReservationListScreenState extends State<ReservationListScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final active = MockData.reservations.where((r) => r.isActive).toList();
    final past = MockData.reservations.where((r) => !r.isActive).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            centerTitle: false,
            title: Text(
              '예약',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (active.isEmpty && past.isEmpty)
            SliverFillRemaining(
              child: _EmptyState(),
            )
          else ...[
            if (active.isNotEmpty) ...[
              _sectionHeader(
                context: context,
                title: '진행 중',
                count: active.length,
                color: AppColors.primary,
                subtitle: '픽업 전까지 남은 시간을 확인하세요',
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _ActiveReservationCard(
                    reservation: active[i],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PickupScreen(reservation: active[i]),
                      ),
                    ),
                  ),
                  childCount: active.length,
                ),
              ),
            ],
            if (past.isNotEmpty) ...[
              _sectionHeader(
                context: context,
                title: '지난 예약',
                count: past.length,
                color: AppColors.textSecondary,
                subtitle: '완료/만료 내역을 모아봤어요',
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _PastReservationCard(reservation: past[i]),
                  childCount: past.length,
                ),
              ),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ],
      ),
    );
  }

  Widget _sectionHeader({
    required BuildContext context,
    required String title,
    required int count,
    required Color color,
    String? subtitle,
  }) {
    return SliverToBoxAdapter(
      child: AppSectionHeader(
        title: '$title · $count',
        subtitle: subtitle,
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
          ),
        ),
      ),
    );
  }
}

class _ActiveReservationCard extends StatelessWidget {
  final Reservation reservation;
  final VoidCallback onTap;

  const _ActiveReservationCard({required this.reservation, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final remaining = reservation.remainingTime;
    final mins = remaining.inMinutes;
    final secs = remaining.inSeconds % 60;
    final isUrgent = mins < 5;
    final fmt = NumberFormat('#,###');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withValues(alpha: isUrgent ? 0.16 : 0.12),
                    AppColors.accent.withValues(alpha: isUrgent ? 0.14 : 0.10),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: isUrgent
                        ? AppColors.primary.withValues(alpha: 0.08)
                        : AppColors.cardShadow,
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reservation.itemName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              reservation.storeName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isUrgent
                              ? AppColors.primary
                              : AppColors.surface.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: isUrgent ? Colors.transparent : AppColors.border,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer_rounded,
                              size: 14,
                              color: isUrgent ? Colors.white : AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$mins:${secs.toString().padLeft(2, '0')}',
                              style: textTheme.labelLarge?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: isUrgent
                                    ? Colors.white
                                    : AppColors.textPrimary,
                                fontFeatures: const [
                                  FontFeature.tabularFigures()
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppCard(
                    padding: const EdgeInsets.all(12),
                    backgroundColor: AppColors.surface.withValues(alpha: 0.9),
                    child: Row(
                      children: [
                        Expanded(
                          child: _InfoItem(
                              label: '수량', value: '${reservation.quantity}개'),
                        ),
                        Expanded(
                          child: _InfoItem(
                            label: '결제금액',
                            value: '${fmt.format(reservation.totalAmount)}원',
                          ),
                        ),
                        Expanded(
                          child: _InfoItem(
                            label: '픽업코드',
                            value: reservation.pickupCode,
                            valueStyle: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                              letterSpacing: 3,
                              fontFeatures: const [
                                FontFeature.tabularFigures()
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppPrimaryButton(label: '픽업 코드 보기', onPressed: onTap),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _InfoItem({required this.label, required this.value, this.valueStyle});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            fontSize: 11,
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: valueStyle ??
              textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
        ),
      ],
    );
  }
}

class _PastReservationCard extends StatelessWidget {
  final Reservation reservation;

  const _PastReservationCard({required this.reservation});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final fmt = NumberFormat('#,###');

    return AppCard(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: reservation.isCompleted
                  ? AppColors.successLight
                  : AppColors.background,
              shape: BoxShape.circle,
            ),
            child: Icon(
              reservation.isCompleted ? Icons.check_circle : Icons.cancel,
              color: reservation.isCompleted
                  ? AppColors.success
                  : AppColors.textTertiary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reservation.itemName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  reservation.storeName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${fmt.format(reservation.totalAmount)}원',
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: reservation.isCompleted
                      ? AppColors.successLight
                      : AppColors.divider,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  reservation.isCompleted ? '픽업 완료' : '만료',
                  style: textTheme.labelLarge?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: reservation.isCompleted
                        ? AppColors.success
                        : AppColors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: AppEmptyState(
        icon: Icons.receipt_long_outlined,
        title: '아직 예약 내역이 없어요',
        description: '지도에서 점포를 눌러\n특가 딜을 예약해보세요',
      ),
    );
  }
}
