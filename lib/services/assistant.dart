import '../data/content.dart';

class AssistantAnswer {
  final Category category;
  final bool immediateDanger;
  final bool matched;
  AssistantAnswer(this.category, this.immediateDanger, this.matched);
}

String normalizeText(String s) {
  var t = s.toLowerCase();
  t = t.replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '');
  t = t.replaceAll(RegExp(r'[أإآ]'), 'ا').replaceAll('ى', 'ي').replaceAll('ة', 'ه').replaceAll('ؤ', 'و').replaceAll('ئ', 'ي');
  return t;
}

// Phrases that signal danger happening right now (Arabic incl. Egyptian, English).
const _immediate = <String>[
  'مش بيتنفس', 'مش بتتنفس', 'مش بتنفس', 'لا يتنفس', 'فاقد الوعي', 'مغمي عليه', 'اغمي عليه', 'نزيف شديد', 'نزيف مش بيقف',
  'الحريق', 'بيولع', 'بتولع', 'ولعت', 'حريق دلوقتي', 'بيضربني', 'بيتبعني', 'ماشي ورايا', 'معاه سلاح', 'خطف', 'غرق', 'بيغرق',
  'الم صدر', 'جلطه', 'سكته', 'حادثه دلوقتي', 'انقلبت', 'اختناق', 'بيختنق', 'انا في خطر', 'في خطر', 'الحقوني', 'النجده', 'ساعدوني',
  'not breathing', 'unconscious', "can't breathe", 'cannot breathe', 'heavy bleeding', 'bleeding badly', 'on fire', 'chest pain',
  'being followed', 'following me', 'attacking', 'has a weapon', 'help me', 'drowning', 'choking', 'right now', 'in danger',
];

AssistantAnswer analyze(String input) {
  final q = normalizeText(input);
  if (q.trim().isEmpty) return AssistantAnswer(catById('other'), false, false);
  var best = catById('other');
  var bestScore = 0;
  for (final c in categories) {
    var s = 0;
    for (final k in c.keysAr) {
      if (q.contains(normalizeText(k))) s += 2;
    }
    for (final k in c.keysEn) {
      if (q.contains(k)) s += 2;
    }
    if (s > bestScore) {
      bestScore = s;
      best = c;
    }
  }
  final urgent = _immediate.any((p) => q.contains(normalizeText(p)));
  return AssistantAnswer(best, urgent, bestScore > 0);
}

const suggestionsAr = ['في حريق في المطبخ', 'حد مش بيتنفس', 'حصلت حادثة على الطريق', 'حاسس إن حد ماشي ورايا', 'ابني تايه في المول', 'ريحة غاز في البيت'];
const suggestionsEn = ['There is a fire in my kitchen', 'Someone is not breathing', 'I had a car accident', 'I feel someone is following me', 'My child is lost in the mall', 'I smell gas at home'];
