import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/mock_data.dart';
import 'favorite_service.dart';

class RecommendationService extends ChangeNotifier {
  static final RecommendationService _instance = RecommendationService._internal();
  factory RecommendationService() => _instance;
  RecommendationService._internal();

  List<Store> getRecommendedStores() {
    final favIds = FavoriteService().favoriteIds;
    if (favIds.isEmpty) {
      // Fallback to popular stores if no favorites
      return MockData.stores.take(5).toList();
    }

    final favoriteStores = MockData.stores.where((s) => favIds.contains(s.id)).toList();
    final favoriteCategories = favoriteStores.map((s) => s.category).toSet();

    // Recommend stores in similar categories but not yet favorited
    final recommended = MockData.stores
        .where((s) => !favIds.contains(s.id) && favoriteCategories.contains(s.category))
        .toList();

    if (recommended.length < 5) {
      // Add some variety if recommendation list is short
      final others = MockData.stores
          .where((s) => !favIds.contains(s.id) && !favoriteCategories.contains(s.category))
          .take(5 - recommended.length)
          .toList();
      recommended.addAll(others);
    }
    
    return recommended.take(5).toList();
  }
}
