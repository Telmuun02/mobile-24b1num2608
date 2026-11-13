import 'package:flutter/material.dart';

import '../models/product.dart';

/// B5. Хөнгөлөлттэй үнэ; хөнгөлөлт байвал хуучин үнийг зураастай харуулна.
///
///   $54.00  $60.00      ← эхнийх: titleMedium, bold, colorScheme.primary
///           ‾‾‾‾‾‾      ← хоёрдахь: bodySmall, TextDecoration.lineThrough,
///                          colorScheme.outline
///
/// Хөнгөлөлтгүй (discountPercentage == 0) бол ЗӨВХӨН нэг Text.
/// Үнийг Лаб 1-ийн extension-оор форматлана: product.discountedPrice.asPrice
class PriceTag extends StatelessWidget {
  const PriceTag({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Wrap(
      spacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          product.discountedPrice.asPrice,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.primary,
          ),
        ),
        if (product.discountPercentage > 0)
          Text(
            product.price.asPrice,
            style: theme.textTheme.bodySmall?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: colors.outline,
            ),
          ),
      ],
    );
  }
}
