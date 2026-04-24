// lib/views/widgets/error_widget.dart
// Reusable Widget #3 - Creative Error UI (Responsible Attitude - CPMK 1)
// Menampilkan pesan error yang ramah pengguna, bukan kode teknis

import 'package:flutter/material.dart';

enum ErrorType { noInternet, apiError, noData, offline }

class NewsErrorWidget extends StatelessWidget {
  final ErrorType type;
  final String message;
  final VoidCallback? onRetry;

  const NewsErrorWidget({
    super.key,
    required this.type,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animasi ikon
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, scale, child) => Transform.scale(
                scale: scale,
                child: child,
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _getColor(context).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIcon(),
                  size: 64,
                  color: _getColor(context),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Judul error kreatif
            Text(
              _getTitle(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Pesan error ramah
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Tombol retry
            if (onRetry != null)
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (type) {
      case ErrorType.noInternet:
        return Icons.wifi_off_rounded;
      case ErrorType.offline:
        return Icons.cloud_off_rounded;
      case ErrorType.apiError:
        return Icons.broken_image_rounded;
      case ErrorType.noData:
        return Icons.inbox_rounded;
    }
  }

  String _getTitle() {
    switch (type) {
      case ErrorType.noInternet:
        return '📡 Sinyal Hilang!';
      case ErrorType.offline:
        return '✈️ Mode Pesawat';
      case ErrorType.apiError:
        return '🔧 Server Lagi Istirahat';
      case ErrorType.noData:
        return '🗂️ Belum Ada Berita';
    }
  }

  Color _getColor(BuildContext context) {
    switch (type) {
      case ErrorType.noInternet:
        return Colors.orange;
      case ErrorType.offline:
        return Colors.blue;
      case ErrorType.apiError:
        return Colors.red;
      case ErrorType.noData:
        return Colors.grey;
    }
  }
}