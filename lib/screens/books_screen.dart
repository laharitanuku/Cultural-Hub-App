import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/book.dart';
import '../services/books_service.dart';
import 'book_detail_screen.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final _service = BooksService();
  final _searchController = TextEditingController();

  List<Book> _featured = [];
  List<Book> _searchResults = [];
  bool _loadingFeatured = true;
  bool _searching = false;
  bool _hasSearched = false;

  static const _accent = Color(0xFFBF6B3A);
  static const _bg = Color(0xFFF8F4F0);
  static const _textDark = Color(0xFF2C1A00);
  static const _textLight = Color(0xFF8D6E63);

  final _categories = [
    'Fiction', 'Mystery', 'Romance', 'Science', 'History', 'Fantasy', 'Biography'
  ];

  @override
  void initState() {
    super.initState();
    _loadFeatured();
    _searchController.addListener(() => setState(() {}));
  }

  Future<void> _loadFeatured() async {
    final books = await _service.getFeaturedBooks();
    if (mounted) setState(() { _featured = books; _loadingFeatured = false; });
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      setState(() { _hasSearched = false; _searchResults = []; });
      return;
    }
    setState(() { _searching = true; _hasSearched = true; });
    final results = await _service.searchBooks(query);
    if (mounted) setState(() { _searchResults = results; _searching = false; });
  }

  Future<void> _searchCategory(String cat) async {
    _searchController.text = cat;
    await _search(cat);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildCategories(),
            Expanded(
              child: _hasSearched ? _buildSearchResults() : _buildFeatured(),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 8)],
              ),
              child: const Icon(Icons.arrow_back_ios, size: 16, color: _textDark),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('📚 Library',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22, fontWeight: FontWeight.bold, color: _textDark)),
              Text('Discover your next read',
                style: GoogleFonts.lato(fontSize: 12, color: _textLight)),
            ],
          ),
        ],
      ),
    );
  }

  // ── Search Bar ───────────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 10, offset: const Offset(0, 2))],
        ),
        child: TextField(
          controller: _searchController,
          onSubmitted: _search,
          style: GoogleFonts.lato(color: _textDark, fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Search books, authors...',
            hintStyle: GoogleFonts.lato(color: _textLight, fontSize: 15),
            prefixIcon: const Icon(Icons.search, color: _textLight),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: _textLight, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      setState(() { _hasSearched = false; _searchResults = []; });
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  // ── Category Chips ───────────────────────────────────────────────────────────

  Widget _buildCategories() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final cat = _categories[i];
          final isActive = _searchController.text == cat;
          return GestureDetector(
            onTap: () => _searchCategory(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isActive ? _accent : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6)],
              ),
              child: Text(cat,
                style: GoogleFonts.lato(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : _textDark,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Featured Grid ────────────────────────────────────────────────────────────

  Widget _buildFeatured() {
    if (_loadingFeatured) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: _accent, strokeWidth: 2),
            const SizedBox(height: 14),
            Text('Loading books...', style: GoogleFonts.lato(color: _textLight, fontSize: 14)),
          ],
        ),
      );
    }

    if (_featured.isEmpty) {
      return _buildEmpty('No books found.\nCheck your internet connection.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
          child: Text('Featured Books',
            style: GoogleFonts.playfairDisplay(
              fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.58,
              crossAxisSpacing: 10,
              mainAxisSpacing: 14,
            ),
            itemCount: _featured.length,
            itemBuilder: (_, i) => _buildBookCard(_featured[i]),
          ),
        ),
      ],
    );
  }

  // ── Search Results ───────────────────────────────────────────────────────────

  Widget _buildSearchResults() {
    if (_searching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: _accent, strokeWidth: 2),
            const SizedBox(height: 14),
            Text('Searching...', style: GoogleFonts.lato(color: _textLight, fontSize: 14)),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return _buildEmpty('No results for "${_searchController.text}".\nTry a different search.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${_searchResults.length} results  ',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 16, fontWeight: FontWeight.bold, color: _textDark),
                ),
                TextSpan(
                  text: 'for "${_searchController.text}"',
                  style: GoogleFonts.lato(fontSize: 13, color: _textLight),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.58,
              crossAxisSpacing: 10,
              mainAxisSpacing: 14,
            ),
            itemCount: _searchResults.length,
            itemBuilder: (_, i) => _buildBookCard(_searchResults[i]),
          ),
        ),
      ],
    );
  }

  // ── Book Card ────────────────────────────────────────────────────────────────

  Widget _buildBookCard(Book book) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover image
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 10,
                    offset: const Offset(2, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _buildCoverImage(book),
              ),
            ),
          ),
          const SizedBox(height: 6),
          // Title
          Text(
            book.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lato(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: _textDark,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 2),
          // Author
          Text(
            book.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lato(fontSize: 10, color: _textLight),
          ),
        ],
      ),
    );
  }

  // ── Cover Image with fallback ─────────────────────────────────────────────

  Widget _buildCoverImage(Book book) {
    // No cover URL at all
    if (book.coverUrl == null || book.coverUrl!.isEmpty) {
      return _buildPlaceholderCover(book);
    }

    return Image.network(
      book.coverUrl!,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      // Required for Flutter Web CORS
      headers: const {
        'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
      },
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: const Color(0xFFEDE0D4),
          child: Center(
            child: CircularProgressIndicator(
              value: progress.expectedTotalBytes != null
                  ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                  : null,
              color: _accent,
              strokeWidth: 2,
            ),
          ),
        );
      },
      errorBuilder: (_, _, _) => _buildPlaceholderCover(book),
    );
  }

  Widget _buildPlaceholderCover(Book book) {
    // Derive a warm color from the title hash so each placeholder is unique
    final colors = [
      const Color(0xFFBF6B3A),
      const Color(0xFF5C7A4E),
      const Color(0xFF4A6B8A),
      const Color(0xFF8A4A6B),
      const Color(0xFF6B6B3A),
      const Color(0xFF3A6B6B),
    ];
    final color = colors[book.title.length % colors.length];

    return Container(
      color: color.withOpacity(0.15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book_rounded, color: color, size: 32),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              book.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: color,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty State ───────────────────────────────────────────────────────────

  Widget _buildEmpty(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 56, color: _textLight.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(color: _textLight, fontSize: 14, height: 1.6),
          ),
        ],
      ),
    );
  }
}
