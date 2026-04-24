
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/news_provider.dart';
import '../widgets/article_card.dart';
import '../widgets/shimmer_card.dart';
import '../widgets/error_widget.dart';
import '../views/detail_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Controller untuk search field (Project 2)
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load berita saat pertama buka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsProvider>().loadNews();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildSearchBar(context),
            _buildCategoryFilter(context),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('News App', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              Text('Berita terkini untukmu', style: TextStyle(fontSize: 13, color: Colors.grey)),
            ],
          ),
          const Spacer(),
          // Tombol refresh
          Consumer<NewsProvider>(
            builder: (_, provider, __) => IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: () => provider.loadNews(forceRefresh: true),
            ),
          ),
        ],
      ),
    );
  }

  /// Search bar - Project 2: Asynchronous Search Feature
  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Cari berita...',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded),
                  onPressed: () {
                    _searchController.clear();
                    context.read<NewsProvider>().searchNews('');
                  },
                )
              : null,
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: (query) {
          setState(() {}); // update clear button
          // Async search dengan debounce sederhana
          Future.delayed(const Duration(milliseconds: 400), () {
            if (_searchController.text == query) {
              context.read<NewsProvider>().searchNews(query);
            }
          });
        },
      ),
    );
  }

  /// Category filter chips - Project 2: Filter Feature
  Widget _buildCategoryFilter(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (_, provider, __) => SizedBox(
        height: 44,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: provider.categories.length,
          itemBuilder: (_, index) {
            final category = provider.categories[index];
            final isSelected = category == provider.selectedCategory;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FilterChip(
                label: Text(
                  category[0].toUpperCase() + category.substring(1),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                selected: isSelected,
                onSelected: (_) => provider.changeCategory(category),
                showCheckmark: false,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (_, provider, __) {
        // Tampilkan banner offline jika dari cache
        return Column(
          children: [
            if (provider.isFromCache) _buildOfflineBanner(context, provider),
            Expanded(child: _buildContent(context, provider)),
          ],
        );
      },
    );
  }

  Widget _buildOfflineBanner(BuildContext context, NewsProvider provider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.history_rounded, size: 16, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              provider.status == NewsStatus.offline
                  ? 'Offline - Menampilkan berita tersimpan'
                  : provider.errorMessage,
              style: const TextStyle(fontSize: 12, color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, NewsProvider provider) {
    switch (provider.status) {
      // Loading: tampilkan shimmer effect
      case NewsStatus.loading:
      case NewsStatus.initial:
        return const ShimmerList(itemCount: 5);

      // Error tanpa cache
      case NewsStatus.error:
        return NewsErrorWidget(
          type: ErrorType.apiError,
          message: provider.errorMessage,
          onRetry: () => provider.loadNews(forceRefresh: true),
        );

      // Offline tanpa cache
      case NewsStatus.offline:
        if (provider.articles.isEmpty) {
          return NewsErrorWidget(
            type: ErrorType.noInternet,
            message: 'Tidak ada koneksi internet dan belum ada berita tersimpan.',
            onRetry: () => provider.loadNews(),
          );
        }
        return _buildArticleList(provider);

      // Loaded
      case NewsStatus.loaded:
        if (provider.articles.isEmpty) {
          return NewsErrorWidget(
            type: ErrorType.noData,
            message: 'Tidak ada berita untuk kategori ini.',
            onRetry: () => provider.loadNews(forceRefresh: true),
          );
        }
        return _buildArticleList(provider);
    }
  }

  Widget _buildArticleList(NewsProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: provider.articles.length,
      itemBuilder: (context, index) {
        final article = provider.articles[index];
        // Reusable ArticleCard digunakan secara konsisten di sini
        return ArticleCard(
          article: article,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailView(article: article),
            ),
          ),
        );
      },
    );
  }
}