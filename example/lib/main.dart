import 'package:flutter/material.dart';
import 'package:flutter_longpress_preview/flutter_longpress_preview.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_longpress_preview example',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('LongPress Preview'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.article_outlined), text: 'Articles'),
              Tab(icon: Icon(Icons.link_rounded), text: 'Links'),
              Tab(icon: Icon(Icons.photo_library_outlined), text: 'Photos'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _ArticleTab(),
            _LinkTab(),
            _PhotoTab(),
          ],
        ),
      ),
    );
  }
}

// ── Data models ───────────────────────────────────────────────────────────────

class _Article {
  final int id;
  final String category;
  final Color categoryColor;
  final IconData categoryIcon;
  final String title;
  final String excerpt;
  final String author;
  final String readTime;
  final String date;

  const _Article({
    required this.id,
    required this.category,
    required this.categoryColor,
    required this.categoryIcon,
    required this.title,
    required this.excerpt,
    required this.author,
    required this.readTime,
    required this.date,
  });
}

const _articles = [
  _Article(
    id: 1,
    category: 'Flutter',
    categoryColor: Color(0xFF0553B1),
    categoryIcon: Icons.flutter_dash,
    title: 'What\'s New in Flutter 3.29',
    excerpt:
        'Explore the latest improvements to rendering performance, the new adaptive widgets, and what the team has planned for Wasm on the web.',
    author: 'Remi Rousselet',
    readTime: '5 min read',
    date: 'Apr 5, 2026',
  ),
  _Article(
    id: 2,
    category: 'Design',
    categoryColor: Color(0xFF9C27B0),
    categoryIcon: Icons.palette_outlined,
    title: 'Designing with Material You: A Deep Dive',
    excerpt:
        'Dynamic color, expressive typography, and adaptive layouts — learn how to implement Material 3 in your apps the right way.',
    author: 'Lily Chen',
    readTime: '4 min read',
    date: 'Apr 3, 2026',
  ),
  _Article(
    id: 3,
    category: 'Dart',
    categoryColor: Color(0xFF00897B),
    categoryIcon: Icons.code_rounded,
    title: 'Dart Macros Are Finally Here',
    excerpt:
        'The long-awaited macros feature lands in Dart 3.8. Here\'s a practical guide to writing your first macro and what it means for serialization.',
    author: 'Michael Thomsen',
    readTime: '7 min read',
    date: 'Apr 1, 2026',
  ),
  _Article(
    id: 4,
    category: 'Performance',
    categoryColor: Color(0xFFE65100),
    categoryIcon: Icons.speed_rounded,
    title: 'Profiling Flutter Apps with DevTools 2.0',
    excerpt:
        'New flame chart views, memory leak detection, and AI-assisted hints make DevTools 2.0 the most powerful profiler Flutter has ever had.',
    author: 'Kenichi Nakamura',
    readTime: '6 min read',
    date: 'Mar 29, 2026',
  ),
  _Article(
    id: 5,
    category: 'OSS',
    categoryColor: Color(0xFF37474F),
    categoryIcon: Icons.hub_outlined,
    title: 'Contributing to Flutter: A Beginner\'s Guide',
    excerpt:
        'From your first "good first issue" to landing a PR in the engine — everything you need to know to become a Flutter contributor.',
    author: 'Sarah Kim',
    readTime: '8 min read',
    date: 'Mar 26, 2026',
  ),
];

// ── Tab 1: Article feed ───────────────────────────────────────────────────────

