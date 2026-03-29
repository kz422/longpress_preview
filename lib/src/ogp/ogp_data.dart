/// Metadata extracted from a URL via Open Graph Protocol.
class OgpData {
  final String url;
  final String? title;
  /// A short description of the page, from `og:description` or the HTML meta description.
  final String? description;
  final String? imageUrl;
  final String? faviconUrl;
  final String? siteName;

  /// Creates an [OgpData] with the given metadata fields.
  const OgpData({
    required this.url,
    this.title,
    this.description,
    this.imageUrl,
    this.faviconUrl,
    this.siteName,
  });
}
