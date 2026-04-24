import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_news/models/article_model.dart';

class NewsService {
  static const String _apiKey = '83f77bdd230142d2bc0db544fcd18a96';
  static const String _baseUrl = 'https://newsapi.org/v2';

  /// 🔥 FETCH BERITA BERDASARKAN CATEGORY (FIX FILTER)
  Future<List<Article>> fetchTopHeadlines({String category = 'general'}) async {
    try {
      // mapping biar lebih akurat
      final queryMap = {
        'general': 'news',
        'technology': 'technology OR AI OR gadget',
        'sports': 'sports OR football OR FIFA',
        'health': 'health OR medical OR hospital',
        'business': 'business OR economy OR startup',
        'science': 'science OR space OR research',
        'entertainment': 'movie OR music OR celebrity',
      };

      final query = queryMap[category] ?? 'news';

      final uri = Uri.parse(
        '$_baseUrl/everything?q=$query&sortBy=publishedAt&pageSize=20&apiKey=$_apiKey',
      );

      final response = await http.get(uri);
      final data = json.decode(response.body);

      print("CATEGORY: $category");
      print("QUERY: $query");

      if (response.statusCode == 200 && data['status'] == 'ok') {
        final List articlesJson = data['articles'] ?? [];

        return articlesJson
            .map((json) => Article.fromJson(json))
            .toList();
      } else {
        throw Exception(data['message'] ?? 'API Error');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// 🔍 SEARCH
  Future<List<Article>> searchArticles(String query) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/everything?q=${Uri.encodeComponent(query)}&sortBy=publishedAt&pageSize=20&apiKey=$_apiKey',
      );

      final response = await http.get(uri);
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'ok') {
        final List articlesJson = data['articles'] ?? [];

        return articlesJson
            .map((json) => Article.fromJson(json))
            .toList();
      } else {
        throw Exception(data['message'] ?? 'Search error');
      }
    } catch (e) {
      throw Exception('Search error: $e');
    }
  }
}