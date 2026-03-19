import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_colors.dart';
import '../../theme/sijang_design_system.dart';
import '../../widgets/shrinkable_button.dart';
import 'package:sijangyeojido_client/screens/map/market_hub_screen.dart';
import '../../widgets/skeleton.dart';
import '../explore/search_screen.dart';
import '../../services/favorite_service.dart';
import '../map/store_detail_screen.dart';
import '../../widgets/market_stories.dart';
import '../../widgets/flash_deal_ticker.dart';
import '../../widgets/sds_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _timer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
    
    // Simulate initial loading
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _isLoading = false);
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
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final openCount =
        MockData.stores.where((s) => s.status == StoreStatus.open).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Brand Header (V10 Branding) ──────────────────────
          // ── Premium Top Bar (V13) ──────────────────────────
          SliverToBoxAdapter(
            child: SDS.topBar(
              context: context,
              title: '시장여지도',
              subtitle: '우리 동네 시장 이야기를 만나보세요 👋',
              showBackButton: false,
              leading: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(SDS.radiusS),
                ),
                child: const Center(
                  child: Text('🗺️', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ),

          // ── Search Bar (Top) ──────────────────────────────────
          SliverToBoxAdapter(
            child: SDSFadeIn(
              offset: const Offset(0, -10),
              child: Container(
                color: AppColors.surface,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: ShrinkableButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SearchScreen()),
                    );
                  },
                  child: Container(
                    height: 58,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded,
                            color: AppColors.primary, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          '가게 이름 또는 상품 검색',
                          style: textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: SDS.fwBold,
                            letterSpacing: SDS.lsNormal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Cinematic Storytelling Header (V8) ──────────────────
          SliverToBoxAdapter(
            child: Container(
              height: 440,
              color: AppColors.surface,
              child: Stack(
                children: [
                    // Dynamic Narrative Image
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 1.08, end: 1.0),
                      duration: SDS.durationSlow,
                      curve: SDS.curveEntrance,
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage('https://images.unsplash.com/photo-1543007630-9710e4a00a20?auto=format&fit=crop&q=80&w=1500'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    // Refined Gradient Overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.65),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.75),
                              AppColors.surface,
                            ],
                            stops: const [0.0, 0.3, 0.8, 1.0],
                        ),
                      ),
                    ),
                    // Narrative Content
                    Positioned(
                      left: SDS.gutter,
                      right: SDS.gutter,
                      bottom: SDS.space40,
                      child: SDSFadeIn(
                        delay: const Duration(milliseconds: 300),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const Text(
                              '전통시장의 매력을\n시장여지도에서 📍',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: SDS.fwBlack,
                                color: Colors.white,
                                letterSpacing: SDS.lsTight * 2,
                                height: 1.1,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    blurRadius: 15,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: SDS.space16),
                            Text(
                              '오늘 가기 좋은 시장들을 모아봤어요 👋',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Colors.white.withValues(alpha: 0.95),
                                letterSpacing: -0.4,
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

          // ── V8 Dynamic Commerce (Flash Deal Ticker) ─────────────
          const SliverToBoxAdapter(
            child: SDSFadeIn(
              delay: Duration(milliseconds: 500),
              offset: Offset(0, 20),
              child: FlashDealTickerWidget(),
            ),
          ),

          // ── V8 Social Layer (Market Stories) ────────────────────
          const SliverPadding(
            padding: EdgeInsets.only(top: SDS.space24, bottom: SDS.space24),
            sliver: SliverToBoxAdapter(
              child: SDSFadeIn(
                delay: Duration(milliseconds: 600),
                offset: Offset(0, 20),
                child: MarketStoriesWidget(),
              ),
            ),
          ),



          // ── Favorites Section ──────────────────────────────────
          SliverToBoxAdapter(
            child: ListenableBuilder(
              listenable: FavoriteService(),
              builder: (context, _) {
                final favIds = FavoriteService().favoriteIds;
                if (favIds.isEmpty) return const SizedBox.shrink();

                final favStores = MockData.stores
                    .where((s) => favIds.contains(s.id))
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SDSFadeIn(
                      delay: const Duration(milliseconds: 700),
                      offset: const Offset(0, 20),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                        child: Row(
                          children: [
                            const Icon(Icons.favorite_rounded,
                                color: Colors.redAccent, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              '나의 단골집',
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SDSFadeIn(
                      delay: const Duration(milliseconds: 800),
                      offset: const Offset(0, 20),
                      child: SizedBox(
                        height: 140,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          scrollDirection: Axis.horizontal,
                          itemCount: favStores.length,
                          itemBuilder: (context, index) {
                            final store = favStores[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: ShrinkableButton(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => StoreDetailScreen(store: store),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 140,
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: SDS.shadowSoft,
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 52,
                                        height: 52,
                                        decoration: BoxDecoration(
                                          color: AppColors.background,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.storefront_rounded,
                                          color: AppColors.primary,
                                          size: 26,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        store.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),


          // ── Market Section ─────────────────────────────────────
          SliverToBoxAdapter(
            child: SDSFadeIn(
              delay: const Duration(milliseconds: 900),
              offset: const Offset(0, 20),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '지금,\n전통시장을 활짝 열어보세요 🎞️',
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                              height: 1.25,
                              letterSpacing: -1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '터치해서 실내 지도를 펼쳐보세요',
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '$openCount곳 영업 중',
                          style: textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

          SliverPadding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPadding + 100),
            sliver: _isLoading 
                ? SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const Padding(
                        padding: EdgeInsets.only(bottom: 14),
                        child: Skeleton(height: 160, borderRadius: 28),
                      ),
                      childCount: 3,
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final market = MockData.markets[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _MarketCard(
                            market: market,
                            openStoreCount: market.isAvailable ? openCount : 0,
                          ),
                        );
                      },
                      childCount: MockData.markets.length,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _MarketCard extends StatelessWidget {
  final MarketInfo market;
  final int openStoreCount;

  const _MarketCard({
    required this.market,
    required this.openStoreCount,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isAvailable = market.isAvailable;

    return SDSFadeIn(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: SDS.space8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(SDS.radiusL),
          boxShadow: isAvailable 
              ? SDS.shadowAccent(market.accentColor)
              : SDS.shadowSoft,
        ),
        child: SDS.listRow(
          onTap: () {
            if (!isAvailable) return;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MarketHubScreen(marketName: market.name)),
            );
          },
          leading: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isAvailable ? market.accentColor.withValues(alpha: 0.1) : AppColors.background,
              borderRadius: BorderRadius.circular(SDS.radiusM),
            ),
            child: Icon(
              Icons.storefront_rounded,
              color: isAvailable ? market.accentColor : AppColors.textTertiary,
              size: 26,
            ),
          ),
          title: Text(
            market.name,
            style: TextStyle(
              color: isAvailable ? AppColors.textPrimary : AppColors.textTertiary,
              fontWeight: SDS.fwBlack,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isAvailable ? market.description : '곧 서비스를 시작할 예정이에요',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (isAvailable) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: [
                    _StatusChip(
                      icon: Icons.map_rounded,
                      label: '지도 있어요',
                      color: market.accentColor,
                    ),
                    _StatusChip(
                      icon: Icons.bolt_rounded,
                      label: '빠른 탐색',
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ],
          ),
          trailing: isAvailable ? const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textTertiary) : null,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatusChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(SDS.radiusM),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}

