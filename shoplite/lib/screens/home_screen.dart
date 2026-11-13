import 'package:flutter/material.dart';

import '../data/sample_products.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

/// Нүүр: баннер ба өндөр үнэлгээтэй барааны хэвтээ жагсаалт.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.products = sampleProducts});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final top = ([...products]..sort((a, b) => b.rating.compareTo(a.rating))).take(6).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('ShopLite')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              
              gradient: LinearGradient(
                colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
              ),
            
            ),
            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Улирлын хямдрал',
                  style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.onPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  'Сонгосон бараа 15% хүртэл хямдарлаа',
                  style: TextStyle(color: theme.colorScheme.onPrimary),
                ),
              ],
            ),
          
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text('Онцлох бараа', style: theme.textTheme.titleMedium),
          ),

          SizedBox(
            height: 250,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: top.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, i) => SizedBox(
                width: 160,
                child: ProductCard(product: top[i]),  
              ),
            ),
          ),
        ],
      ),
    );
  }
}
