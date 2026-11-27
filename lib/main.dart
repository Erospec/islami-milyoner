import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const IslamicMillionaireApp());

class QuizQuestion {
  final String category, question, explanation;
  final List<String> options;
  final int answer;
  const QuizQuestion(this.category, this.question, this.options, this.answer, this.explanation);
}

const questions = <QuizQuestion>[
  QuizQuestion('Kur’an', 'Kur’an-ı Kerim’de kaç sure vardır?',
    ['110', '112', '114', '116'], 2, 'Kur’an-ı Kerim 114 sureden oluşur.'),
  QuizQuestion('Siyer', 'Hz. Muhammed’e (s.a.v.) ilk vahiy hangi mağarada gelmiştir?',
    ['Sevr', 'Hira', 'Nur', 'Arafat'], 1, 'İlk vahiy, Mekke yakınlarındaki Hira Mağarası’nda gelmiştir.'),
  QuizQuestion('İbadet', 'İslam’ın şartı kaçtır?',
    ['Üç', 'Dört', 'Beş', 'Altı'], 2, 'Yaygın olarak öğretilen tasnife göre İslam’ın beş şartı vardır.'),
  QuizQuestion('Kur’an', 'Kur’an-ı Kerim’in ilk suresi hangisidir?',
    ['Bakara', 'Fatiha', 'İhlas', 'Alak'], 1, 'Mushaf sıralamasındaki ilk sure Fatiha Suresi’dir.'),
  QuizQuestion('Siyer', 'Hz. Muhammed (s.a.v.) hangi şehirde dünyaya gelmiştir?',
    ['Medine', 'Taif', 'Kudüs', 'Mekke'], 3, 'Hz. Muhammed (s.a.v.) Mekke’de dünyaya gelmiştir.'),
  QuizQuestion('Kur’an', 'Kur’an-ı Kerim hangi dilde indirilmiştir?',
    ['İbranice', 'Arapça', 'Süryanice', 'Farsça'], 1, 'Kur’an’ın kendi ifadesiyle Arapça bir Kur’an olarak indirilmiştir.'),
  QuizQuestion('Hadis', '“Ameller niyetlere göredir” hadisi en çok hangi konuyu vurgular?',
    ['Niyetin önemini', 'Ticaretin önemini', 'Yolculuğu', 'Komşuluk hukukunu'], 0, 'Bu hadis, yapılan işlerde niyetin belirleyici önemini vurgular.'),
  QuizQuestion('İslam Tarihi', 'Hicret, Müslümanların hangi şehirden hangi şehre göçüdür?',
    ['Mekke’den Medine’ye', 'Medine’den Şam’a', 'Taif’ten Mekke’ye', 'Kudüs’ten Medine’ye'], 0, 'Hicret, 622 yılında Mekke’den Medine’ye gerçekleşmiştir.'),
  QuizQuestion('Kur’an', 'Kur’an-ı Kerim’in en uzun suresi hangisidir?',
    ['Âl-i İmrân', 'Nisâ', 'Bakara', 'Mâide'], 2, 'En uzun sure, 286 ayetli Bakara Suresi’dir.'),
  QuizQuestion('Siyer', 'İlk Müslüman kadın olarak kabul edilen kişi kimdir?',
    ['Hz. Âişe', 'Hz. Hatice', 'Hz. Fatıma', 'Hz. Hafsa'], 1, 'Hz. Hatice, İslam’ı ilk kabul eden kişidir.'),
  QuizQuestion('İslam Tarihi', 'Bedir Savaşı hicretin kaçıncı yılında gerçekleşmiştir?',
    ['1. yıl', '2. yıl', '3. yıl', '5. yıl'], 1, 'Bedir Savaşı, hicretin ikinci yılında (624) gerçekleşmiştir.'),
  QuizQuestion('Hadis', 'Kütüb-i Sitte ifadesi geleneksel olarak kaç hadis kitabını ifade eder?',
    ['Dört', 'Beş', 'Altı', 'Yedi'], 2, 'Kütüb-i Sitte, Sünni hadis geleneğinde altı temel hadis kitabı için kullanılan addır.'),
  QuizQuestion('Kur’an', 'Kur’an-ı Kerim’de adı geçen ve aynı zamanda bir sureye adını veren peygamber kimdir?',
    ['Hz. Yunus', 'Hz. Yusuf', 'Hz. İdris', 'Hz. Şuayb'], 1, 'Yusuf Suresi, Hz. Yusuf’un kıssasını anlatır.'),
  QuizQuestion('İslam Tarihi', 'Mekke’nin fethi hangi hicrî yılda gerçekleşmiştir?',
    ['6', '7', '8', '10'], 2, 'Mekke’nin fethi hicretin 8. yılında, miladi 630’da gerçekleşmiştir.'),
  QuizQuestion('Kur’an ve Siyer', 'Veda Hutbesi, Hz. Muhammed (s.a.v.) tarafından hangi hac sırasında irat edilmiştir?',
    ['Umre', 'Veda Haccı', 'İlk hac', 'Kaza umresi'], 1, 'Veda Hutbesi, hicretin 10. yılında yapılan Veda Haccı sırasında irat edilmiştir.'),
];

const prizeLadder = [
  '1.000 TL', '2.000 TL', '3.000 TL', '5.000 TL', '7.500 TL',
  '10.000 TL', '15.000 TL', '25.000 TL', '40.000 TL', '60.000 TL',
  '100.000 TL', '250.000 TL', '500.000 TL', '750.000 TL', '1.000.000 TL'
];

