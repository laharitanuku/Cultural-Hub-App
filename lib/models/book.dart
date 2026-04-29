class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String? coverUrl;
  final String? previewLink;
  final String? publisher;
  final String? publishedDate;
  final int? pageCount;
  final List<String> categories;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    this.coverUrl,
    this.previewLink,
    this.publisher,
    this.publishedDate,
    this.pageCount,
    this.categories = const [],
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final info = json['volumeInfo'] ?? {};
    final authors = (info['authors'] as List?)?.cast<String>() ?? [];
    final cats = (info['categories'] as List?)?.cast<String>() ?? [];
    final imageLinks = info['imageLinks'] as Map<String, dynamic>?;

    String? cover = imageLinks?['thumbnail'] ?? imageLinks?['smallThumbnail'];
    if (cover != null) {
      cover = cover.replaceFirst('http://', 'https://');
    }

    return Book(
      id: json['id'] ?? '',
      title: info['title'] ?? 'Unknown Title',
      author: authors.isNotEmpty ? authors.join(', ') : 'Unknown Author',
      description: info['description'] ?? 'No description available.',
      coverUrl: cover,
      previewLink: info['previewLink'],
      publisher: info['publisher'],
      publishedDate: info['publishedDate'],
      pageCount: info['pageCount'],
      categories: cats,
    );
  }
}
