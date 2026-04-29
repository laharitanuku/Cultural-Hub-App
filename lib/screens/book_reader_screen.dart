import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/book.dart';

class BookReaderScreen extends StatelessWidget {
  final Book book;
  const BookReaderScreen({super.key, required this.book});

  static const _accent = Color(0xFFBF6B3A);
  static const _textDark = Color(0xFF2C1A00);
  static const _textLight = Color(0xFF8D6E63);

  Future<void> _openBook() async {
    final uri = Uri.parse(book.previewLink!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F4F0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_ios, size: 16, color: _textDark),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _textDark)),
            Text(book.author,
              style: const TextStyle(fontSize: 12, color: _accent)),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Cover
              if (book.coverUrl != null)
                Container(
                  height: 200,
                  width: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(book.coverUrl!, fit: BoxFit.cover),
                ),
              const SizedBox(height: 28),
              Text(book.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textDark)),
              const SizedBox(height: 8),
              Text(book.author,
                style: const TextStyle(fontSize: 14, color: _accent, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              const Text(
                'This book opens via Google Books.\nTap below to start reading.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: _textLight, height: 1.6),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: _openBook,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: _accent,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: _accent.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('📖', style: TextStyle(fontSize: 18)),
                      SizedBox(width: 10),
                      Text('Open in Google Books',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}