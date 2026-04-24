// lib/services/cache_service.dart
// Fix: cache key sekarang include kategori agar tiap kategori punya cache sendiri

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article_model.dart';

class CacheService {
  static const String _cacheTimePrefix = 'cache_time_';
  static const Duration _cacheValidity = Duration(hours: 1);

  // Key cache per kategori: "cached_articles_technology", "cached_articles_sports", dst
  String _articlesKey(String category) => 'cached_articles_$category';
  String _timeKey(String category) => '$_cacheTimePrefix$category';

  Future<void> saveArticles(List<Article> articles, String category) async {
    final prefs = await SharedPreferences.getInstance();
    final articlesJson = articles.map((a) => json.encode(a.toJson())).toList();
    await prefs.setStringList(_articlesKey(category), articlesJson);
    await prefs.setInt(_timeKey(category), DateTime.now().millisecondsSinceEpoch);
    print('💾 [Cache] Saved ${articles.length} articles for category: $category');
  }

  Future<List<Article>> getCachedArticles(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final articlesJson = prefs.getStringList(_articlesKey(category));
    if (articlesJson == null || articlesJson.isEmpty) return [];
    print('📂 [Cache] Loaded ${articlesJson.length} articles for category: $category');
    return articlesJson
        .map((s) => Article.fromJson(json.decode(s)))
        .toList();
  }

  Future<bool> isCacheValid(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_timeKey(category));
    if (timestamp == null) return false;
    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateTime.now().difference(cacheTime) < _cacheValidity;
  }

  Future<void> clearCache(String category) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_articlesKey(category));
    await prefs.remove(_timeKey(category));
  }
}