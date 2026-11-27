import 'dart:math';
import 'package:flutter/material.dart';
import 'app_localizations.dart';
import 'language_service.dart';
import 'questions.dart';
import 'question_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const IslamicMillionaireApp());
}

const prizeLadder = [
  '1.000 TL', '2.000 TL', '3.000 TL', '5.000 TL', '7.500 TL',
  '10.000 TL', '15.000 TL', '25.000 TL', '40.000 TL', '60.000 TL',
  '100.000 TL', '250.000 TL', '500.000 TL', '750.000 TL', '1.000.000 TL'
];

class IslamicMillionaireApp extends StatefulWidget {
  const IslamicMillionaireApp({super.key});

  @override
  State<IslamicMillionaireApp> createState() => _IslamicMillionaireAppState();
}

class _IslamicMillionaireAppState extends State<IslamicMillionaireApp> {
  final LanguageService _languageService = LanguageService();
  String _languageCode = 'tr';
  bool _languageLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final deviceCode = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    final savedCode = await _languageService.loadLanguage(deviceCode);
    if (!mounted) return;
    setState(() {
      _languageCode = savedCode;
      _languageLoaded = true;
    });
  }

  Future<void> _changeLanguage(String code) async {
    await _languageService.saveLanguage(code);
    if (!mounted) return;
    setState(() => _languageCode = code);
  }

  @override
  Widget build(BuildContext context) {
    final rtl = isRtlLanguage(_languageCode);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'İslamiyet Milyoneri',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF071B18),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD6AE55), brightness: Brightness.dark),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: Directionality(
        textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
        child: _languageLoaded
            ? HomePage(languageCode: _languageCode, onLanguageChanged: _changeLanguage)
            : const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String languageCode;
  final ValueChanged<String> onLanguageChanged;

  const HomePage({super.key, required this.languageCode, required this.onLanguageChanged});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final QuestionCycleService _questionService = QuestionCycleService();
  List<QuizQuestion> gameQuestions = <QuizQuestion>[];
  bool questionsLoading = true;
  int index = 0;
  int? selected;
  bool locked = false, finished = false, fiftyUsed = false, audienceUsed = false, expertUsed = false;
  String? notice;
  List<int> hidden = [];
  final random = Random();

  @override
  void initState() {
    super.initState();
    _loadNextGame();
  }

  Future<void> _loadNextGame() async {
    final selectedQuestions = await _questionService.nextGame();
    if (!mounted) return;
    setState(() {
      gameQuestions = selectedQuestions;
      questionsLoading = false;
    });
  }

  QuizQuestion get q => gameQuestions[index];
  String t(String key) => gameText(widget.languageCode, key);
  String get guaranteed => index >= 10 ? '10.000 TL' : index >= 5 ? '5.000 TL' : '0 TL';

  void answer(int i) {
    if (locked || hidden.contains(i)) return;
    setState(() { selected = i; locked = true; });
    Future.delayed(const Duration(milliseconds: 850), () {
      if (!mounted) return;
      setState(() {
        if (i == q.answer) {
          if (index == gameQuestions.length - 1) {
            finished = true;
            notice = 'Congratulations! You reached the top prize.';
          } else {
            notice = t('correct');
            index++;
            selected = null;
            locked = false;
            hidden = [];
          }
        } else {
          finished = true;
          notice = '${t('wrong')} ${q.options[q.answer]}';
        }
      });
    });
  }

  void useFifty() {
    if (fiftyUsed || locked) return;
    final wrong = List<int>.generate(4, (i) => i)..remove(q.answer)..shuffle();
    setState(() { fiftyUsed = true; hidden = wrong.take(2).toList(); notice = 'Two incorrect options removed.'; });
  }

  void useAudience() {
    if (audienceUsed || locked) return;
    final correct = 45 + random.nextInt(36);
    final remaining = 100 - correct;
    final vals = [0, 0, 0, 0];
    vals[q.answer] = correct;
    final wrong = List<int>.generate(4, (i) => i)..remove(q.answer);
    var left = remaining;
    for (var j = 0; j < wrong.length; j++) {
      final v = j == wrong.length - 1 ? left : random.nextInt(left + 1);
      vals[wrong[j]] = v;
      left -= v;
    }
    setState(() {
      audienceUsed = true;
      notice = 'Audience: ${vals.asMap().entries.map((e) => '${String.fromCharCode(65 + e.key)}: ${e.value}%').join('  ')}';
    });
  }

  void useExpert() {
    if (expertUsed || locked) return;
    setState(() { expertUsed = true; notice = 'Hint: ${q.explanation}'; });
  }

  Future<void> restart() async {
    setState(() {
      questionsLoading = true;
      index = 0; selected = null; locked = false; finished = false;
      fiftyUsed = false; audienceUsed = false; expertUsed = false; notice = null; hidden = [];
    });
    await _loadNextGame();
  }

  Future<void> _selectLanguage() async {
    final selectedCode = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF10332C),
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: SizedBox(
          height: MediaQuery.of(sheetContext).size.height * 0.72,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18),
                child: Text(t('language'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFE8C878))),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: supportedLanguages.length,
                  itemBuilder: (context, i) {
                    final language = supportedLanguages[i];
                    return ListTile(
                      title: Text(language.nativeName, textDirection: language.isRtl ? TextDirection.rtl : TextDirection.ltr),
                      trailing: language.code == widget.languageCode ? const Icon(Icons.check, color: Color(0xFFE8C878)) : null,
                      onTap: () => Navigator.pop(sheetContext, language.code),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (selectedCode != null) widget.onLanguageChanged(selectedCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: questionsLoading
            ? const Center(child: CircularProgressIndicator())
            : finished ? _result() : Row(children: [
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 10, 18),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(children: [
                  const Icon(Icons.nights_stay, color: Color(0xFFD6AE55)),
                  const SizedBox(width: 8),
                  Expanded(child: Text(t('title'), style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1, color: Color(0xFFE8C878), fontSize: 13))),
                  IconButton(onPressed: _selectLanguage, tooltip: t('language'), icon: const Icon(Icons.language, color: Color(0xFFE8C878))),
                ]),
                const SizedBox(height: 12),
                Text('${t('question')} ${index + 1} / 15  •  ${q.category.toUpperCase()}',
                  style: const TextStyle(color: Color(0xFFD6AE55), fontWeight: FontWeight.w700, letterSpacing: 1)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(color: const Color(0xFF10332C), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFB78C3B))),
                  child: Text(q.question, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, height: 1.35, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 20),
                ...List.generate(4, (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () => answer(i),
                    borderRadius: BorderRadius.circular(14),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                      decoration: BoxDecoration(
                        color: hidden.contains(i) ? Colors.transparent : selected == i
                            ? (i == q.answer ? const Color(0xFF236A45) : const Color(0xFF873D36))
                            : const Color(0xFF123D34),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: selected == i ? const Color(0xFFE8C878) : const Color(0xFF527B6B)),
                      ),
                      child: Row(children: [
                        Text(String.fromCharCode(65 + i), style: const TextStyle(color: Color(0xFFE8C878), fontWeight: FontWeight.bold)),
                        const SizedBox(width: 12),
                        Expanded(child: Text(hidden.contains(i) ? ' ' : q.options[i], style: const TextStyle(fontSize: 16))),
                      ]),
                    ),
                  ),
                )),
                const Spacer(),
                if (notice != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFF183D32), borderRadius: BorderRadius.circular(12)),
                    child: Text(notice!, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFFE8C878))),
                  ),
                const SizedBox(height: 8),
                Text(t('disclaimer'), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white54, fontSize: 11)),
              ]),
            ),
          ),
          Container(width: 1, color: const Color(0xFF315448)),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 18, 10, 18),
              child: Column(children: [
                Text(t('lifelines'), style: const TextStyle(color: Color(0xFFD6AE55), fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 12),
                _joker(t('fifty'), fiftyUsed, useFifty),
                _joker(t('audience'), audienceUsed, useAudience),
                _joker(t('expert'), expertUsed, useExpert),
                const Divider(height: 24, color: Color(0xFF527B6B)),
                Text(t('ladder'), style: const TextStyle(color: Color(0xFFD6AE55), fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: prizeLadder.length,
                    itemBuilder: (context, i) {
                      final actual = 14 - i;
                      final active = actual == index;
                      final safe = actual == 4 || actual == 9;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 6),
                        decoration: BoxDecoration(color: active ? const Color(0xFFB78C3B) : Colors.transparent, borderRadius: BorderRadius.circular(7)),
                        child: Text('${actual + 1}.  ${prizeLadder[actual]}', textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 11, fontWeight: active ? FontWeight.bold : FontWeight.normal,
                            color: active ? const Color(0xFF071B18) : safe ? const Color(0xFFE8C878) : Colors.white70)),
                      );
                    },
                  ),
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _joker(String label, bool used, VoidCallback action) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: OutlinedButton(
      onPressed: used || locked ? null : action,
      style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFE8C878), side: const BorderSide(color: Color(0xFFB78C3B))),
      child: Text(used ? '$label ✓' : label, style: const TextStyle(fontSize: 12)),
    ),
  );

  Widget _result() => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.emoji_events, size: 76, color: Color(0xFFE8C878)),
        const SizedBox(height: 18),
        Text(index == 14 && notice?.startsWith('Congratulations') == true ? 'EXCELLENT!' : 'GAME OVER',
          textAlign: TextAlign.center, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xFFE8C878))),
        const SizedBox(height: 12),
        Text(notice ?? 'The game has ended.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 17)),
        const SizedBox(height: 10),
        Text('Guaranteed level: $guaranteed', style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 24),
        FilledButton.icon(onPressed: restart, icon: const Icon(Icons.replay), label: Text(t('play_again'))),
      ]),
    ),
  );
}
