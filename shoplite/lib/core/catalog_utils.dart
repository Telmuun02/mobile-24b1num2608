// Каталогт ашиглах цэвэр (pure) функцүүд — виджетгүйгээр тестлэхэд хялбар.
// Даалгавар B1–B3. Тест: flutter test test/lab2_test.dart --plain-name "2. Туслах функц"

import '../models/product.dart';

/// B1. Дэлгэцийн өргөнөөс хамаарч grid-ийн баганын тоог буцаана.
/// < 600 → 2, 600–899 → 3, ≥ 900 → 4.
int gridColumnCount(double width) {
  if (width >= 900) return 4;
  if (width >= 600) return 3;
  return 2;
}

/// B2. Барааны ангиллуудыг давхардалгүй, цагаан толгойн дарааллаар буцаана.
/// Хоосон ('') ангиллыг оруулахгүй.
List<String> categoriesOf(Iterable<Product> products) {
  return {
    for (final p in products)
      if (p.category.isNotEmpty) p.category,
  }.toList()..sort();
}

/// B3. Ангилал болон хайлтын үгээр шүүнэ.
/// - [category] null бол бүх ангилал.
/// - [query]-г гарчигт том, жижиг үсэг ялгахгүйгээр хайна (эхлэл, төгсгөлийн
///   зайг тооцохгүй — trim()); хоосон бол шүүхгүй.
List<Product> filterProducts(
  Iterable<Product> products, {
  String? category,
  String query = '',
}) {
  final q = query.trim().toLowerCase();
  return products
      .where((p) => category == null || p.category == category)
      .where((p) => q.isEmpty || p.title.toLowerCase().contains(q))
      .toList();
}
