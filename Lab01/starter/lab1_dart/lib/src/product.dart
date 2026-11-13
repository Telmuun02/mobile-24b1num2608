// Даалгавар 2 — Product модель. Энэ классыг ShopLite апп-д 4-р долоо
// хоногт dummyjson.com API-гаас ирсэн JSON-ийг хөрвүүлэхэд дахин ашиглана.

/// Үнийг `$12.50` хэлбэрээр форматлана.
extension PriceFormat on double {
  String get asPrice {
    return '\$${toStringAsFixed(2)}';
  }
}

class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String category;
  final String thumbnail;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    this.description = '',
    this.discountPercentage = 0,
    this.rating = 0,
    this.stock = 0,
    this.category = '',
    this.thumbnail = '',
  });

  /// 2.1 JSON Map-аас Product үүсгэнэ.
  ///
  /// - id, title, price заавал байна.
  /// - Тоон утга JSON-д int (25) эсвэл double (25.5) байж болно →
  ///   `(json['price'] as num).toDouble()`.
  /// - Бусад талбар байхгүй (null) бол constructor-ийн анхдагч утгыг ав.
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String? ?? '',
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      stock: json['stock'] as int? ?? 0,
      category: json['category'] as String? ?? '',
      thumbnail: json['thumbnail'] as String? ?? '',
    );
  }

  /// 2.2 Product-ийг JSON Map болгоно (fromJson-ийн эсрэг үйлдэл).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'category': category,
      'thumbnail': thumbnail,
    };
  }

  /// 2.3 Хөнгөлөлт хассан үнэ, 2 оронтой бутархай хүртэл тоймлосон.
  /// Жишээ: price 100, discountPercentage 12.5 → 87.5
  double get discountedPrice {
    final value = price * (1 - discountPercentage / 100);
    return (value * 100).round() / 100;
  }

  /// 2.4 Нөөцөд байгаа эсэх.
  bool get inStock {
    return stock > 0;
  }

  /// 2.5 Зарим талбарыг өөрчилсөн ШИНЭ хуулбар буцаана (immutable загвар).
  Product copyWith({double? price, int? stock}) {
    return Product(
      id: id,
      title: title,
      description: description,
      price: price ?? this.price,
      discountPercentage: discountPercentage,
      rating: rating,
      stock: stock ?? this.stock,
      category: category,
      thumbnail: thumbnail,
    );
  }

  // Хоёр Product-ийн id ижил бол тэнцүү гэж үзнэ.
  @override
  bool operator ==(Object other) {
    return other is Product && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }

  @override
  String toString() {
    return 'Product(#$id $title, \$$price)';
  }
}
