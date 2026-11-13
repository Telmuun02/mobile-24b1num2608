// Лаборатори 2 — автомат тест (25). Ажиллуулах: flutter test test/lab2_test.dart
// Тестийг ӨӨРЧЛӨХГҮЙ байна уу.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shoplite/app.dart';
import 'package:shoplite/core/catalog_utils.dart';
import 'package:shoplite/data/sample_products.dart';
import 'package:shoplite/models/product.dart';
import 'package:shoplite/screens/catalog_screen.dart';
import 'package:shoplite/screens/profile_screen.dart';
import 'package:shoplite/widgets/price_tag.dart';
import 'package:shoplite/widgets/product_card.dart';
import 'package:shoplite/widgets/rating_stars.dart';

// Тестэд сүлжээний зураг ашиглахгүй (thumbnail хоосон).
const phone = Product(
    id: 1, title: 'Phone', price: 100, discountPercentage: 10, rating: 3.5, stock: 5, category: 'smartphones');
const laptop = Product(id: 2, title: 'Laptop Pro', price: 900, rating: 4.8, stock: 3, category: 'laptops');
const perfume = Product(id: 3, title: 'Perfume', price: 40, rating: 4, stock: 0, category: 'fragrances');
const tablet = Product(
    id: 4, title: 'Phone Tablet', price: 300, discountPercentage: 25, rating: 2.2, stock: 9, category: 'smartphones');
const products = [phone, laptop, perfume, tablet];

Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

Widget cardBox(Product p, {VoidCallback? onTap}) =>
    wrap(Center(child: SizedBox(width: 200, height: 300, child: ProductCard(product: p, onTap: onTap))));

