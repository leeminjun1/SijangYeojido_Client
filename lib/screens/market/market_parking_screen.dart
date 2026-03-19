import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/sijang_design_system.dart';
import '../../widgets/shrinkable_button.dart';

class MarketParkingScreen extends StatelessWidget {
  final String marketName;
  const MarketParkingScreen({super.key, required this.marketName});

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
              padding: EdgeInsets.only(left: 16.0), // Nuclear Buffer
              child: Text(
                '\u00A0가깝고 편리한 주차장',
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
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                '\u00A0시장 인근 주차장 정보를 확인하세요.',
                style: TextStyle(fontSize: 15, color: AppColors.textSecondary, fontWeight: SDS.fwBold, height: 1.5),
              ),
            ),
            const SizedBox(height: 32),

            _buildNuclearParkingItem(
              name: '제1공영주차장 (남문)',
              fee: '30분 1,000원',
              distance: '남문 시장 입구에서 도보 2분',
              address: '서울 중구 남대문시장길 10',
            ),
            _buildNuclearParkingItem(
              name: '제2공영주차장 (북문)',
              fee: '30분 1,200원',
              distance: '북문 시장 입구에서 도보 5분',
              address: '서울 중구 소공로 12',
            ),
            
            const SizedBox(height: 32),
            // ─── UPGRADED: Parking Tip Card ───
            _buildBentoTipCard(
              title: '시장 주차 이용 꿀팁',
              content: '• 점포 이용 시 무료 주차권을 꼭 요청하세요.\n• 공용 주차장은 경차 및 저공해 차량 할인이 적용됩니다.\n• 주말은 대중교통 이용을 권장합니다.',
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildNuclearParkingItem({
    required String name,
    required String fee,
    required String distance,
    required String address,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SDS.radiusL),
          boxShadow: SDS.shadowPremium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    '\u00A0' + name,
                    style: const TextStyle(fontSize: 18, fontWeight: SDS.fwBlack, color: AppColors.textPrimary, letterSpacing: 0.8),
                    overflow: TextOverflow.visible,
                    softWrap: false,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: gwangjangRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('주차가능', style: TextStyle(color: gwangjangRed, fontSize: 12, fontWeight: SDS.fwBlack)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildNuclearInfoRow(Icons.monetization_on_outlined, fee),
            const SizedBox(height: 12),
            _buildNuclearInfoRow(Icons.directions_walk_rounded, distance),
            const SizedBox(height: 12),
            _buildNuclearInfoRow(Icons.location_on_outlined, address),
            
            const SizedBox(height: 28),
            ShrinkableButton(
              onTap: () {},
              child: Container(
                height: 54,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: gwangjangRed,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    '길찾기', 
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: SDS.fwBlack)
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNuclearInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary.withValues(alpha: 0.6)),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            '\u00A0' + text, 
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, fontWeight: SDS.fwBold, letterSpacing: 0.5),
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }

  Widget _buildBentoTipCard({required String title, required String content}) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(SDS.radiusL),
        border: Border.all(color: const Color(0xFFECEFF1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 8),
              const Icon(Icons.tips_and_updates_rounded, color: gwangjangRed, size: 20),
              const SizedBox(width: 12),
              Text(
                '\u00A0' + title, 
                style: const TextStyle(fontSize: 16, fontWeight: SDS.fwBlack, color: AppColors.textPrimary, letterSpacing: 0.5)
              ),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              content,
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, fontWeight: SDS.fwBold, height: 1.7),
            ),
          ),
        ],
      ),
    );
  }
}
