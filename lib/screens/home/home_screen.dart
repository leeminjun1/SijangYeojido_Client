import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_colors.dart';
import '../../widgets/shrinkable_button.dart';
import 'package:sijangyeojido_client/screens/map/market_hub_screen.dart';
import '../../widgets/skeleton.dart';

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

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 6) return '늦은 밤이에요 🌙';
    if (hour < 12) return '좋은 아침이에요 ☀️';
    if (hour < 17) return '좋은 오후예요 👋';
    return '좋은 저녁이에요 🌆';
  }


  String get _dateString {
    final now = DateTime.now();
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final m = now.month;
    final d = now.day;
    final w = weekdays[now.weekday - 1];
    return '$m월 $d일 $w요일';
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
          // ── Greeting Header ────────────────────────────────────
          SliverAppBar(
            backgroundColor: AppColors.surface,
            surfaceTintColor: AppColors.surface,
            scrolledUnderElevation: 0,
            expandedHeight: 140,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Text(
                '시장여지도',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: AppColors.textPrimary,
                ),
              ),
              background: Container(
                color: AppColors.surface,
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 52),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _greeting,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _dateString,
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Search Bar ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.surface,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.search,
                        color: AppColors.textTertiary, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      '찾으시는 시장이 있나요?',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),


          // ── Market Section ─────────────────────────────────────
          SliverToBoxAdapter(
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
                          '내 주변에 있는\n활기찬 전통시장 🗺️',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                            height: 1.3,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '터치해서 실내 지도를 펼쳐보세요',
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
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
                        final market = _mockMarkets[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _MarketCard(
                            market: market,
                            openStoreCount: market.isAvailable ? openCount : 0,
                          ),
                        );
                      },
                      childCount: _mockMarkets.length,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _MarketCard extends StatelessWidget {
  final _MarketInfo market;
  final int openStoreCount;

  const _MarketCard({
    required this.market,
    required this.openStoreCount,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ShrinkableButton(
      onTap: () {
        if (!market.isAvailable) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MarketHubScreen(marketName: market.name),
          ),
        );
      },
      shrinkScale: 0.98,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: market.isAvailable
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.08),
                    AppColors.accent.withValues(alpha: 0.06),
                  ],
                )
              : null,
          color: market.isAvailable ? null : AppColors.surface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: market.isAvailable
                  ? AppColors.primary.withValues(alpha: 0.08)
                  : AppColors.cardShadowLight,
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          market.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: market.isAvailable
                                ? AppColors.textPrimary
                                : AppColors.textTertiary,
                            letterSpacing: -0.6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (market.isAvailable)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            '실내 지도',
                            style: textTheme.labelLarge?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    market.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: market.isAvailable
                          ? AppColors.textSecondary
                          : AppColors.textTertiary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Stats row (only for available markets)
                  if (market.isAvailable) ...[
                    Row(
                      children: [
                        _MiniStat(
                          icon: Icons.storefront_rounded,
                          label: '$openStoreCount곳 영업 중',
                          color: AppColors.success,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: market.highlights.map((h) {
                      final color = market.isAvailable
                          ? AppColors.primary
                          : AppColors.textTertiary;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: market.isAvailable
                              ? AppColors.surface.withValues(alpha: 0.85)
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          '#$h',
                          style: textTheme.labelLarge?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: color,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (market.isAvailable)
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_forward_rounded,
                    color: Colors.white),
              )
            else
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '준비 중',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MiniStat({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ── Mock Market Data ─────────────────────────────────────────────────────────

class _MarketInfo {
  final String name;
  final String description;
  final String address;
  final int storeCount;
  final List<String> highlights;
  final Color accentColor;
  final bool isAvailable;

  const _MarketInfo({
    required this.name,
    required this.description,
    required this.address,
    required this.storeCount,
    required this.highlights,
    required this.accentColor,
    required this.isAvailable,
  });
}

const List<_MarketInfo> _mockMarkets = [
  _MarketInfo(
    name: '광장시장',
    description: '100년 전통, 빈대떡과 육회의 성지',
    address: '서울 종로구 창경궁로 88',
    storeCount: 5240,
    highlights: ['먹거리명소', '빈대떡', '마약김밥'],
    accentColor: Color(0xFFF04452),
    isAvailable: true,
  ),
  _MarketInfo(
    name: '경동시장',
    description: '도심 속 최대 규모의 농수산물 특화 시장',
    address: '서울 동대문구 고산자로36길 3',
    storeCount: 3120,
    highlights: ['한약재', '신선도', '도매가'],
    accentColor: Color(0xFF16A34A),
    isAvailable: false,
  ),
  _MarketInfo(
    name: '망원시장',
    description: '트렌디한 먹거리와 젊음이 가득한 시장',
    address: '서울 마포구 포은로8길 14',
    storeCount: 1850,
    highlights: ['닭강정', '디저트', '데이트코스'],
    accentColor: Color(0xFF2563EB),
    isAvailable: false,
  ),
];
