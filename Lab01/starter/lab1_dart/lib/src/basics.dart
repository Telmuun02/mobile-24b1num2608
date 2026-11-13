// Даалгавар 1 — Dart хэлний үндэс: null safety, функц, collection, closure.

/// 1.1 Оюутны товч мэдээллийг буцаана.
///
/// Жишээ:
///   describeStudent('Бат')                              → 'Бат'
///   describeStudent('Бат', age: 21)                     → 'Бат (21)'
///   describeStudent('Бат', major: 'Програм хангамж')    → 'Бат — Програм хангамж'
///   describeStudent('Бат', age: 21, major: 'ПХ')        → 'Бат (21) — ПХ'
String describeStudent(String name, {int? age, String? major}) {
  if (age == null && major == null) {
    return name;
  } else if (age != null && major == null) {
    return '$name ($age)';
  } else if (age == null && major != null) {
    return '$name — $major';
  } else {
    return '$name ($age) — $major';
  }
}

/// 1.2 Онооноос үсгэн дүн гаргана (switch expression ашигла).
///
/// 90–100 → 'A', 80–89 → 'B', 70–79 → 'C', 60–69 → 'D', 0–59 → 'F'.
/// 0–100 хооронд биш бол [ArgumentError] шиднэ.
String letterGrade(int score) {
  if (score > 100 || score < 0) {
    throw ArgumentError('score must be between 0 and 100');
  } else if (score >= 90) {
    return 'A';
  } else if (score >= 80) {
    return 'B';
  } else if (score >= 70) {
    return 'C';
  } else if (score >= 60) {
    return 'D';
  } else {
    return 'F';
  }
}

/// 1.3 Онооны дундаж. Хоосон жагсаалт бол 0.0 буцаана (fold ашигла).
double average(List<int> scores) {
  if (scores.isEmpty) {
    return 0.0;
  }
  final total = scores.fold(0, (sum, score) {
    return sum + score;
  });
  return total / scores.length;
}

/// 1.4 [passMark]-аас дээш (тэнцүү орно) оноотой оюутнуудын нэрийг
/// цагаан толгойн дарааллаар буцаана (where, map, sort ашигла).
List<String> passedStudents(Map<String, int> scores, {int passMark = 60}) {
  final passed = scores.entries.where((p) {
    return p.value >= passMark;
  });
  final names = passed.map((p) {
    return p.key;
  }).toList();
  names.sort((a, b) {
    return a.compareTo(b);
  });
  return names;
}

/// 1.5 Дуудах бүрт дараагийн ID-г буцаадаг функц үүсгэнэ (closure).
///
///   final nextId = makeIdGenerator(start: 100);
///   nextId(); // 100
///   nextId(); // 101
int Function() makeIdGenerator({int start = 1}) {
  return () {
    final currentId = start;
    start++;
    return currentId;
  };
}
