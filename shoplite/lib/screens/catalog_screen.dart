import 'package:flutter/material.dart';

import '../core/catalog_utils.dart';
import '../data/sample_products.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

/// Каталог: хайлт, ангиллын шүүлтүүр, responsive grid.
/// [products] — тестэд өөр жагсаалт өгөх боломжтой (анхдагч: sampleProducts).
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key, this.products = sampleProducts});

  final List<Product> products;

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String? _category; // null → бүх ангилал ("Бүгд")
  String _query = '';

  void _openProduct(Product product) {
    // 3-р лабд дэлгэрэнгүй дэлгэц рүү шилжинэ. Одоохондоо SnackBar.
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(product.title)));
  }

  @override
  Widget build(BuildContext context) {
    final visible = filterProducts(
      widget.products,
      category: _category,
      query: _query,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Каталог')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Бараа хайх',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),

          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                for (final c in [null, ...categoriesOf(widget.products)])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(c ?? 'Бүгд'),
                      selected: _category == c,
                      onSelected: (_) => setState(() => _category = c),
                    ),
                  ),
              ],
            ),
          ),

          Expanded(
            child: visible.isEmpty
                ? const Center(child: Text('Бараа олдсонгүй'))
                : LayoutBuilder(
                    builder: (context, constraints) => GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: gridColumnCount(constraints.maxWidth),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.62,
                      ),
                      itemCount: visible.length,
                      itemBuilder: (context, i) => ProductCard(
                        product: visible[i],
                        onTap: () => _openProduct(visible[i]),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
