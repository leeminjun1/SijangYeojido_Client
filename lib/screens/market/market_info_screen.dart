import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_ui.dart';

class MarketInfoScreen extends StatelessWidget {
  const MarketInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '시장 정보',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIntroduction(textTheme),
            const SizedBox(height: 32),
            _buildFacilityGrid(textTheme),
            const SizedBox(height: 32),
            _buildParkingInfo(textTheme),
            const SizedBox(height: 32),
            _buildOperatingHours(textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroduction(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'SINCE 1970',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 1.0,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '서울에서 가장 활기찬\n전통 시장, 시장여지도',
          style: textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '350여 개의 점포가 함께하며, 신선한 수산물부터 맛있는 먹거리까지 최고의 품질을 약속합니다.',
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildFacilityGrid(TextTheme textTheme) {
    final facilities = [
      {'icon': Icons.wc_rounded, 'label': '화장실(4개)'},
      {'icon': Icons.local_parking_rounded, 'label': '공영주차장'},
      {'icon': Icons.child_care_rounded, 'label': '수유실'},
      {'icon': Icons.elevator_rounded, 'label': '승강기'},
      {'icon': Icons.wifi_rounded, 'label': '무료 와이파이'},
      {'icon': Icons.info_outline_rounded, 'label': '안내소'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(textTheme, '편의 시설'),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.0,
          ),
          itemCount: facilities.length,
          itemBuilder: (context, index) {
            final f = facilities[index];
            return Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(f['icon'] as IconData, color: AppColors.primary, size: 28),
                  const SizedBox(height: 8),
                  Text(
                    f['label'] as String,
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildParkingInfo(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(textTheme, '주차 안내'),
        const SizedBox(height: 16),
        _buildInfoCard(
          textTheme,
          Icons.local_parking_rounded,
          '제1공영주차장',
          '기본 30분 1,000원 / 추가 10분당 500원\n(시장 이용 고객 1시간 무료 주차권 증정)',
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          textTheme,
          Icons.local_parking_rounded,
          '제2공영주차장 (동문 방향)',
          '기본 30분 1,200원 / 추가 10분당 600원',
        ),
      ],
    );
  }

  Widget _buildOperatingHours(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(textTheme, '운영 시간'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              _buildHourRow('평일/토요일', '09:00 - 21:00', isAccent: true),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1, color: AppColors.border),
              ),
              _buildHourRow('일요일', '10:00 - 18:00 (일부 휴무)'),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1, color: AppColors.border),
              ),
              _buildHourRow('휴무일', '매월 첫째, 셋째 일요일 전면 휴장'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(TextTheme textTheme, String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
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
    );
  }

  Widget _buildInfoCard(TextTheme textTheme, IconData icon, String title, String detail) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.textTertiary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  detail,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourRow(String label, String value, {bool isAccent = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isAccent ? FontWeight.w800 : FontWeight.w600,
            color: isAccent ? AppColors.textPrimary : AppColors.textSecondary,
            fontSize: 15,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: isAccent ? AppColors.primary : AppColors.textPrimary,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
