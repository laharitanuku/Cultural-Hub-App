import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const _apiKey = String.fromEnvironment('GROQ_API_KEY', defaultValue: '');
  static const _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const _model = 'llama-3.3-70b-versatile';

  Future<String> getSuggestions(String text) async {
    return _send(
      'You are a creative writing assistant. Based on this text, suggest 3 creative ways to continue the story. Be specific and inspiring. Text: "$text"',
    );
  }

  Future<String> checkGrammar(String text) async {
    return _send(
      'You are a grammar expert. Fix all grammar, punctuation and spelling errors in this text. Return ONLY the corrected text, nothing else: "$text"',
    );
  }

  Future<String> summarize(String text) async {
    return _send(
      'Summarize this text in 2-3 concise sentences while keeping the core meaning: "$text"',
    );
  }

  Future<String> paraphrase(String text) async {
    return _send(
      'Paraphrase this text in a more eloquent and literary style while keeping the same meaning: "$text"',
    );
  }

  Future<String> _send(String prompt) async {
    if (_apiKey.isEmpty) {
      return 'AI service is not configured. Set GROQ_API_KEY at build time.';
    }

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
          'temperature': 0.7,
          'max_tokens': 1024,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      } else {
        return 'Error: ${response.statusCode} — ${response.body}';
      }
    } catch (e) {
      return 'Connection error: $e';
    }
  }
}