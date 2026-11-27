import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'app_localizations.dart';
import 'language_service.dart';
import 'questions.dart';
import 'question_translations_en.dart';
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
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _playSound(String file) async {
    if (!_soundEnabled) return;
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('sounds/$file.wav'));
    } catch (_) {
      // Keep the quiz playable if the device cannot initialize audio.
    }
  }
  List<QuizQuestion> gameQuestions = <QuizQuestion>[];
  bool questionsLoading = true;
  bool _started = false;
  bool _soundEnabled = true;
  int _secondsRemaining = 30;
  Timer? _countdownTimer;
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

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  QuizQuestion get q => gameQuestions[index];

  void _beginQuiz() {
    if (questionsLoading) return;
    setState(() {
      _started = true;
      finished = false;
      _secondsRemaining = 30;
    });
    _playSound('start');
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || !_started || finished || locked) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_secondsRemaining > 0) _secondsRemaining--;
      });
      if (_soundEnabled && _secondsRemaining <= 10) {
        _playSound('countdown');
      }
      if (_secondsRemaining == 0) {
        timer.cancel();
        setState(() {
          finished = true;
          notice = t('time_up');
        });
      }
    });
  }
  String t(String key) => gameText(widget.languageCode, key);
  LocalizedQuestion? get _englishQ => widget.languageCode == 'en' ? englishQuestionTranslations[q.id] : null;
  String get questionText => _englishQ?.question ?? q.question;
  String get categoryText => _englishQ?.category ?? q.category;
  List<String> get optionTexts => _englishQ?.options ?? q.options;
  String get explanationText => _englishQ?.explanation ?? q.explanation;
  String get guaranteed => index >= 10 ? '10.000 TL' : index >= 5 ? '5.000 TL' : '0 TL';

  void answer(int i) {
    if (locked || hidden.contains(i) || !_started) return;
    _countdownTimer?.cancel();
    setState(() { selected = i; locked = true; });
    Future.delayed(const Duration(milliseconds: 850), () {
      if (!mounted) return;
      setState(() {
        if (i == q.answer) {
          _playSound('correct');
          if (index == gameQuestions.length - 1) {
            finished = true;
            notice = t('top_prize');
          } else {
            notice = t('correct');
            index++;
            selected = null;
            locked = false;
            hidden = [];
            _secondsRemaining = 30;
            _startCountdown();
          }
        } else {
          _playSound('wrong');
          finished = true;
          notice = '${t('wrong')} ${optionTexts[q.answer]}';
        }
      });
    });
  }

  void useFifty() {
    if (fiftyUsed || locked) return;
    final wrong = List<int>.generate(4, (i) => i)..remove(q.answer)..shuffle();
    _playSound('joker');
    setState(() { fiftyUsed = true; hidden = wrong.take(2).toList(); notice = t('fifty_used'); });
  }

  void useAudience() {
    if (audienceUsed || locked) return;
    _playSound('joker');
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
      notice = '${t('audience_result')} ${vals.asMap().entries.map((e) => '${String.fromCharCode(65 + e.key)}: ${e.value}%').join('  ')}';
    });
  }

  void useExpert() {
    if (expertUsed || locked) return;
    _playSound('joker');
    setState(() { expertUsed = true; notice = '${t('hint')}: ${explanationText}'; });
  }

  Future<void> restart() async {
    _countdownTimer?.cancel();
    setState(() {
      _started = false;
      _secondsRemaining = 30;
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
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D3028), Color(0xFF061511), Color(0xFF04100E)],
          ),
        ),
        child: SafeArea(
          child: questionsLoading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFFE8C878)))
              : finished
                  ? _result()
                  : !_started
                      ? _intro()
                      : LayoutBuilder(
                      builder: (context, constraints) {
                        final compact = constraints.maxWidth < 700;
                        if (compact) {
                          return Column(
                            children: [
                              Expanded(flex: 8, child: _quizPanel(compact: true)),
                              _mobileTools(),
                            ],
                          );
                        }
                        return Row(
                          children: [
                            Expanded(flex: 7, child: _quizPanel(compact: false)),
                            Container(width: 1, color: const Color(0xFF315448)),
                            SizedBox(width: 250, child: _desktopTools()),
                          ],
                        );
                      },
                    ),
        ),
      ),
    );
  }

  Widget _intro() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(26),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 104, height: 104,
                decoration: BoxDecoration(
                  color: const Color(0x22E8C878),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0x99E8C878), width: 1.5),
                ),
                child: const Icon(Icons.auto_awesome, color: Color(0xFFFFD978), size: 52),
              ),
              const SizedBox(height: 25),
              Text(t('title'), textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFFFFD978), fontSize: 25, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
              const SizedBox(height: 10),
              const Text('BİLGİNİ SINAMAYA HAZIR MISIN?', textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 2)),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF10352B),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0x66E8C878)),
                ),
                child: const Column(children: [
                  Icon(Icons.timer_outlined, color: Color(0xFFFFD978), size: 34),
                  SizedBox(height: 9),
                  Text('15 SORU  •  30 SANİYE', style: TextStyle(color: Color(0xFFFFD978), fontWeight: FontWeight.bold, letterSpacing: 1)),
                  SizedBox(height: 8),
                  Text('Her soru için 30 saniyen var. Süre dolarsa oyun sona erer. Jokerlerini doğru zamanda kullan!',
                    textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, height: 1.45)),
                ]),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(color: const Color(0x221FFFFFFF), borderRadius: BorderRadius.circular(18)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.volume_up_rounded, color: Color(0xFFFFD978), size: 20),
                  const SizedBox(width: 10),
                  const Text('Süre uyarı sesi', style: TextStyle(color: Colors.white)),
                  const SizedBox(width: 8),
                  Switch(value: _soundEnabled, activeColor: const Color(0xFFFFD978),
                    onChanged: (value) => setState(() => _soundEnabled = value)),
                ]),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity, height: 58,
                child: FilledButton.icon(
                  onPressed: _beginQuiz,
                  icon: const Icon(Icons.play_arrow_rounded, size: 28),
                  label: const Text('OYUNA BAŞLA', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFE8C878),
                    foregroundColor: const Color(0xFF071B18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(onPressed: _selectLanguage,
                icon: const Icon(Icons.language, color: Color(0xFFFFD978)),
                label: Text(t('language'), style: const TextStyle(color: Color(0xFFFFD978)))),
              Text(t('disclaimer'), textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white38, fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quizPanel({required bool compact}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(compact ? 16 : 24, 12, compact ? 16 : 24, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: const Color(0x22E8C878),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0x55E8C878)),
                ),
                child: const Icon(Icons.auto_awesome, color: Color(0xFFE8C878), size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t('title'), maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.1, color: Color(0xFFFFD978), fontSize: 14)),
                    const SizedBox(height: 2),
                    const Text('BİLGİ YARIŞMASI', style: TextStyle(color: Colors.white54, fontSize: 9, letterSpacing: 2)),
                  ],
                ),
              ),
              IconButton(
                onPressed: _selectLanguage,
                tooltip: t('language'),
                style: IconButton.styleFrom(backgroundColor: const Color(0x221FFFFFFF)),
                icon: const Icon(Icons.language, color: Color(0xFFE8C878)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text('${t('question')} ${index + 1} / 15',
                  style: const TextStyle(color: Color(0xFFFFD978), fontWeight: FontWeight.w800, letterSpacing: 1)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                decoration: BoxDecoration(color: const Color(0x22E8C878), borderRadius: BorderRadius.circular(20)),
                child: Text(categoryText.toUpperCase(), style: const TextStyle(color: Color(0xFFFFD978), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              const Icon(Icons.timer_outlined, color: Color(0xFFFFD978), size: 18),
              const SizedBox(width: 6),
              Text('00:${_secondsRemaining.toString().padLeft(2, '0')}',
                style: TextStyle(
                  color: _secondsRemaining <= 10 ? const Color(0xFFFF7770) : const Color(0xFFFFD978),
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                )),
              const SizedBox(width: 10),
              Expanded(child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (index + 1) / 15,
                  minHeight: 5,
                  backgroundColor: const Color(0xFF25483D),
                  valueColor: AlwaysStoppedAnimation(_secondsRemaining <= 10 ? const Color(0xFFE66A5E) : const Color(0xFFE8C878)),
                ),
              )),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: compact ? 25 : 34),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF174638), Color(0xFF0D2C24)]),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0x99D6AE55), width: 1.2),
                      boxShadow: const [BoxShadow(color: Color(0x44000000), blurRadius: 22, offset: Offset(0, 9))],
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.stars_rounded, color: Color(0xFFE8C878), size: 25),
                        const SizedBox(height: 12),
                        Text(questionText, textAlign: TextAlign.center,
                          style: TextStyle(fontSize: compact ? 20 : 25, height: 1.4, fontWeight: FontWeight.w700, color: const Color(0xFFFFF5D9))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 17),
                  ...List.generate(4, (i) {
                    final isSelected = selected == i;
                    final isHidden = hidden.contains(i);
                    final isCorrect = isSelected && i == q.answer;
                    final isWrong = isSelected && i != q.answer;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: locked || isHidden ? null : () => answer(i),
                          borderRadius: BorderRadius.circular(16),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
                            decoration: BoxDecoration(
                              gradient: isCorrect
                                  ? const LinearGradient(colors: [Color(0xFF287A50), Color(0xFF174D37)])
                                  : isWrong
                                      ? const LinearGradient(colors: [Color(0xFF8C3935), Color(0xFF542421)])
                                      : const LinearGradient(colors: [Color(0xFF153C31), Color(0xFF102D25)]),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: isSelected ? const Color(0xFFFFD978) : const Color(0x665F927C), width: isSelected ? 1.8 : 1),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 34, height: 34,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color(0x22E8C878),
                                    borderRadius: BorderRadius.circular(11),
                                    border: Border.all(color: const Color(0x66E8C878)),
                                  ),
                                  child: Text(String.fromCharCode(65 + i), style: const TextStyle(color: Color(0xFFFFD978), fontWeight: FontWeight.w900)),
                                ),
                                const SizedBox(width: 13),
                                Expanded(child: Text(isHidden ? '' : optionTexts[i],
                                  style: const TextStyle(fontSize: 15, height: 1.3, color: Color(0xFFF4F1E7), fontWeight: FontWeight.w500))),
                                if (isCorrect) const Icon(Icons.check_circle, color: Color(0xFFFFD978))
                                else if (isWrong) const Icon(Icons.cancel, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  if (notice != null)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFF183D32), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0x55E8C878))),
                      child: Text(notice!, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFFFFD978), fontSize: 13)),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 6),
                    child: Text(t('disclaimer'), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white38, fontSize: 10)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _desktopTools() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 20, 14, 18),
      child: Column(
        children: [
          Text(t('lifelines'), style: const TextStyle(color: Color(0xFFFFD978), fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 12),
          _joker(t('fifty'), fiftyUsed, useFifty),
          _joker(t('audience'), audienceUsed, useAudience),
          _joker(t('expert'), expertUsed, useExpert),
          const Divider(height: 26, color: Color(0xFF527B6B)),
          Text(t('ladder'), style: const TextStyle(color: Color(0xFFFFD978), fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(child: _prizeLadder()),
        ],
      ),
    );
  }

  Widget _mobileTools() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      decoration: const BoxDecoration(
        color: Color(0xFF0B211B),
        border: Border(top: BorderSide(color: Color(0x665F927C))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: _mobileJoker(Icons.filter_2, t('fifty'), fiftyUsed, useFifty)),
              const SizedBox(width: 8),
              Expanded(child: _mobileJoker(Icons.groups_rounded, t('audience'), audienceUsed, useAudience)),
              const SizedBox(width: 8),
              Expanded(child: _mobileJoker(Icons.lightbulb_outline, t('expert'), expertUsed, useExpert)),
            ],
          ),
          const SizedBox(height: 7),
          SizedBox(height: 34, child: _prizeLadder(horizontal: true)),
        ],
      ),
    );
  }

  Widget _mobileJoker(IconData icon, String label, bool used, VoidCallback action) {
    return OutlinedButton(
      onPressed: used || locked ? null : action,
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFFFFD978),
        side: const BorderSide(color: Color(0x88D6AE55)),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        minimumSize: const Size(0, 42),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 17),
        const SizedBox(height: 2),
        Text(used ? '✓' : label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 9)),
      ]),
    );
  }

  Widget _prizeLadder({bool horizontal = false}) {
    if (horizontal) {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse: true,
        itemCount: prizeLadder.length,
        itemBuilder: (context, i) {
          final actual = 14 - i;
          final active = actual == index;
          final safe = actual == 4 || actual == 9;
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(left: 5),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: active ? const Color(0xFFE8C878) : const Color(0xFF17382E),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: active ? const Color(0xFFFFE8A6) : const Color(0x335F927C)),
            ),
            child: Text(prizeLadder[actual], style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold,
              color: active ? const Color(0xFF071B18) : safe ? const Color(0xFFFFD978) : Colors.white70)),
          );
        },
      );
    }
    return ListView.builder(
      reverse: true,
      itemCount: prizeLadder.length,
      itemBuilder: (context, i) {
        final actual = 14 - i;
        final active = actual == index;
        final safe = actual == 4 || actual == 9;
        return Container(
          margin: const EdgeInsets.only(bottom: 5),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 9),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFE8C878) : const Color(0x2217382E),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: active ? const Color(0xFFFFE8A6) : const Color(0x225F927C)),
          ),
          child: Text('${actual + 1}.  ${prizeLadder[actual]}', textAlign: TextAlign.right,
            style: TextStyle(fontSize: 11, fontWeight: active ? FontWeight.bold : FontWeight.normal,
              color: active ? const Color(0xFF071B18) : safe ? const Color(0xFFFFD978) : Colors.white70)),
        );
      },
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
        Text(index == 14 && notice?.startsWith('Congratulations') == true ? t('excellent') : t('game_over'),
          textAlign: TextAlign.center, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xFFE8C878))),
        const SizedBox(height: 12),
        Text(notice ?? 'The game has ended.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 17)),
        const SizedBox(height: 10),
        Text('${t('guaranteed_level')}: $guaranteed', style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 24),
        FilledButton.icon(onPressed: restart, icon: const Icon(Icons.replay), label: Text(t('play_again'))),
      ]),
    ),
  );
}
