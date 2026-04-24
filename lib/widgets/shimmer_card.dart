// lib/views/widgets/shimmer_card.dart
// Reusable Widget #2 - Custom Shimmer Loading Effect
// Digunakan saat data sedang di-fetch dari API (Visual Consistency - Project 2)

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder gambar
            Container(
              height: 180,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Placeholder badge sumber
                  Container(
                    height: 20,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Placeholder judul (2 baris)
                  Container(
                    height: 16,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 16,
                    width: 200,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10),

                  // Placeholder deskripsi (2 baris)
                  Container(
                    height: 13,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 13,
                    width: 260,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget untuk menampilkan list shimmer
class ShimmerList extends StatelessWidget {
  final int itemCount;
  const ShimmerList({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (_, __) => const ShimmerCard(),
    );
  }
}