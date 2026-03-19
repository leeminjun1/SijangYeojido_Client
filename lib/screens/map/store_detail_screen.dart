import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';
import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/sijang_design_system.dart';
import '../../widgets/sds_widgets.dart';
import '../../widgets/shrinkable_button.dart';
import '../../widgets/app_ui.dart';
import '../../services/favorite_service.dart';

class StoreDetailScreen extends StatelessWidget {
  final Store store;
  const StoreDetailScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final zone = MockData.getZoneById(store.zoneId);
    // final daysSinceUpdate = store.lastUpdated != null
    //     ? DateTime.now().difference(store.lastUpdated!).inDays
    //     : null;

    // final isStale = (daysSinceUpdate ?? 0) > 7;

    final fmt = NumberFormat('#,###', 'ko_KR');
    final market = MockData.getMarket(store.marketName);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Premium Cinematic Top Bar (V16) ──────────────────────────
          SDS.topBar(
            context: context,
            title: store.name,
            subtitle: '${market.name}에서 사랑받는 점포예요 ✨',
            actions: [
              ListenableBuilder(
                listenable: FavoriteService(),
                builder: (context, _) {
                  final isFav = FavoriteService().isFavorite(store.id);
                  return _ActionIconButton(
                    icon: isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: isFav ? Colors.redAccent : AppColors.textPrimary,
                    onTap: () => FavoriteService().toggleFavorite(store.id),
                  );
                },
              ),
              const SizedBox(width: 8),
              _ActionIconButton(
                icon: Icons.share_rounded,
                onTap: () {
                   ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${store.name} 정보를 친구와 나누어 보세요!')),
                  );
                },
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header: Immersive Hero Area ---
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          market.accentColor.withValues(alpha: 0.15),
                          market.accentColor.withValues(alpha: 0.05),
                          AppColors.background,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(24, MediaQuery.of(context).padding.top + 40, 24, 40),
                    child: Column(
                      children: [
                        Hero(
                          tag: 'store_image_${store.id}',
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(SDS.radiusXL),
                              boxShadow: SDS.shadowPremium,
                            ),
                            child: Center(
                              child: Icon(
                                _iconForCategory(store.category),
                                size: 64,
                                color: market.accentColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          '지금 이 가게는요',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: SDS.fwBold,
                            color: AppColors.textSecondary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _StatusBadge(status: store.status),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          store.name,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: SDS.fwBlack,
                            letterSpacing: SDS.lsTight,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded, size: 16, color: AppColors.textTertiary),
                            const SizedBox(width: 8),
                            Text(
                              '${zone?.name ?? ""} • ${store.unitNumber ?? ""}호',
                              style: const TextStyle(
                                fontWeight: SDS.fwBold,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '방금 따끈따끈한 소식이 도착했어요 ✨',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: SDS.fwBold,
                            color: market.accentColor,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- Details Sections ---
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                    child: Column(
                      children: [
                        // Payment methods
                        _SectionCard(
                          title: '결제 수단',
                          delayMs: 400,
                          child: store.paymentMethods.isEmpty
                              ? AppEmptyState(
                                  icon: Icons.payments_outlined,
                                  title: '어떤 결제 수단을 받으시나요?',
                                  description: '직접 결제해본 경험을 알려주시면\n다른 분들에게 큰 도움이 돼요',
                                )
                              : Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: store.paymentMethods
                                      .map((m) => _PaymentChip(method: m))
                                      .toList(),
                                ),
                        ),

                        const SizedBox(height: 16),

                        // Items
                        _SectionCard(
                          title: '대표 상품',
                          delayMs: 500,
                          child: store.items.isEmpty
                              ? AppEmptyState(
                                  icon: Icons.inventory_2_outlined,
                                  title: '이 가게의 대표 상품을 알고 싶어요',
                                  description: '가장 자신 있는 상품을 알려주시면\n이곳에 정성껏 소개해 드릴게요',
                                )
                              : Column(
                                  children: store.items.asMap().entries.map((entry) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: AppColors.background,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                gradient: AppUI.primaryGradient,
                                                shape: BoxShape.circle,
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                '${entry.key + 1}',
                                                style: textTheme.labelSmall?.copyWith(
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 14),
                                            Expanded(
                                              child: Text(
                                                entry.value.name,
                                                style: textTheme.bodyLarge?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                            ),
                                            if (entry.value.price != null)
                                              Text(
                                                '${fmt.format(entry.value.price)}원',
                                                style: textTheme.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.w900,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                        ),

                        const SizedBox(height: 16),
                        _buildSocialReviews(context),
                        const SizedBox(height: 16),
                        _buildRealTimeInsight(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // --- Premium Bottom Action Bar (V13) ---
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: SDS.shadowPremium,
          border: const Border(top: BorderSide(color: Color(0xFFF2F4F6))),
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ActionIconButton(
                  icon: Icons.phone_rounded,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${store.name}으로 전화를 연결해요! 📞')),
                    );
                  },
                ),
                const SizedBox(height: 6),
                const Text('상담/전화', style: TextStyle(fontSize: 11, fontWeight: SDS.fwBold, color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SDS.button(
                label: '길 안내 시작',
                isPrimary: false,
                icon: Icons.directions_rounded,
                onTap: () => Navigator.pop(context, true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SDS.button(
                label: '점포 상품 예약',
                color: market.accentColor,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('곧 멋진 예약 시스템으로 찾아뵐게요!')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialReviews(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final storeReviews = MockData.reviews.where((r) => r.storeId == store.id).toList();

    return _SectionCard(
      title: '방문자 리뷰 💬',
      child: storeReviews.isEmpty
          ? AppEmptyState(
              icon: Icons.rate_review_outlined,
              title: '다녀오신 후 리뷰를 남겨주세요',
              description: '직접 방문한 경험을 들려주시면\n다른 분들에게 큰 도움이 돼요!',
            )
          : Column(
              children: [
                ...storeReviews.map((review) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(review.userAvatar),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review.userName,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.star_rounded, size: 12, color: Colors.amber[600]),
                                    const SizedBox(width: 4),
                                    Text(
                                      review.rating.toString(),
                                      style: textTheme.labelSmall?.copyWith(
                                        color: Colors.amber[800],
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '2일 전', // Simplified for mock
                            style: textTheme.bodySmall?.copyWith(color: AppColors.textTertiary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        review.content,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      if (review.images.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 100,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: review.images.length,
                            separatorBuilder: (context, index) => const SizedBox(width: 8),
                            itemBuilder: (context, idx) => ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                review.images[idx],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Divider(color: AppColors.divider, height: 1),
                      ),
                    ],
                  ),
                )),
                const SizedBox(height: 8),
                ShrinkableButton(
                  onTap: () => _showReviewSubmitSheet(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        '리뷰 전체 보기',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildRealTimeInsight(BuildContext context) {
    if (store.freshness == null && store.inventoryStatus == null) return const SizedBox.shrink();
    
    final textTheme = Theme.of(context).textTheme;
    return _SectionCard(
      title: '지금 가게 상황은 어때요? ⚡',
      child: Column(
        children: [
          if (store.freshness != null) ...[
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 16),
                          const SizedBox(width: 6),
                          Text(
                            '품질 신선도가 이만큼이에요',
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: LinearProgressIndicator(
                          value: store.freshness! / 100,
                          minHeight: 8,
                          backgroundColor: AppColors.background,
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Text(
                  '${store.freshness}%',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ],
          if (store.freshness != null && store.inventoryStatus != null)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1, color: AppColors.divider),
            ),
          if (store.inventoryStatus != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.inventory_2_rounded, color: AppColors.primary, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      '재고가 얼마나 남았을까요?',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: store.inventoryStatus == '품절' ? Colors.red.withValues(alpha: 0.1) : AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    store.inventoryStatus!,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: store.inventoryStatus == '품절' ? Colors.red : AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  IconData _iconForCategory(String category) {
    if (category.contains('먹거리')) return Icons.restaurant_rounded;
    if (category.contains('수산')) return Icons.set_meal_rounded;
    if (category.contains('정육')) return Icons.kebab_dining_rounded;
    if (category.contains('과일') || category.contains('채소')) return Icons.eco_rounded;
    if (category.contains('건어물')) return Icons.water_drop_rounded;
    return Icons.storefront_rounded;
  }
  void _showReviewSubmitSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 24),
            Text('방문은 어떠셨나요?', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: SDS.fwBlack, letterSpacing: SDS.lsTight)),
            const SizedBox(height: 8),
            Text('이 가게에 대한 솔직한 후기를 들려주세요.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) => Icon(Icons.star_rounded, size: 40, color: index < 4 ? AppColors.warning : AppColors.divider)),
            ),
            const SizedBox(height: 24),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: '음식의 맛, 서비스, 분위기 등에 대해 알려주세요.',
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),
            AppPrimaryButton(
              label: '리뷰를 등록할게요',
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('리뷰가 성공적으로 등록되었어요! ✨')));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final double delayMs;

  const _SectionCard({
    required this.title,
    required this.child,
    this.delayMs = 0,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SDSFadeIn(
      delay: Duration(milliseconds: delayMs.toInt()),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: SDS.space24),
        padding: const EdgeInsets.all(SDS.space24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(SDS.radiusL),
          boxShadow: SDS.shadowPremium,
          border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(SDS.radiusS),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: SDS.space20),
            child,
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final StoreStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status.bgColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: status.color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: status.color.withValues(alpha: 0.3),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            status.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: status.color,
            ),
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
    final textTheme = Theme.of(context).textTheme;
    final color = _colorFor(method);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _iconFor(method),
            size: 18,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            method.label,
            style: textTheme.labelLarge?.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(PaymentMethod m) {
    switch (m) {
      case PaymentMethod.cash:
        return Icons.payments_rounded;
      case PaymentMethod.card:
        return Icons.credit_card_rounded;
      case PaymentMethod.zeroPay:
        return Icons.qr_code_2_rounded;
      case PaymentMethod.kakao:
        return Icons.chat_bubble_rounded;
    }
  }

  Color _colorFor(PaymentMethod m) {
    switch (m) {
      case PaymentMethod.cash:
        return const Color(0xFF16A34A);
      case PaymentMethod.card:
        return const Color(0xFF2563EB);
      case PaymentMethod.zeroPay:
        return const Color(0xFF00C7AE);
      case PaymentMethod.kakao:
        return const Color(0xFFFFE812);
    }
  }
}

// Removed unused _ActionIconBtn

class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;

  const _ActionIconButton({
    required this.icon,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ShrinkableButton(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F4F6),
          borderRadius: BorderRadius.circular(SDS.radiusM),
        ),
        child: Icon(icon, color: color ?? const Color(0xFF4E5968), size: 22),
      ),
    );
  }
}
