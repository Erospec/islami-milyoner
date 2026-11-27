import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'questions.dart';

/// Keeps a persistent cycle of question IDs so a player does not see
/// the same question again until the full pool has been exhausted.
class QuestionCycleService {
  static const _usedIdsKey = 'used_question_ids_v1';
  final Random _random = Random();

  Future<List<QuizQuestion>> nextGame({int count = 15}) async {
    final preferences = await SharedPreferences.getInstance();
    final savedIds = preferences.getStringList(_usedIdsKey) ?? <String>[];
    final validIds = questionBank.map((q) => q.id).toSet();
    var usedIds = savedIds.where(validIds.contains).toSet();

    // Start a new cycle only when fewer than one full game remains.
    if (questionBank.length - usedIds.length < count) {
      usedIds = <String>{};
    }

    final available = questionBank.where((q) => !usedIds.contains(q.id)).toList()
      ..shuffle(_random);
    final selected = available.take(count).toList();

    usedIds.addAll(selected.map((q) => q.id));
    await preferences.setStringList(_usedIdsKey, usedIds.toList());
    return selected;
  }

  Future<void> resetCycle() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_usedIdsKey);
  }
}
