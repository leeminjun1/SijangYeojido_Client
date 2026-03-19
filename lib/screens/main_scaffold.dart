import 'package:flutter/material.dart';
import '../widgets/sds_widgets.dart';
import 'home/home_screen.dart';
import 'home/nearby_map_screen.dart';
import 'reservation/reservation_list_screen.dart';
import 'profile/profile_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      const NearbyMapScreen(),
      const ReservationListScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _screens.map((screen) => Padding(
              padding: const EdgeInsets.only(bottom: 80), // Space for floating tabbar
              child: screen,
            )).toList(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: SDSFloatingTabbar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              items: const [
                SDSFloatingTabItem(
                  icon: Icons.home_rounded,
                  activeIcon: Icons.home_rounded,
                  label: '홈',
                ),
                SDSFloatingTabItem(
                  icon: Icons.location_on_outlined,
                  activeIcon: Icons.location_on_rounded,
                  label: '지도로 찾기',
                ),
                SDSFloatingTabItem(
                  icon: Icons.receipt_long_outlined,
                  activeIcon: Icons.receipt_long_rounded,
                  label: '주문 내역',
                ),
                SDSFloatingTabItem(
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: '내 정보',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
