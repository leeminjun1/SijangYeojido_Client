import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';
import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/sijang_design_system.dart';
import '../../widgets/shrinkable_button.dart';
import '../../widgets/premium_placeholder.dart';
import '../../widgets/app_ui.dart';
import 'store_detail_screen.dart';
import 'market_map_screen.dart'; // To open the map as an optional quick-action

class MarketHubScreen extends StatefulWidget {
  final String marketName;
  const MarketHubScreen({super.key, this.marketName = '광장시장'});

  @override
  State<MarketHubScreen> createState() => _MarketHubScreenState();
}

class _MarketHubScreenState extends State<MarketHubScreen> {
  String _selectedCategory = '전체';
  static const _categories = ['전체', '먹거리', '정육', '수산물', '과일/채소', '건어물', '기타'];

  List<Store> get _filteredStores {
    return MockData.stores.where((s) {
      if (_selectedCategory != '전체' && !s.category.contains(_selectedCategory)) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final market = MockData.getMarket(widget.marketName);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── 1. Hero Header ──────────────────────────────────────────
          SliverAppBar(
            backgroundColor: AppColors.surface,
            expandedHeight: 200,
            pinned: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: Center(
              child: ShrinkableButton(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              expandedTitleScale: 1.2,
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 16),
              title: LayoutBuilder(
                builder: (context, constraints) {
                  // Simple logic to show title only when collapsed or partially collapsed
                  final top = constraints.biggest.height;
                  final isCollapsed = top < 100;
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isCollapsed ? 1.0 : 0.0,
                    child: Text(
                      widget.marketName,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                  );
                },
              ),
              background: Hero(
                tag: 'market_${widget.marketName}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            market.accentColor,
                            market.accentColor.withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.storefront_rounded, size: 80, color: Colors.white24),
                      ),
                    ),
                    // Bottom title for Expanded state
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Row(
                                    children: [
                                      const Text('📍', style: TextStyle(fontSize: 14)),
                                      const SizedBox(width: 6),
                                      Text(
                                        '핫플레이스',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                          color: market.accentColor,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: SDS.glassDecoration(opacity: 0.2, blur: 8),
                                  child: Text(
                                    '${MockData.stores.where((s) => s.status == StoreStatus.open).length}곳 영업 중',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.marketName,
                              style: textTheme.displayLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -1.0,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── 2. Info / Quick Action Panel ─────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.surface,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSectionHeader(
                    title: widget.marketName,
                    subtitle: '서울 종로구 창경궁로 88',
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    trailing: ShrinkableButton(
                      onTap: () {},
                      child: Text(
                        '정보',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionButton(
                          icon: Icons.map_rounded,
                          label: '실내 지도 보기',
                          color: market.accentColor,
                          onTap: () {
                            // Opens the old map view as a modal/tool
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MarketMapScreen(marketName: widget.marketName),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickActionButton(
                          icon: Icons.local_parking_rounded,
                          label: '주차장 안내',
                          color: AppColors.textPrimary,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickActionButton(
                          icon: Icons.local_offer_rounded,
                          label: '쿠폰함',
                          color: AppColors.orange,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Divider – seamless transition
          SliverToBoxAdapter(
            child: Container(height: 8, color: AppColors.background),
          ),

          // ── Summary Stats ──────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.surface,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Row(
                children: [
                  _MiniInfoChip(
                    icon: Icons.storefront_rounded,
                    label: '전체 ${MockData.stores.length}',
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  _MiniInfoChip(
                    icon: Icons.circle,
                    iconSize: 7,
                    label: '영업 중 ${MockData.stores.where((s) => s.status == StoreStatus.open).length}',
                    color: AppColors.success,
                  ),
                ],
              ),
            ),
          ),

          // ── 3. Sticky Categories ─────────────────────────────────
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyCategoryDelegate(
              categories: _categories,
              selectedCategory: _selectedCategory,
              onSelected: (cat) => setState(() => _selectedCategory = cat),
            ),
          ),

          // ── 4. Rich Store Feed ───────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final store = _filteredStores[index];
                  // If a search logic was added, we'd use it here. 
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _StoreFeedCard(store: store),
                  );
                },
                childCount: _filteredStores.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}


class _StickyCategoryDelegate extends SliverPersistentHeaderDelegate {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  _StickyCategoryDelegate({
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  double get minExtent => 60.0;
  @override
  double get maxExtent => 60.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.surface,
      alignment: Alignment.centerLeft,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = cat == selectedCategory;
          return ShrinkableButton(
            onTap: () => onSelected(cat),
            shrinkScale: 0.92,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.textPrimary : AppColors.surface,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  if (!isSelected)
                    const BoxShadow(
                      color: AppColors.cardShadowLight,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                ],
              ),
              child: Text(
                cat,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool shouldRebuild(_StickyCategoryDelegate oldDelegate) {
    return selectedCategory != oldDelegate.selectedCategory ||
           categories != oldDelegate.categories;
  }
}

class _StoreFeedCard extends StatelessWidget {
  final Store store;
  const _StoreFeedCard({required this.store});

  @override
  Widget build(BuildContext context) {
    return ShrinkableButton(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StoreDetailScreen(store: store),
          ),
        );
      },
      shrinkScale: 0.98, // Subtler shrink for large cards
      child: Container(
        margin: const EdgeInsets.only(bottom: SDS.spaceM),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(SDS.radiusM),
          boxShadow: SDS.shadowSoft,
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon/Image
                  Hero(
                    tag: 'store_image_${store.id}',
                    child: PremiumPlaceholder(
                      category: store.category,
                      width: 64,
                      height: 64,
                      borderRadius: 16,
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                store.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: store.status.bgColor,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                store.status.label,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: store.status.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textTertiary),
                            const SizedBox(width: 4),
                            Text(
                              '${store.zoneId}구역 ${store.unitNumber ?? ""}호',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('·', style: TextStyle(color: AppColors.textTertiary)),
                            const SizedBox(width: 8),
                            Text(
                              store.category,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Items preview
                        if (store.items.isNotEmpty)
                          ...store.items.take(2).map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: const BoxDecoration(
                                    color: AppColors.textTertiary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                                if (item.price != null)
                                  Text(
                                    '${NumberFormat('#,###', 'ko_KR').format(item.price)}원',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                              ],
                            ),
                          )),
                        const SizedBox(height: 8),
                        // Payment methods as tags
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: store.paymentMethods.map((pm) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              pm.label,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniInfoChip extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final String label;
  final Color color;

  const _MiniInfoChip({
    required this.icon,
    this.iconSize = 12,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}


class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ShrinkableButton(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(SDS.radiusM),
          border: Border.all(color: color.withValues(alpha: 0.12), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: color,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
