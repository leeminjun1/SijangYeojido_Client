import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/sijang_design_system.dart';
import '../../widgets/shrinkable_button.dart';

class MarketInfoScreen extends StatelessWidget {
  final String marketName;
  const MarketInfoScreen({super.key, required this.marketName});

  // Gwangjang Heritage Red
  static const Color gwangjangRed = Color(0xFFF04452);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ShrinkableButton(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.only(left: 20.0), // Nuclear Buffer
              child: Text(
                '\u00A0시장 정보를\n\u00A0확인해 보세요',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: SDS.fwBlack,
                  color: AppColors.textPrimary,
                  height: 1.3,
                  letterSpacing: 0.8,
                ),
                overflow: TextOverflow.visible,
              ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                '\u00A0대한민국 대표 전통시장, 광장시장은 100년의 역사를 가진 먹거리와 볼거리의 성지입니다.',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary, fontWeight: SDS.fwBold, height: 1.6),
              ),
            ),
            const SizedBox(height: 32),

            // ─── REDESIGNED: Unified Utility Hub (Bento Style) ───
            _buildBentoUtilityHub(),
            const SizedBox(height: 48),

            _buildNuclearInfoSection(
              title: '이용 가이드',
              items: [
                _buildNuclearInfoItem(Icons.access_time_filled_rounded, '영업 시간', '매일 09:00 - 23:00'),
                _buildNuclearInfoItem(Icons.info_rounded, '주요 품목', '마약김밥, 빈대떡, 육회, 한복'),
                _buildNuclearInfoItem(Icons.payment_rounded, '결제 수단', '온누리상품권, 제로페이 가능'),
              ],
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildBentoUtilityHub() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SDS.radiusL),
        boxShadow: SDS.shadowPremium,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                const SizedBox(width: 8),
                const Icon(Icons.stars_rounded, color: gwangjangRed, size: 20),
                const SizedBox(width: 10),
                const Text(
                  '시장 핵심 기능',
                  style: TextStyle(fontSize: 14, fontWeight: SDS.fwBlack, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF2F4F6)),
          Row(
            children: [
              _buildBentoTile(Icons.phone_in_talk_rounded, '전화하기', isFirst: true),
              _buildBentoTile(Icons.map_rounded, '위치보기'),
              _buildBentoTile(Icons.share_rounded, '공유하기', isLast: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBentoTile(IconData icon, String label, {bool isFirst = false, bool isLast = false}) {
    return Expanded(
      child: ShrinkableButton(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            border: Border(
              right: isLast ? BorderSide.none : const BorderSide(color: Color(0xFFF2F4F6), width: 1),
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: gwangjangRed, size: 24),
              const SizedBox(height: 12),
              Text(
                '\u00A0' + label,
                style: const TextStyle(fontSize: 13, fontWeight: SDS.fwBold, color: AppColors.textPrimary, letterSpacing: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNuclearInfoSection({required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text('\u00A0' + title, style: const TextStyle(fontSize: 18, fontWeight: SDS.fwBlack, color: AppColors.textPrimary, letterSpacing: 0.8)),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(SDS.radiusL),
            boxShadow: SDS.shadowPremium,
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildNuclearInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: gwangjangRed.withValues(alpha: 0.6)),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\u00A0' + label, 
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: SDS.fwBold, letterSpacing: 0.5),
                  overflow: TextOverflow.visible,
                ),
                const SizedBox(height: 6),
                Text(
                  '\u00A0' + value, 
                  style: const TextStyle(fontSize: 15, fontWeight: SDS.fwBlack, color: AppColors.textPrimary, letterSpacing: 0.5),
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textTertiary),
        ],
      ),
    );
  }
}
