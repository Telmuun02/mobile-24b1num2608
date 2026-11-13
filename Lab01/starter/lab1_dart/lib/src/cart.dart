// Даалгавар 3 — Сагс. 3-р долоо хоногт энэ логикийг Provider-тай холбоно.

import 'product.dart';

/// Нөөцөөс их тоогоор сагслах үед шидэгдэх алдаа.
class OutOfStockException implements Exception {
  final Product product;
  final int requested;

  OutOfStockException(this.product, this.requested);

  @override
  String toString() {
    return '${product.title}: $requested ширхэг хүссэн, нөөцөд ${product.stock} байна';
  }
}

class CartItem {
  final Product product;
  final int quantity;

  const CartItem(this.product, this.quantity);

  /// 3.1 Мөрийн дүн = хөнгөлөлттэй үнэ × тоо ширхэг.
  double get subtotal {
    final price = product.discountedPrice;
    return price * quantity;
  }
}

class Cart {
  // productId → CartItem. Нэг бараа сагсанд нэг л мөр байна.
  final Map<int, CartItem> _items = {};

  /// Гаднаас өөрчлөх боломжгүй жагсаалт.
  List<CartItem> get items {
    return List.unmodifiable(_items.values);
  }

  bool get isEmpty {
    return _items.isEmpty;
  }

  /// 3.2 Сагсанд байгаа нийт ширхэг.
  int get totalQuantity {
    return _items.values.fold(0, (sum, item) {
      return sum + item.quantity;
    });
  }

  /// 3.3 Нийт дүн, 2 оронтой бутархай хүртэл тоймлосон.
  double get totalPrice {
    final total = _items.values.fold<double>(0.0, (sum, item) {
      return sum + item.subtotal;
    });
    return (total * 100).round() / 100;
  }

  /// 3.4 Бараа нэмэх.
  /// - [quantity] <= 0 бол [ArgumentError].
  /// - Бараа сагсанд аль хэдийн байвал тоог нэмнэ.
  /// - Нийт тоо нөөцөөс (product.stock) хэтэрвэл [OutOfStockException]
  ///   шидэж, сагсыг өөрчлөхгүй.
  void add(Product product, {int quantity = 1}) {
    if (quantity <= 0) {
      throw ArgumentError.value(quantity, 'quantity', 'эерэг тоо байх ёстой');
    }
    final current = _items[product.id]?.quantity ?? 0;
    final newQuantity = current + quantity;
    if (newQuantity > product.stock) {
      throw OutOfStockException(product, newQuantity);
    }
    _items[product.id] = CartItem(product, newQuantity);
  }

  /// 3.5 Тоог 1-ээр хасна; 0 болвол мөрийг устгана.
  /// Сагсанд байхгүй бараа бол юу ч хийхгүй.
  void decrease(int productId) {
    final item = _items[productId];
    if (item == null) {
      return;
    }
    if (item.quantity <= 1) {
      _items.remove(productId);
    } else {
      _items[productId] = CartItem(item.product, item.quantity - 1);
    }
  }

  void remove(int productId) {
    _items.remove(productId);
  }

  void clear() {
    _items.clear();
  }
}
