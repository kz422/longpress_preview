/// Metadata extracted from a URL via Open Graph Protocol.
class OgpData {
  final String url;
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? faviconUrl;
  final String? siteName;

  const OgpData({
    required this.url,
    this.title,
    this.description,
    this.imageUrl,
    this.faviconUrl,
    this.siteName,
  });
}