class IslamicMillionaireApp extends StatelessWidget {
  const IslamicMillionaireApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'İslamiyet Milyoneri',
    theme: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF071B18),
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD6AE55), brightness: Brightness.dark),
      useMaterial3: true,
      fontFamily: 'Roboto',
    ),
    home: const HomePage(),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  int? selected;
  bool locked = false, finished = false, fiftyUsed = false, audienceUsed = false, expertUsed = false;
  String? notice;
  List<int> hidden = [];
  final random = Random();

  QuizQuestion get q => questions[index];
  bool get safeLevel => index >= 4 && index < 9 ? true : index >= 9;
  String get guaranteed => index >= 10 ? '10.000 TL' : index >= 5 ? '5.000 TL' : '0 TL';

  void answer(int i) {
    if (locked || hidden.contains(i)) return;
    setState(() { selected = i; locked = true; });
    Future.delayed(const Duration(milliseconds: 850), () {
      if (!mounted) return;
      setState(() {
        if (i == q.answer) {
          if (index == questions.length - 1) { finished = true; notice = 'Tebrikler! Büyük ödüle ulaştın.'; }
          else { notice = 'Doğru cevap!'; index++; selected = null; locked = false; hidden = []; }
        } else {
          finished = true;
          notice = 'Yanlış cevap. Doğru cevap: ${q.options[q.answer]}';
        }
      });
    });
  }

  void useFifty() {
    if (fiftyUsed || locked) return;
    final wrong = List<int>.generate(4, (i) => i)..remove(q.answer)..shuffle();
    setState(() { fiftyUsed = true; hidden = wrong.take(2).toList(); notice = 'İki yanlış seçenek kaldırıldı.'; });
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
      vals[wrong[j]] = v; left -= v;
    }
    setState(() { audienceUsed = true; notice = 'Seyirci tahmini: ${vals.asMap().entries.map((e) => '${String.fromCharCode(65+e.key)}: %${e.value}').join('  ')}'; });
  }
  void useExpert() {
    if (expertUsed || locked) return;
    setState(() { expertUsed = true; notice = 'Bilge ipucu: ${q.explanation}'; });
  }
  void restart() => setState(() {
    index = 0; selected = null; locked = false; finished = false;
    fiftyUsed = false; audienceUsed = false; expertUsed = false; notice = null; hidden = [];
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: finished ? _result() : Row(children: [
        Expanded(flex: 7, child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 10, 18),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: const [Icon(Icons.nights_stay, color: Color(0xFFD6AE55)), SizedBox(width: 8), Text('İSLAMİYET MİLYONERİ', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1, color: Color(0xFFE8C878)))]),
            const SizedBox(height: 20),
            Text('SORU ${index + 1} / 15  •  ${q.category.toUpperCase()}', style: const TextStyle(color: Color(0xFFD6AE55), fontWeight: FontWeight.w700, letterSpacing: 1)),
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
                    Text(String.fromCharCode(65+i), style: const TextStyle(color: Color(0xFFE8C878), fontWeight: FontWeight.bold)),
                    const SizedBox(width: 12),
                    Expanded(child: Text(hidden.contains(i) ? ' ' : q.options[i], style: const TextStyle(fontSize: 16))),
                  ]),
                ),
              ),
            )),
            const Spacer(),
            if (notice != null) Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFF183D32), borderRadius: BorderRadius.circular(12)),
              child: Text(notice!, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFFE8C878))),
            ),
            const SizedBox(height: 8),
            const Text('Bilgi yarışmasıdır; gerçek para ödülü verilmez.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 11)),
          ]),
        )),
        Container(width: 1, color: const Color(0xFF315448)),
        Expanded(flex: 3, child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 18, 10, 18),
          child: Column(children: [
            const Text('JOKERLER', style: TextStyle(color: Color(0xFFD6AE55), fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 12),
            _joker('50:50', fiftyUsed, useFifty),
            _joker('Seyirci', audienceUsed, useAudience),
            _joker('Bilge', expertUsed, useExpert),
            const Divider(height: 24, color: Color(0xFF527B6B)),
            const Text('ÖDÜL MERDİVENİ', style: TextStyle(color: Color(0xFFD6AE55), fontSize: 10, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(child: ListView.builder(
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
                  child: Text('${actual+1}.  ${prizeLadder[actual]}', textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 11, fontWeight: active ? FontWeight.bold : FontWeight.normal,
                      color: active ? const Color(0xFF071B18) : safe ? const Color(0xFFE8C878) : Colors.white70)),
                );
              },
            )),
          ]),
        )),
      ])),
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

  Widget _result() => Center(child: Padding(
    padding: const EdgeInsets.all(28),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.emoji_events, size: 76, color: Color(0xFFE8C878)),
      const SizedBox(height: 18),
      Text(index == 14 && notice?.startsWith('Tebrikler') == true ? 'MÜKEMMEL!' : 'YARIŞMA TAMAMLANDI',
        textAlign: TextAlign.center, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xFFE8C878))),
      const SizedBox(height: 12),
      Text(notice ?? 'Yarışma sona erdi.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 17)),
      const SizedBox(height: 10),
      Text('Güvenli seviyen: $guaranteed', style: const TextStyle(color: Colors.white70)),
      const SizedBox(height: 24),
      FilledButton.icon(onPressed: restart, icon: const Icon(Icons.replay), label: const Text('YENİDEN OYNA')),
    ]),
  ));
}
