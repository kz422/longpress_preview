import 'package:flutter/material.dart';
import '../models/preview_config.dart';
import '../ogp/link_preview_card.dart';
import '../ogp/ogp_fetcher.dart';
import '../ogp/ogp_data.dart';
import 'longpress_preview.dart';

/// A [LongPressPreview] that automatically fetches OGP metadata for [url]
/// and displays a rich link preview card.
///
/// ```dart
/// LongPressLinkPreview(
///   url: 'https://flutter.dev',
///   child: Text('Flutter', style: linkStyle),
///   onTap: () => launchUrl(Uri.parse('https://flutter.dev')),
/// )
/// ```
class LongPressLinkPreview extends StatefulWidget {
  /// The URL whose preview will be shown.
  final String url;

  /// The widget that triggers the preview on long press.
  final Widget child;

  /// Appearance and behavior configuration.
  final PreviewConfig config;

  /// Optional proxy URL prepended to [url] for CORS on web.
  final String? proxyUrl;

  /// Whether to show the site favicon in the preview card.
  final bool showFavicon;

  /// Whether to show the description in the preview card.
  final bool showDescription;

  /// Max lines for the description text.
  final int maxDescriptionLines;

  /// Custom loading widget shown while OGP data is being fetched.
  final Widget? loadingWidget;

  /// Custom error widget shown when OGP fetch fails.
  final Widget? errorWidget;

  /// Custom preview widget builder. If provided, overrides the default card.
  final Widget Function(BuildContext context, OgpData data)? previewBuilder;

  /// Called when the preview popup opens.
  final VoidCallback? onPreviewOpen;

  /// Called when the preview popup closes.
  final VoidCallback? onPreviewClose;

  /// Called on normal tap (not long press).
  final VoidCallback? onTap;

  /// Creates a [LongPressLinkPreview].
  const LongPressLinkPreview({
    super.key,
    required this.url,
    required this.child,
    this.config = const PreviewConfig(),
    this.proxyUrl,
    this.showFavicon = true,
    this.showDescription = true,
    this.maxDescriptionLines = 3,
    this.loadingWidget,
    this.errorWidget,
    this.previewBuilder,
    this.onPreviewOpen,
    this.onPreviewClose,
    this.onTap,
  });

  @override
  State<LongPressLinkPreview> createState() => _LongPressLinkPreviewState();
}

class _LongPressLinkPreviewState extends State<LongPressLinkPreview> {
  late Future<OgpData> _ogpFuture;

  @override
  void initState() {
    super.initState();
    _ogpFuture = OgpFetcher.fetch(widget.url, proxyUrl: widget.proxyUrl);
  }

  @override
  void didUpdateWidget(LongPressLinkPreview old) {
    super.didUpdateWidget(old);
    if (old.url != widget.url || old.proxyUrl != widget.proxyUrl) {
      _ogpFuture = OgpFetcher.fetch(widget.url, proxyUrl: widget.proxyUrl);
    }
  }

  Widget _buildPreview() {
    return FutureBuilder<OgpData>(
      future: _ogpFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return SizedBox(
            height: 200,
            child: Center(
              child: widget.loadingWidget ??
                  const CircularProgressIndicator.adaptive(),
            ),
          );
        }
        if (snapshot.hasError || snapshot.data == null) {
          return SizedBox(
            height: 120,
            child: Center(
              child: widget.errorWidget ??
                  const Text('Could not load preview'),
            ),
          );
        }
        final data = snapshot.data!;
        if (widget.previewBuilder != null) {
          return widget.previewBuilder!(context, data);
        }
        return LinkPreviewCard(
          data: data,
          showFavicon: widget.showFavicon,
          showDescription: widget.showDescription,
          maxDescriptionLines: widget.maxDescriptionLines,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LongPressPreview(
      preview: _buildPreview(),
      config: widget.config,
      onPreviewOpen: widget.onPreviewOpen,
      onPreviewClose: widget.onPreviewClose,
      onTap: widget.onTap,
      child: widget.child,
    );
  }
}
