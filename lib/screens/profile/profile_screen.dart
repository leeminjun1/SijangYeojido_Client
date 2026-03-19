import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../data/mock_data.dart';
import '../../theme/sijang_design_system.dart';
import '../../widgets/sds_widgets.dart';
import '../../widgets/shrinkable_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final completedReservations =
        MockData.reservations.where((r) => r.isCompleted).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SDS.topBar(
              context: context,
              title: '내 정보',
              subtitle: '반가워요, 김시장님! 오늘도 활기찬 하루 되세요 ✨',
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _ProfileHeader(),
                const SizedBox(height: 8),
                _StatsRow(completedDeals: completedReservations),
                const SizedBox(height: 16),
                _FavoriteMarketsSection(),
                const SizedBox(height: 8),
                _SettingsSection(),
                const SizedBox(height: 24),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Column(
                      children: [
                        Text(
                          '\uc2dc\uc7a5\uc5ec\uc9c0\ub3c4',
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'v1.0.0',
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textTertiary,
                            fontSize: 11,
                          ),
                        ),
                      ],
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

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SDSFadeIn(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        padding: EdgeInsets.all(SDS.space24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(SDS.radiusL),
          boxShadow: SDS.shadowPremium,
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE5362B), Color(0xFFFF6B35)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE5362B).withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '김',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: SDS.fwBlack,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '김시장님',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: SDS.fwBlack,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '여지도와 함께한 지 3개월째예요',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: SDS.fwBold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            _ActionIconBtn(
              icon: Icons.settings_rounded,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('환경 설정을 준비하고 있어요!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ActionIconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ShrinkableButton(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F4F6),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: AppColors.textSecondary),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int completedDeals;

  const _StatsRow({required this.completedDeals});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _StatCard(value: '1', label: '방문 시장'),
          const SizedBox(width: 10),
          _StatCard(value: '5', label: '즐겨찾기'),
          const SizedBox(width: 10),
          _StatCard(value: '$completedDeals', label: '완료 거래'),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(SDS.radiusM),
          boxShadow: SDS.shadowSoft,
          border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: SDS.fwBlack,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: SDS.fwBold,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteMarketsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: '즐겨찾기 시장',
      children: [
        _MarketTile(
          name: '광장시장',
          address: '서울 종로구 창경궁로 88',
          storeCount: MockData.stores.length,
        ),
      ],
    );
  }
}

class _MarketTile extends StatelessWidget {
  final String name;
  final String address;
  final int storeCount;

  const _MarketTile({
    required this.name,
    required this.address,
    required this.storeCount,
  });

  @override
  Widget build(BuildContext context) {
    return SDS.listRow(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(SDS.radiusS),
        ),
        child: const Icon(Icons.storefront_rounded, color: AppColors.primary, size: 22),
      ),
      title: Text(name),
      subtitle: Text(address),
      trailing: Text(
        '점포 $storeCount개',
        style: TextStyle(fontSize: 12, fontWeight: SDS.fwBold, color: AppColors.textSecondary),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Section(
      title: '설정',
      children: [
        _SettingItem(
          icon: Icons.notifications_outlined,
          label: '알림 설정',
          subtitle: '푸시 알림, 야간 제한',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('알림 설정 페이지로 이동합니다.')),
            );
          },
        ),
        _SettingItem(
          icon: Icons.location_on_outlined,
          label: '반경 설정',
          subtitle: '현재 1km',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('주변 탐색 반경을 설정합니다.')),
            );
          },
        ),
        _SettingItem(
          icon: Icons.shield_outlined,
          label: '개인정보 처리방침',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('개인정보 처리방침을 불러옵니다.')),
            );
          },
        ),
        _SettingItem(
          icon: Icons.info_outline,
          label: '앱 정보',
          subtitle: 'v1.0.0',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('시장여지도 v1.0.0 (최신 버전입니다)')),
            );
          },
        ),
        _SettingItem(
          icon: Icons.flag_outlined,
          label: '신고 내역',
          onTap: () {},
        ),
      ],
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;

  const _SettingItem({
    required this.icon,
    required this.label,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SDS.listRow(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F4F6),
          borderRadius: BorderRadius.circular(SDS.radiusS),
        ),
        child: Icon(icon, size: 20, color: AppColors.textSecondary),
      ),
      title: Text(label),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textTertiary),
      onTap: onTap,
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: SDS.fwBlack,
              color: AppColors.textTertiary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(SDS.radiusL),
            boxShadow: SDS.shadowPremium,
            border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              ...children,
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}
