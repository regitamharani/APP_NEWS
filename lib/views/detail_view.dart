

import 'package:flutter/material.dart';
import '../../models/article_model.dart';

class DetailView extends StatelessWidget {
  final Article article;
  const DetailView({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar dengan gambar
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: article.urlToImage.isNotEmpty
                  ? Image.network(
                      article.urlToImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.newspaper_rounded, size: 64),
                      ),
                    )
                  : Container(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.newspaper_rounded, size: 64),
                    ),
            ),
          ),

          // Konten artikel
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sumber dan tanggal
                  Row(
                    children: [
                      Chip(
                        label: Text(article.sourceName, style: const TextStyle(fontSize: 12)),
                        visualDensity: VisualDensity.compact,
                      ),
                      const Spacer(),
                      Text(
                        article.formattedDate,
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Judul
                  Text(
                    article.title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.3),
                  ),
                  const SizedBox(height: 16),

                  // Deskripsi
                  Text(
                    article.description,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.6),
                  ),
                  const SizedBox(height: 16),

                  // Konten
                  if (article.content.isNotEmpty)
                    Text(
                      article.content.replaceAll(RegExp(r'\[\+\d+ chars\]'), '...'),
                      style: const TextStyle(fontSize: 15, height: 1.7),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}