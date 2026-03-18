import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_ui.dart';
import '../../widgets/shrinkable_button.dart';
import '../map/store_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Store> _results = [];
  bool _hasStartedTyped = false;
  
  // Real history would use shared_preferences
  final List<String> _recentSearches = ['수산시장', '떡볶이', '축산'];

  void _onSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _results = [];
        _hasStartedTyped = false;
      });
      return;
    }

    final queryLower = query.toLowerCase();
    final allStores = MockData.stores;
    setState(() {
      _results = allStores.where((s) => 
        s.name.toLowerCase().contains(queryLower) ||
        s.category.toLowerCase().contains(queryLower) ||
        s.items.any((i) => i.name.toLowerCase().contains(queryLower))
      ).toList();
      _hasStartedTyped = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: ShrinkableButton(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        title: Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: _onSearch,
            decoration: InputDecoration(
              hintText: '가게, 품목, 구역 검색',
              hintStyle: textTheme.bodyLarge?.copyWith(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w600,
              ),
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
              suffixIcon: _searchController.text.isNotEmpty 
                ? IconButton(
                    icon: const Icon(Icons.cancel_rounded, color: AppColors.textTertiary),
                    onPressed: () {
                      _searchController.clear();
                      _onSearch('');
                    },
                  )
                : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 11),
            ),
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
      body: _hasStartedTyped 
        ? _buildSearchResults() 
        : _buildSearchHome(textTheme),
    );
  }

  Widget _buildSearchHome(TextTheme textTheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '최근 검색어',
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _recentSearches.map((s) => _buildRecentChip(s)).toList(),
          ),
          const SizedBox(height: 48),
          Text(
            '인기 카테고리',
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          _buildCategoryList(textTheme),
        ],
      ),
    );
  }

  Widget _buildRecentChip(String text) {
    return ShrinkableButton(
      onTap: () {
        _searchController.text = text;
        _onSearch(text);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList(TextTheme textTheme) {
    final categories = ['먹거리', '정육/수산', '과일/채소', '건어물/양념'];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return ShrinkableButton(
          onTap: () => _onSearch(categories[index]),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.storefront_rounded, color: AppColors.primary, size: 20),
                const SizedBox(width: 10),
                Text(
                  categories[index],
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchResults() {
    if (_results.isEmpty) {
      return AppEmptyState(
        icon: Icons.search_off_rounded,
        title: '검색 결과가 없어요',
        description: '오타를 확인하시거나\n다른 검색어로 다시 검색해 보세요',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _results.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final store = _results[index];
        return AppCard(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => StoreDetailScreen(store: store)),
            );
          },
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(_iconForCategory(store.category), color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${store.category} · ${store.zoneId}구역',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textTertiary),
            ],
          ),
        );
      },
    );
  }

  IconData _iconForCategory(String category) {
    if (category.contains('먹거리')) return Icons.restaurant_rounded;
    if (category.contains('수산')) return Icons.set_meal_rounded;
    if (category.contains('정육')) return Icons.kebab_dining_rounded;
    if (category.contains('과일') || category.contains('채소')) return Icons.eco_rounded;
    return Icons.storefront_rounded;
  }
}
