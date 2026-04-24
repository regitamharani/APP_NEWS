// lib/providers/news_provider.dart
// Fix: cache per kategori + hapus connectivity_plus yang kadang salah deteksi

import 'package:flutter/foundation.dart';
import '../models/article_model.dart';
import '../services/news_service.dart';
import '../services/cache_service.dart';

enum NewsStatus { initial, loading, loaded, error, offline }

class NewsProvider extends ChangeNotifier {
  final NewsService _newsService = NewsService();
  final CacheService _cacheService = CacheService();

  List<Article> _articles = [];
  List<Article> _filteredArticles = [];
  NewsStatus _status = NewsStatus.initial;
  String _errorMessage = '';
  String _searchQuery = '';
  String _selectedCategory = 'technology';
  bool _isFromCache = false;

  List<Article> get articles =>
      (_searchQuery.isNotEmpty) ? _filteredArticles : _articles;
  NewsStatus get status => _status;
  String get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  bool get isFromCache => _isFromCache;

  final List<String> categories = [
    'technology', 'business', 'science', 'health', 'sports', 'entertainment'
  ];

  Future<void> loadNews({bool forceRefresh = false}) async {
    _status = NewsStatus.loading;
    notifyListeners();

    // Cek cache dulu kalau tidak force refresh
    if (!forceRefresh && await _cacheService.isCacheValid(_selectedCategory)) {
      final cached = await _cacheService.getCachedArticles(_selectedCategory);
      if (cached.isNotEmpty) {
        _articles = cached;
        _isFromCache = true;
        _status = NewsStatus.loaded;
        _applyFilter();
        notifyListeners();
        return;
      }
    }

    // Langsung hit API (hapus connectivity check yang sering salah deteksi)
    try {
      print('🌐 [Provider] Fetching category: $_selectedCategory');
      final articles = await _newsService.fetchTopHeadlines(
        category: _selectedCategory,
      );

      // Simpan ke cache dengan key kategori spesifik
      await _cacheService.saveArticles(articles, _selectedCategory);

      _articles = articles;
      _isFromCache = false;
      _status = NewsStatus.loaded;
      _errorMessage = '';
      _applyFilter();
      print('✅ [Provider] Loaded ${articles.length} articles for $_selectedCategory');

    } catch (e) {
      print('💥 [Provider] Error: $e');
      // Fallback ke cache jika ada
      final cached = await _cacheService.getCachedArticles(_selectedCategory);
      if (cached.isNotEmpty) {
        _articles = cached;
        _isFromCache = true;
        _status = NewsStatus.loaded;
        _errorMessage = 'Gagal memuat terbaru, menampilkan data tersimpan.';
      } else {
        _status = NewsStatus.error;
        _errorMessage = _parseError(e.toString());
      }
    }

    notifyListeners();
  }

  Future<void> searchNews(String query) async {
    _searchQuery = query;
    if (query.trim().isEmpty) {
      _filteredArticles = [];
      notifyListeners();
      return;
    }
    _applyFilter();
    notifyListeners();

    try {
      final results = await _newsService.searchArticles(query);
      _filteredArticles = results;
      notifyListeners();
    } catch (_) {
      // Tetap tampilkan hasil filter lokal
    }
  }

  Future<void> changeCategory(String category) async {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    _searchQuery = '';
    _filteredArticles = [];
    _articles = []; // Kosongkan dulu agar tidak tampil data kategori lama
    notifyListeners();
    await loadNews(forceRefresh: true);
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredArticles = [];
      return;
    }
    final q = _searchQuery.toLowerCase();
    _filteredArticles = _articles.where((a) =>
        a.title.toLowerCase().contains(q) ||
        a.description.toLowerCase().contains(q) ||
        a.sourceName.toLowerCase().contains(q)).toList();
  }

  String _parseError(String error) {
    if (error.contains('timeout')) return 'Koneksi timeout. Coba lagi.';
    if (error.contains('SocketException')) return 'Tidak ada koneksi internet.';
    if (error.contains('403')) return 'API Key tidak valid atau limit habis.';
    if (error.contains('429')) return 'Terlalu banyak request. Tunggu sebentar.';
    return 'Terjadi kesalahan. Coba lagi.';
  }
}