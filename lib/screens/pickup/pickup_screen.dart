import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_ui.dart';

class PickupScreen extends StatefulWidget {
  final Reservation reservation;

  const PickupScreen({super.key, required this.reservation});

  @override
  State<PickupScreen> createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  late Timer _timer;
  late Duration _remaining;

  static const _totalSeconds = 15 * 60; // 15 minutes

  @override
  void initState() {
    super.initState();
    _remaining = widget.reservation.remainingTime;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final diff = widget.reservation.expiresAt.difference(DateTime.now());
      setState(() {
        _remaining = diff.isNegative ? Duration.zero : diff;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  double get _progress {
    final elapsed = _totalSeconds - _remaining.inSeconds;
    return (elapsed / _totalSeconds).clamp(0.0, 1.0);
  }

  void _onCancel() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          '예약 취소',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        content: const Text(
          '예약을 취소하시겠습니까?\n취소 후에는 되돌릴 수 없습니다.',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '유지하기',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              '취소하기',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isExpired = _remaining == Duration.zero;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        automaticallyImplyLeading: false,
        title: Text(
          '픽업 코드',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
            const SizedBox(height: 8),

            // Hero banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isExpired
                      ? [
                          AppColors.divider,
                          AppColors.background,
                        ]
                      : [
                          AppColors.primary.withValues(alpha: 0.14),
                          AppColors.accent.withValues(alpha: 0.12),
                        ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isExpired
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_outline_rounded,
                      color: isExpired ? AppColors.textTertiary : AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isExpired ? '픽업 코드가 만료되었습니다' : '픽업 준비 완료',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isExpired
                              ? '예약이 만료되어 사용할 수 없어요'
                              : '점포에서 코드를 보여주면 픽업이 완료돼요',
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Circular countdown
            SizedBox(
              width: 180,
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: CircularProgressIndicator(
                      value: 1 - _progress,
                      strokeWidth: 8,
                      backgroundColor: AppColors.border,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isExpired ? AppColors.textTertiary : AppColors.primary,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatDuration(_remaining),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: isExpired
                              ? AppColors.textTertiary
                              : AppColors.primary,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isExpired ? '만료됨' : '남은 시간',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Pickup code
            Text(
              '픽업 코드',
              style: textTheme.labelLarge?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              decoration: BoxDecoration(
                color: isExpired ? AppColors.divider : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isExpired
                      ? AppColors.border
                      : AppColors.primary.withValues(alpha: 0.4),
                  width: 2,
                ),
                boxShadow: isExpired
                    ? null
                    : [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Text(
                widget.reservation.pickupCode,
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w900,
                  color: isExpired
                      ? AppColors.textTertiary
                      : AppColors.primary,
                  letterSpacing: 12,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // QR code placeholder
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 1.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_2,
                    size: 80,
                    color: isExpired
                        ? AppColors.textTertiary
                        : AppColors.textPrimary,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'QR 코드',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Store info
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '예약 정보',
                    style: textTheme.labelLarge?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(label: '점포명', value: widget.reservation.storeName),
                  const SizedBox(height: 8),
                  _InfoRow(label: '상품', value: widget.reservation.itemName),
                  const SizedBox(height: 8),
                  _InfoRow(
                    label: '수량',
                    value: '${widget.reservation.quantity}개',
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    label: '결제 금액',
                    value:
                        '${widget.reservation.totalAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}원',
                  ),
                ],
              ),
            ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Bottom fixed actions
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              MediaQuery.of(context).padding.bottom + 12,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.cardShadowLight,
                  blurRadius: 20,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppPrimaryButton(
                  label: isExpired ? '닫기' : '픽업 완료했어요',
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: isExpired ? null : _onCancel,
                  child: Text(
                    '예약 취소하기',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color:
                          isExpired ? AppColors.textTertiary : AppColors.danger,
                      decoration: TextDecoration.underline,
                      decorationColor:
                          isExpired ? AppColors.textTertiary : AppColors.danger,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
