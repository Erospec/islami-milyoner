class LocalizedQuestion {
  final String category;
  final String question;
  final List<String> options;
  final String explanation;
  const LocalizedQuestion(this.category, this.question, this.options, this.explanation);
}

const Map<String, LocalizedQuestion> englishQuestionTranslations = {
'q01': LocalizedQuestion('Qur’an', 'How many surahs are there in the Holy Qur’an?', ['110','112','114','116'], 'The Qur’an consists of 114 surahs.'),
'q02': LocalizedQuestion('Qur’an', 'Which is the first surah of the Holy Qur’an?', ['Al-Baqarah','Al-Fatihah','Al-Ikhlas','Al-Alaq'], 'Al-Fatihah is the first surah in the standard Qur’an order.'),
'q03': LocalizedQuestion('Qur’an', 'Which is the longest surah in the Holy Qur’an?', ['An-Nisa','Al Imran','Al-Baqarah','Al-Ma’idah'], 'Surah Al-Baqarah contains 286 verses.'),
'q04': LocalizedQuestion('Qur’an', 'Which is the shortest surah in the Holy Qur’an?', ['Al-Kawthar','Al-Asr','Al-Ikhlas','An-Nasr'], 'Surah Al-Kawthar consists of three verses.'),
'q05': LocalizedQuestion('Qur’an', 'In which language was the Qur’an revealed?', ['Hebrew','Arabic','Persian','Syriac'], 'The Qur’an describes itself as an Arabic revelation.'),
'q06': LocalizedQuestion('Qur’an', 'Which is the last surah in the standard Qur’an order?', ['Al-Falaq','Al-Ikhlas','An-Nas','Al-Fatihah'], 'An-Nas is the final surah in the standard order.'),
'q07': LocalizedQuestion('Qur’an', 'In which surah is Ayat al-Kursi found?', ['Al-Fatihah','Al-Baqarah','Ya-Sin','Ar-Rahman'], 'Ayat al-Kursi is verse 255 of Surah Al-Baqarah.'),
'q08': LocalizedQuestion('Qur’an', 'Which woman is mentioned by name in the Qur’an?', ['Asiya','Maryam (Mary)','Hawwa (Eve)','Hajar'], 'A surah is also named Maryam.'),
'q09': LocalizedQuestion('Qur’an', 'Which prophet is mentioned in the Qur’an and has a surah named after him?', ['Yusuf (Joseph)','Idris','Shu’ayb','Dhul-Kifl'], 'Surah Yusuf recounts his story.'),
'q10': LocalizedQuestion('Qur’an', 'How many verses are in Surah Al-Fatihah?', ['5','6','7','8'], 'Surah Al-Fatihah is commonly counted as having seven verses.'),
'q11': LocalizedQuestion('Qur’an', 'At the beginning of which surah does the command “Read” (Iqra) appear?', ['Al-Alaq','Al-Qalam','Al-Muddaththir','Al-Fatihah'], 'The opening verses of Al-Alaq begin with the command “Read”.'),
'q12': LocalizedQuestion('Qur’an', 'Which surah is named Al-Layl, meaning “The Night”?', ['Ad-Duha','Al-Layl','Al-Qadr','Al-Fajr'], 'Al-Layl is the 92nd surah.'),
'q13': LocalizedQuestion('Qur’an', 'Which surah does not begin with the Bismillah?', ['Al-Anfal','At-Tawbah','Yunus','Hud'], 'The written text of Surah At-Tawbah does not begin with the Bismillah.'),
'q14': LocalizedQuestion('Qur’an', 'Which surah is named after the honeybee?', ['An-Nahl','An-Naml','Al-Ankabut','Al-Baqarah'], 'An-Nahl means “The Bee”.'),
'q15': LocalizedQuestion('Qur’an', 'Which surah has a name meaning “The Human”?', ['An-Nas','Al-Insan','Al-Mu’minun','Al-Balad'], 'Surah Al-Insan is the 76th surah and is also known as Ad-Dahr.'),
'q16': LocalizedQuestion('Qur’an', 'Which surah is named after the ant mentioned in the Qur’an?', ['An-Nahl','An-Naml','Al-Fil','Quraysh'], 'An-Naml means “The Ant”.'),
'q17': LocalizedQuestion('Qur’an', 'What event is described in Surah Al-Fil?', ['The Battle of Badr','The attack on the Kaaba by the Army of the Elephant','The Hijrah','The Battle of the Trench'], 'The surah recalls the unsuccessful attack by the Army of the Elephant.'),
'q18': LocalizedQuestion('Qur’an', 'Which surah is named after Luqman?', ['Luqman','Al-Kahf','Maryam','Ta-Ha'], 'Surah Luqman is the 31st surah.'),
'q19': LocalizedQuestion('Qur’an', 'In which surah is Laylat al-Qadr (the Night of Decree) described?', ['Al-Qadr','Al-Kafirun','Quraysh','Al-Asr'], 'Surah Al-Qadr discusses this blessed night.'),
'q20': LocalizedQuestion('Qur’an', 'Which surah is named Ar-Rum, referring to the Romans?', ['Ar-Rum','Saba','Fatir','Ash-Shura'], 'Ar-Rum is the 30th surah.'),
'q21': LocalizedQuestion('Qur’an', 'Which brother of Prophet Musa is frequently mentioned alongside him in the Qur’an?', ['Isma’il','Harun (Aaron)','Yusuf','Ilyas'], 'Harun is mentioned as Musa’s brother and helper.'),
'q22': LocalizedQuestion('Qur’an', 'In which surah is the story of Dhul-Qarnayn found?', ['Al-Kahf','Ya-Sin','Al-Mulk','Al-Waqi’ah'], 'The account of Dhul-Qarnayn appears in Surah Al-Kahf.'),
'q23': LocalizedQuestion('Qur’an', 'In which surah is the story of the People of the Cave (Ashab al-Kahf) told?', ['Al-Kahf','Al-Anbiya','Sad','Al-Fath'], 'Their story is told in the relevant passage of Surah Al-Kahf.'),
'q24': LocalizedQuestion('Qur’an', 'In which surah is the account of Prophet Yunus being swallowed by a great fish explicitly mentioned?', ['As-Saffat','Al-Fil','Al-Qari’ah','At-Takathur'], 'The account of Yunus appears in Surah As-Saffat.'),
'q25': LocalizedQuestion('Qur’an', 'In the Qur’anic account of the meeting of the two seas, with whom does Prophet Musa travel?', ['A servant of God traditionally identified as Al-Khidr','Prophet Ibrahim','Prophet Dawud','Prophet Isa'], 'In Surah Al-Kahf, Musa meets a servant of God who has been granted special knowledge.'),
};
