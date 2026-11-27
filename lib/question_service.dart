import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'questions.dart';

class QuestionCycleService {
  static const _usedIdsKey = 'used_question_ids_v1';
  final Random _random = Random();

  Future<List<QuizQuestion>> nextGame({int count = 15}) async {
    if (count < 1 || count > questionBank.length) {
      throw ArgumentError.value(count, 'count');
    }
    final prefs = await SharedPreferences.getInstance();
    final validIds = questionBank.map((q) => q.id).toSet();
    var used = (prefs.getStringList(_usedIdsKey) ?? <String>[])
        .where(validIds.contains).toSet();

    if (questionBank.length - used.length < count) used.clear();

    final available = questionBank.where((q) => !used.contains(q.id)).toList()
      ..shuffle(_random);
    final selected = available.take(count).toList();
    used.addAll(selected.map((q) => q.id));
    await prefs.setStringList(_usedIdsKey, used.toList());
    return selected;
  }

  Future<void> resetCycle() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usedIdsKey);
  }
}