import 'package:flutter/material.dart';

class FavoriteService extends ChangeNotifier {
  static final FavoriteService _instance = FavoriteService._internal();
  factory FavoriteService() => _instance;
  FavoriteService._internal();

  final Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => _favoriteIds;

  bool isFavorite(String storeId) => _favoriteIds.contains(storeId);

  void toggleFavorite(String storeId) {
    if (_favoriteIds.contains(storeId)) {
      _favoriteIds.remove(storeId);
    } else {
      _favoriteIds.add(storeId);
    }
    notifyListeners();
  }
}
