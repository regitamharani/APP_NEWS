import 'package:flutter/material.dart';
import '../../models/article_model.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback? onTap;

  const ArticleCard({
    super.key,
    required this.article,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = article.urlToImage;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 FIX IMAGE (ANTI NULL & ERROR)
            ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: imageUrl.isNotEmpty
            ? Image.network(
            imageUrl,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildImagePlaceholder(context),
           )
         : _buildImagePlaceholder(context),
        ),

            // Konten teks
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge sumber + tanggal
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          article.sourceName.isNotEmpty
                              ? article.sourceName
                              : 'Unknown',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        article.formattedDate,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Judul
                  Text(
                    article.title.isNotEmpty
                        ? article.title
                        : 'No title available',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Deskripsi
                  Text(
                    article.description.isNotEmpty
                        ? article.description
                        : 'No description available',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 Placeholder kalau gambar kosong/error
  Widget _buildImagePlaceholder(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      child: Center(
        child: Icon(
          Icons.image_not_supported_rounded,
          size: 48,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}