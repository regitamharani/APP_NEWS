

class Article {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String sourceName;
  final String content;

  Article({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.sourceName,
    required this.content,
  });

  /// Factory constructor dari JSON (response API)
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      sourceName: json['source']?['name'] ?? 'Unknown',
      content: json['content'] ?? '',
    );
  }

  /// Konversi ke JSON untuk disimpan ke cache (shared_preferences)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'source': {'name': sourceName},
      'content': content,
    };
  }

  /// Format tanggal publikasi agar mudah dibaca
  String get formattedDate {
    try {
      final date = DateTime.parse(publishedAt);
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return publishedAt;
    }
  }
}