import 'package:flutter/material.dart';
import '../models/book.dart';
import 'book_reader_screen.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;
  const BookDetailScreen({super.key, required this.book});

  static const _accent = Color(0xFFBF6B3A);
  static const _bg = Color(0xFFF8F4F0);
  static const _textDark = Color(0xFF2C1A00);
  static const _textLight = Color(0xFF8D6E63);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildBody(context)),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: _accent,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 16),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Blurred background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_accent.withOpacity(0.9), const Color(0xFF2C1A00)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Cover centered
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 20),
                child: Container(
                  width: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: book.coverUrl != null
                      ? Image.network(book.coverUrl!, fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _placeholderCover())
                      : _placeholderCover(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderCover() {
    return Container(
      height: 180,
      color: Colors.white.withOpacity(0.15),
      child: const Center(child: Text('📖', style: TextStyle(fontSize: 48))),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & Author
          Text(book.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _textDark, height: 1.3)),
          const SizedBox(height: 6),
          Text(book.author, style: const TextStyle(fontSize: 15, color: _accent, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),

          // Meta info chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (book.publishedDate != null) _chip('📅 ${book.publishedDate!.length > 4 ? book.publishedDate!.substring(0, 4) : book.publishedDate!}'),
              if (book.pageCount != null) _chip('📄 ${book.pageCount} pages'),
              if (book.publisher != null) _chip('🏢 ${book.publisher}'),
              ...book.categories.take(2).map((c) => _chip('🏷 $c')),
            ],
          ),
          const SizedBox(height: 20),

          // Divider
          Container(height: 1, color: Colors.black.withOpacity(0.08)),
          const SizedBox(height: 20),

          // Description
          const Text('About this book', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
          const SizedBox(height: 10),
          Text(book.description,
            style: const TextStyle(fontSize: 14, color: _textLight, height: 1.7)),
          const SizedBox(height: 32),

          // Read button
          if (book.previewLink != null)
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => BookReaderScreen(book: book),
              )),
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
                    Text('Read Book', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text('Preview not available', textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 15)),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6)],
      ),
      child: Text(label, style: const TextStyle(fontSize: 12, color: _textDark)),
    );
  }
}