void main() {
  group('1. Модель ба өгөгдөл', () {
    test('1.1 Лаб 1-ийн Product lib/models/-д ажиллана', () {
      final p = Product.fromJson({'id': 9, 'title': 'Bag', 'price': 50, 'discountPercentage': 20, 'stock': 2});
      expect(p.discountedPrice, 40.0);
      expect(p.inStock, isTrue);
      expect(50.0.asPrice, '\$50.00');
    });

    test('1.2 sampleProducts ≥ 8 бараа, id давхардахгүй', () {
      expect(sampleProducts.length, greaterThanOrEqualTo(8));
      expect(sampleProducts.map((p) => p.id).toSet().length, sampleProducts.length);
    });

    test('1.3 sampleProducts ≥ 3 ангилал, хөнгөлөлтгүй болон дууссан бараа агуулна', () {
      expect(sampleProducts.map((p) => p.category).toSet().length, greaterThanOrEqualTo(3));
      expect(sampleProducts.any((p) => p.discountPercentage == 0), isTrue);
      expect(sampleProducts.any((p) => !p.inStock), isTrue);
    });
  });

  group('2. Туслах функц', () {
    test('2.1 gridColumnCount', () {
      expect(gridColumnCount(360), 2);
      expect(gridColumnCount(599), 2);
      expect(gridColumnCount(600), 3);
      expect(gridColumnCount(899), 3);
      expect(gridColumnCount(900), 4);
      expect(gridColumnCount(1400), 4);
    });

    test('2.2 categoriesOf — давхардалгүй, эрэмбэлсэн', () {
      expect(categoriesOf(products), ['fragrances', 'laptops', 'smartphones']);
      expect(categoriesOf([]), isEmpty);
    });

    test('2.3 filterProducts — ангиллаар', () {
      expect(filterProducts(products, category: 'smartphones'), [phone, tablet]);
      expect(filterProducts(products), products);
      expect(filterProducts(products, category: 'shoes'), isEmpty);
    });

    test('2.4 filterProducts — хайлт (том/жижиг үсэг, зай)', () {
      expect(filterProducts(products, query: 'phone'), [phone, tablet]);
      expect(filterProducts(products, query: '  LAPTOP '), [laptop]);
      expect(filterProducts(products, category: 'smartphones', query: 'tab'), [tablet]);
      expect(filterProducts(products, query: ''), products);
    });
  });

  group('3. RatingStars, PriceTag', () {
    testWidgets('3.1 RatingStars 3.5 → 3 бүтэн, 1 хагас, 1 хоосон', (tester) async {
      await tester.pumpWidget(wrap(const RatingStars(rating: 3.5)));
      expect(find.byIcon(Icons.star), findsNWidgets(3));
      expect(find.byIcon(Icons.star_half), findsOneWidget);
      expect(find.byIcon(Icons.star_border), findsOneWidget);
    });

    testWidgets('3.2 RatingStars 0 ба 5', (tester) async {
      await tester.pumpWidget(wrap(const Column(children: [RatingStars(rating: 0), RatingStars(rating: 5)])));
      expect(find.byIcon(Icons.star_border), findsNWidgets(5));
      expect(find.byIcon(Icons.star), findsNWidgets(5));
      expect(find.byIcon(Icons.star_half), findsNothing);
    });

    testWidgets('3.3 PriceTag — хөнгөлөлттэй үед хоёр үнэ, хуучин нь зураастай', (tester) async {
      await tester.pumpWidget(wrap(const PriceTag(product: phone)));
      expect(find.text('\$90.00'), findsOneWidget);
      final old = tester.widget<Text>(find.text('\$100.00'));
      expect(old.style?.decoration, TextDecoration.lineThrough);
    });

    testWidgets('3.4 PriceTag — хөнгөлөлтгүй үед нэг үнэ', (tester) async {
      await tester.pumpWidget(wrap(const PriceTag(product: laptop)));
      expect(find.text('\$900.00'), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });
  });

  group('4. ProductCard', () {
    testWidgets('4.1 нэр, үнэ, од харуулна', (tester) async {
      await tester.pumpWidget(cardBox(laptop));
      expect(find.text('Laptop Pro'), findsOneWidget);
      expect(find.text('\$900.00'), findsOneWidget);
      expect(find.byType(RatingStars), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('4.2 хөнгөлөлтийн шошго (-10%)', (tester) async {
      await tester.pumpWidget(cardBox(phone));
      expect(find.text('-10%'), findsOneWidget);
      await tester.pumpWidget(cardBox(laptop));
      expect(find.textContaining('%'), findsNothing);
    });

    testWidgets('4.3 нөөц дууссан бол "Дууссан"', (tester) async {
      await tester.pumpWidget(cardBox(perfume));
      expect(find.text('Дууссан'), findsOneWidget);
      await tester.pumpWidget(cardBox(laptop));
      expect(find.text('Дууссан'), findsNothing);
    });

    testWidgets('4.4 дарахад onTap дуудагдана', (tester) async {
      var taps = 0;
      await tester.pumpWidget(cardBox(phone, onTap: () => taps++));
      await tester.tap(find.byType(ProductCard));
      expect(taps, 1);
    });

    testWidgets('4.5 урт нэр 2 мөрөөс хэтрэхгүй (ellipsis)', (tester) async {
      const long = Product(id: 9, title: 'Very long product name that never fits in a small card', price: 1);
      await tester.pumpWidget(cardBox(long));
      final title = tester.widget<Text>(find.text(long.title));
      expect(title.maxLines, 2);
      expect(title.overflow, TextOverflow.ellipsis);
      expect(tester.takeException(), isNull);
    });
  });

  group('5. Каталог', () {
    Future<void> pumpCatalog(WidgetTester tester, {Size size = const Size(800, 1200)}) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const MaterialApp(home: CatalogScreen(products: products)));
    }

    testWidgets('5.1 бүх барааг GridView-д харуулна', (tester) async {
      await pumpCatalog(tester);
      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(ProductCard), findsNWidgets(4));
    });

    testWidgets('5.2 ангиллын ChoiceChip: "Бүгд" + ангилал бүр', (tester) async {
      await pumpCatalog(tester);
      expect(find.byType(ChoiceChip), findsNWidgets(4));
      await tester.tap(find.widgetWithText(ChoiceChip, 'smartphones'));
      await tester.pump();
      expect(find.byType(ProductCard), findsNWidgets(2));
      await tester.tap(find.widgetWithText(ChoiceChip, 'Бүгд'));
      await tester.pump();
      expect(find.byType(ProductCard), findsNWidgets(4));
    });

    testWidgets('5.3 хайлт гарчгаар шүүнэ', (tester) async {
      await pumpCatalog(tester);
      await tester.enterText(find.byType(TextField), 'lap');
      await tester.pump();
      expect(find.byType(ProductCard), findsOneWidget);
      expect(find.text('Laptop Pro'), findsOneWidget);
    });

    testWidgets('5.4 олдохгүй бол "Бараа олдсонгүй"', (tester) async {
      await pumpCatalog(tester);
      await tester.enterText(find.byType(TextField), 'zzz');
      await tester.pump();
      expect(find.byType(ProductCard), findsNothing);
      expect(find.text('Бараа олдсонгүй'), findsOneWidget);
    });

    testWidgets('5.5 responsive: өргөнөөс хамаарч 2 / 4 багана', (tester) async {
      int columns() {
        final grid = tester.widget<GridView>(find.byType(GridView));
        return (grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount).crossAxisCount;
      }

      await pumpCatalog(tester, size: const Size(400, 900));
      expect(columns(), 2);
      await pumpCatalog(tester, size: const Size(1000, 900));
      expect(columns(), 4);
    });
  });

  group('6. Навигаци ба theme', () {
    testWidgets('6.1 NavigationBar 4 цэстэй', (tester) async {
      await tester.pumpWidget(const ShopLiteApp());
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationDestination), findsNWidgets(4));
      for (final label in ['Нүүр', 'Каталог', 'Сагс', 'Профайл']) {
        expect(find.descendant(of: find.byType(NavigationBar), matching: find.text(label)), findsOneWidget);
      }
    });

    testWidgets('6.2 "Каталог" дарахад CatalogScreen харагдана', (tester) async {
      await tester.pumpWidget(const ShopLiteApp());
      await tester.tap(find.descendant(of: find.byType(NavigationBar), matching: find.text('Каталог')));
      await tester.pumpAndSettle();
      expect(find.byType(CatalogScreen), findsOneWidget);
      expect(find.byType(GridView).hitTestable(), findsOneWidget);
    });

    testWidgets('6.3 theme ба darkTheme хоёулаа Material 3', (tester) async {
      await tester.pumpWidget(const ShopLiteApp());
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.theme?.useMaterial3, isTrue);
      expect(app.darkTheme?.colorScheme.brightness, Brightness.dark);
      expect(app.debugShowCheckedModeBanner, isFalse);
    });

    testWidgets('6.4 Профайл → "Харанхуй горим" асаахад theme dark болно', (tester) async {
      await tester.pumpWidget(const ShopLiteApp());
      await tester.tap(find.descendant(of: find.byType(NavigationBar), matching: find.text('Профайл')));
      await tester.pumpAndSettle();
      expect(find.byType(ProfileScreen), findsOneWidget);
      await tester.tap(find.widgetWithText(SwitchListTile, 'Харанхуй горим'));
      await tester.pumpAndSettle();
      final ctx = tester.element(find.byType(ProfileScreen));
      expect(Theme.of(ctx).brightness, Brightness.dark);
    });
  });
}
