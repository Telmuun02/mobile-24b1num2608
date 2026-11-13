// Даалгавар 5 — Asynchronous програмчлал: Future, async/await, алдаа барих.
// Одоогоор сүлжээг дуурайлгаж байна; 4-р долоо хоногт жинхэнэ HTTP хүсэлтээр
// (https://dummyjson.com/products) солино.

import 'dart:convert';

import 'order_status.dart';
import 'product.dart';

/// dummyjson.com-ийн бүтэцтэй жишээ өгөгдөл.
const sampleProductsJson = '''
[
  {"id": 1, "title": "Wireless Headphones", "description": "Bluetooth 5.3, 30 цагийн батарей",
   "price": 59.99, "discountPercentage": 10, "rating": 4.5, "stock": 12,
   "category": "electronics", "thumbnail": ""},
  {"id": 2, "title": "Smart Watch", "description": "Зүрхний цохилт, алхам тоолуур",
   "price": 120, "discountPercentage": 15.5, "rating": 4.2, "stock": 0,
   "category": "electronics", "thumbnail": ""},
  {"id": 3, "title": "Leather Backpack", "description": "Арьсан үүргэвч",
   "price": 45.5, "rating": 4.8, "stock": 7, "category": "fashion"},
  {"id": 4, "title": "Running Shoes", "price": 89.9, "discountPercentage": 20,
   "rating": 4.6, "stock": 3, "category": "sports"},
  {"id": 5, "title": "Desk Lamp", "description": "LED ширээний гэрэл",
   "price": 25, "rating": 3.9, "stock": 20, "category": "home"}
]
''';

class ProductService {
  final Duration delay;
  final bool shouldFail;

  ProductService({
    this.delay = const Duration(milliseconds: 300),
    this.shouldFail = false,
  });

  /// 5.1 [delay] хугацаа хүлээгээд (Future.delayed), [sampleProductsJson]-ийг
  /// jsonDecode-оор задлан Product жагсаалт буцаана.
  /// [shouldFail] true бол `Exception('Сүлжээний алдаа')` шиднэ.
  Future<List<Product>> fetchProducts() async {
    await Future.delayed(delay);
    if (shouldFail) {
      throw Exception('Сүлжээний алдаа');
    }
    final data = jsonDecode(sampleProductsJson) as List<dynamic>;
    final products = <Product>[];
    for (final item in data) {
      products.add(Product.fromJson(item as Map<String, dynamic>));
    }
    return products;
  }

  /// 5.2 Гарчигт [query] агуулсан барааг хайна (том, жижиг үсэг ялгахгүй).
  /// Хоосон query бол бүх барааг буцаана. fetchProducts()-ийг await хий.
  Future<List<Product>> searchProducts(String query) async {
    final products = await fetchProducts();
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      return products;
    }
    final result = <Product>[];
    for (final product in products) {
      if (product.title.toLowerCase().contains(q)) {
        result.add(product);
      }
    }
    return result;
  }
}

/// 5.3 Бараа ачаалж, UI-д харуулах мессеж буцаана:
/// - амжилттай: 'Ачааллаа: 5 бараа'
/// - алдаа гарвал: 'Алдаа: Exception: Сүлжээний алдаа'
/// try / catch ашигла.
Future<String> loadProductsMessage(ProductService service) async {
  try {
    final products = await service.fetchProducts();
    return 'Ачааллаа: ${products.length} бараа';
  } catch (e) {
    return 'Алдаа: $e';
  }
}

/// БОНУС B1 — Захиалгын явцыг Stream-ээр дамжуулна.
/// [from] төлөвөөс эхэлж, [step] хугацаа тутам дараагийн төлөвийг (next)
/// yield хийж, null болоход зогсоно. async* ба yield ашигла.
///
///   trackOrder(OrderStatus.paid) → paid, shipped, delivered
Stream<OrderStatus> trackOrder(
  OrderStatus from, {
  Duration step = const Duration(milliseconds: 200),
}) async* {
  OrderStatus? current = from;
  while (current != null) {
    yield current;
    final next = current.next;
    if (next != null) {
      await Future.delayed(step);
    }
    current = next;
  }
}
