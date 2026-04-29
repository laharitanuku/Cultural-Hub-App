import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class BooksService {
  static const _baseUrl = 'https://www.googleapis.com/books/v1/volumes';

  Future<List<Book>> searchBooks(String query, {int maxResults = 20}) async {
    if (query.trim().isEmpty) return [];
    try {
      final uri = Uri.parse(
        '$_baseUrl?q=${Uri.encodeComponent(query)}&maxResults=$maxResults&printType=books',
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final items = (data['items'] as List?) ?? [];
        return items.map((e) => Book.fromJson(e)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<List<Book>> getFeaturedBooks() async {
    return searchBooks('bestseller fiction 2024', maxResults: 10);
  }

  Future<List<Book>> getBooksByCategory(String category) async {
    return searchBooks('subject:$category', maxResults: 15);
  }
}