class _ArticleTab extends StatelessWidget {
  const _ArticleTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12, left: 4),
          child: Text(
            'Long press any article to peek • tap to open',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        for (final article in _articles)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: LongPressPreview(
              preview: _ArticlePreview(article: article),
              onPreviewTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ArticleDetailPage(article: article),
                ),
              ),
              config: PreviewConfig(
                animation: PreviewAnimation.scaleFromChild,
                previewHeight: 420,
                actions: [
                  PreviewAction(
                    label: 'Open',
                    icon: Icons.open_in_new_rounded,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ArticleDetailPage(article: article),
                      ),
                    ),
                  ),
                  PreviewAction(
                    label: 'Bookmark',
                    icon: Icons.bookmark_outline_rounded,
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Bookmarked: ${article.title}'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    ),
                  ),
                  PreviewAction(
                    label: 'Share',
                    icon: Icons.share_outlined,
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Share sheet would open here'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ArticleDetailPage(article: article),
                ),
              ),
              child: _ArticleCard(article: article),
            ),
          ),
      ],
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final _Article article;
  const _ArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: article.categoryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(article.categoryIcon,
                      size: 13, color: article.categoryColor),
                  const SizedBox(width: 5),
                  Text(
                    article.category,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: article.categoryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Title
            Text(
              article.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 6),
            // Excerpt
            Text(
              article.excerpt,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: cs.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            // Author row
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor:
                      article.categoryColor.withValues(alpha: 0.2),
                  child: Text(
                    article.author[0],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: article.categoryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  article.author,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Icon(Icons.schedule_rounded,
                    size: 13, color: cs.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  article.readTime,
                  style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticlePreview extends StatelessWidget {
  final _Article article;
  const _ArticlePreview({required this.article});

  static const _body =
      'Flutter is Google\'s UI toolkit for building beautiful, natively compiled '
      'applications for mobile, web, desktop, and embedded devices from a single '
      'codebase. With its rich set of pre-built widgets and a reactive framework, '
      'Flutter makes it easy to craft high-quality user experiences.\n\n'
      'Long-press previews let users peek at content without fully committing to '
      'navigation — a pattern popularised by iOS\'s Peek & Pop.';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Colored header
        Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            color: article.categoryColor.withValues(alpha: 0.12),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Center(
            child: Icon(
              article.categoryIcon,
              size: 64,
              color: article.categoryColor.withValues(alpha: 0.6),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category chip
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: article.categoryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  article.category,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: article.categoryColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                article.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor:
                        article.categoryColor.withValues(alpha: 0.2),
                    child: Text(
                      article.author[0],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: article.categoryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${article.author} · ${article.date}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                _body,
                style: const TextStyle(fontSize: 14, height: 1.65),
                maxLines: 6,
                overflow: TextOverflow.fade,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Tab 2: Saved links ────────────────────────────────────────────────────────

class _LinkTab extends StatelessWidget {
  const _LinkTab();

  static const _links = [
    (
      label: 'Flutter — Build apps for any screen',
      url: 'https://flutter.dev',
      icon: Icons.flutter_dash,
      color: Color(0xFF0553B1),
    ),
    (
      label: 'Dart programming language',
      url: 'https://dart.dev',
      icon: Icons.code_rounded,
      color: Color(0xFF00897B),
    ),
    (
      label: 'pub.dev — Dart & Flutter packages',
      url: 'https://pub.dev',
      icon: Icons.inventory_2_outlined,
      color: Color(0xFF0277BD),
    ),
    (
      label: 'GitHub — Where the world builds software',
      url: 'https://github.com',
      icon: Icons.hub_outlined,
      color: Color(0xFF37474F),
    ),
    (
      label: 'Material Design 3',
      url: 'https://m3.material.io',
      icon: Icons.palette_outlined,
      color: Color(0xFF9C27B0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header card
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: cs.secondaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.touch_app_rounded,
                  size: 18, color: cs.onSecondaryContainer),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Long press any link to see an OGP preview',
                  style: TextStyle(
                    fontSize: 13,
                    color: cs.onSecondaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Section label
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            'SAVED LINKS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
        // Link list
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.6)),
          ),
          child: Column(
            children: [
              for (int i = 0; i < _links.length; i++) ...[
                LongPressLinkPreview(
                  url: _links[i].url,
                  config: const PreviewConfig(
                    animation: PreviewAnimation.slideFromBottom,
                  ),
                  onTap: () async {
                    final uri = Uri.parse(_links[i].url);
                    if (await canLaunchUrl(uri)) launchUrl(uri);
                  },
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    leading: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: _links[i].color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(_links[i].icon,
                          color: _links[i].color, size: 22),
                    ),
                    title: Text(
                      _links[i].label,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      Uri.parse(_links[i].url).host,
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.primary,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_outward_rounded,
                        size: 18, color: cs.onSurfaceVariant),
                  ),
                ),
                if (i < _links.length - 1)
                  Divider(
                    height: 1,
                    indent: 74,
                    color: cs.outlineVariant.withValues(alpha: 0.5),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// ── Tab 3: Photo gallery ──────────────────────────────────────────────────────

class _PhotoTab extends StatelessWidget {
  const _PhotoTab();

  static const _photos = [
    (seed: 'kyoto1', location: 'Kyoto', featured: true),
    (seed: 'tokyo2', location: 'Tokyo', featured: false),
    (seed: 'osaka3', location: 'Osaka', featured: false),
    (seed: 'nara4', location: 'Nara', featured: false),
    (seed: 'hakone5', location: 'Hakone', featured: false),
    (seed: 'shibuya6', location: 'Shibuya', featured: false),
    (seed: 'asakusa7', location: 'Asakusa', featured: false),
  ];

  String _imageUrl(String seed, {int w = 800, int h = 600}) =>
      'https://picsum.photos/seed/$seed/$w/$h';

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Featured photo (full width)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            child: _PhotoTile(
              imageUrl: _imageUrl(_photos[0].seed, w: 1200, h: 600),
              location: _photos[0].location,
              heroTag: 'photo_0',
              height: 220,
              borderRadius: 14,
            ),
          ),
        ),
        // Grid for the rest
        SliverPadding(
          padding: const EdgeInsets.all(8),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.0,
            ),
            itemCount: _photos.length - 1,
            itemBuilder: (context, i) {
              final photo = _photos[i + 1];
              return _PhotoTile(
                imageUrl: _imageUrl(photo.seed),
                location: photo.location,
                heroTag: 'photo_${i + 1}',
                height: null,
                borderRadius: 12,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PhotoTile extends StatelessWidget {
  final String imageUrl;
  final String location;
  final String heroTag;
  final double? height;
  final double borderRadius;

  const _PhotoTile({
    required this.imageUrl,
    required this.location,
    required this.heroTag,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget tile = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return Container(
                color: Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
          ),
          // Bottom gradient overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.5, 1.0],
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.55),
                  ],
                ),
              ),
            ),
          ),
          // Location label
          Positioned(
            left: 10,
            bottom: 10,
            child: Row(
              children: [
                const Icon(Icons.location_on_rounded,
                    size: 13, color: Colors.white),
                const SizedBox(width: 3),
                Text(
                  location,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(blurRadius: 4, color: Colors.black45),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (height != null) {
      tile = SizedBox(height: height, child: tile);
    }

    return LongPressImagePreview(
      imageProvider: NetworkImage(imageUrl),
      enableZoom: true,
      heroTag: heroTag,
      config: const PreviewConfig(
        animation: PreviewAnimation.scaleFromChild,
        backgroundColor: Colors.black,
      ),
      child: tile,
    );
  }
}

// ── Article detail page ───────────────────────────────────────────────────────

class ArticleDetailPage extends StatelessWidget {
  final _Article article;
  const ArticleDetailPage({super.key, required this.article});

  static const _body =
      'Flutter is Google\'s UI toolkit for building beautiful, natively compiled '
      'applications for mobile, web, desktop, and embedded devices from a single '
      'codebase. With its rich set of pre-built widgets and a reactive framework, '
      'Flutter makes it easy to craft high-quality user experiences.\n\n'
      'Long-press previews let users peek at content without fully committing to '
      'navigation — a pattern popularised by iOS\'s Peek & Pop. This page is what '
      'opens when the user taps the preview or selects "Open" from the action menu.\n\n'
      'The flutter_longpress_preview package supports three animation styles: '
      'scale from child (Safari-style), slide from bottom (Instagram-style), and '
      'a simple fade. All animations are fully customisable via PreviewConfig.';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(article.category),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: article.categoryColor.withValues(alpha: 0.15),
                child: Center(
                  child: Icon(
                    article.categoryIcon,
                    size: 96,
                    color: article.categoryColor.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: article.categoryColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      article.category,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: article.categoryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Title
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                  ),
                  const SizedBox(height: 16),
                  // Author row
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor:
                            article.categoryColor.withValues(alpha: 0.2),
                        child: Text(
                          article.author[0],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: article.categoryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.author,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${article.date} · ${article.readTime}',
                            style: TextStyle(
                              fontSize: 12,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(),
                  ),
                  // Body
                  Text(
                    _body,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.8,
                        ),
                  ),
                  const SizedBox(height: 32),
                  // Action buttons
                  Row(
                    children: [
                      FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.bookmark_outline_rounded),
                        label: const Text('Bookmark'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.share_outlined),
                        label: const Text('Share'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
