import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/draft.dart';

class StorageService {
  static const _draftsKey = 'saved_drafts';

  Future<void> saveDraft(Draft draft) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await getAllDrafts();
    final index = all.indexWhere((d) => d.id == draft.id);
    if (index != -1) {
      all[index] = draft;
    } else {
      all.add(draft);
    }
    final encoded = all.map((d) => jsonEncode(d.toJson())).toList();
    await prefs.setStringList(_draftsKey, encoded);
  }

  Future<List<Draft>> getAllDrafts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_draftsKey) ?? [];
    return raw.map((s) => Draft.fromJson(jsonDecode(s))).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<void> deleteDraft(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await getAllDrafts();
    all.removeWhere((d) => d.id == id);
    final encoded = all.map((d) => jsonEncode(d.toJson())).toList();
    await prefs.setStringList(_draftsKey, encoded);
  }
}