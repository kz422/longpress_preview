import 'package:flutter/material.dart';
import '../models/preview_config.dart';
import 'longpress_preview.dart';

/// A [LongPressPreview] optimized for image thumbnails.
///
/// Long-pressing the [child] shows a larger version of [imageProvider]
/// with optional zoom support.
///
/// ```dart
/// LongPressImagePreview(
///   imageProvider: NetworkImage('https://example.com/photo.jpg'),
///   child: MyThumbnail(),
/// )
/// ```
class LongPressImagePreview extends StatelessWidget {
  /// The image to show in the preview.
  final ImageProvider imageProvider;

  /// The thumbnail widget that triggers the preview.
  final Widget child;

  /// Appearance and behavior configuration.
  final PreviewConfig config;

  /// Whether to enable pinch-to-zoom inside the preview.
  final bool enableZoom;

  /// Hero tag for transition animation. Set the same tag on the destination
  /// image for a seamless Hero animation when navigating.
  final Object? heroTag;

  /// Called on normal tap.
  final VoidCallback? onTap;

  /// Creates a [LongPressImagePreview].
  const LongPressImagePreview({
    super.key,
    required this.imageProvider,
    required this.child,
    this.config = const PreviewConfig(),
    this.enableZoom = true,
    this.heroTag,
    this.onTap,
  });

  Widget _buildImagePreview() {
    Widget img = enableZoom
        ? InteractiveViewer(minScale: 1.0, maxScale: 4.0, child: _buildImage())
        : _buildImage();

    if (heroTag != null) {
      img = Hero(tag: heroTag!, child: img);
    }

    return img;
  }

  Widget _buildImage() {
    if (imageProvider is NetworkImage) {
      return Image.network(
        (imageProvider as NetworkImage).url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined),
      );
    }
    return Image(
      image: imageProvider,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LongPressPreview(
      preview: AspectRatio(
        aspectRatio: 1,
        child: _buildImagePreview(),
      ),
      config: config,
      onTap: onTap,
      child: child,
    );
  }
}
