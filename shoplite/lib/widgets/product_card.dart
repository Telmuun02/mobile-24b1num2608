import 'package:flutter/material.dart';

import '../models/product.dart';
import 'price_tag.dart';
import 'product_image.dart';
import 'rating_stars.dart';

/// Каталогийн нэг барааны карт: зураг, хөнгөлөлтийн шошго, нэр, од, үнэ.
///
///   Card(clipBehavior: Clip.antiAlias)
///   └─ InkWell(onTap)
///      └─ Column(crossAxisAlignment: stretch)
///         ├─ Expanded → Stack
///         │    ├─ Positioned.fill → ProductImage(url: product.thumbnail)
///         │    ├─ [хөнгөлөлттэй бол] Positioned(top: 8, left: 8) → _Badge('-10%')
///         │    └─ [нөөц дууссан бол] Positioned.fill → ColoredBox(Colors.black45)
///         │                                           → Center → _Badge('Дууссан')
///         └─ Padding(all: 10) → Column(start, spacing: 4)
///              ├─ Text(title, maxLines: 2, ellipsis, titleSmall)
///              ├─ RatingStars(rating, size: 14)
///              └─ PriceTag(product)
///
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, this.onTap});

  final Product product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(child: ProductImage(url: product.thumbnail)),
                  if (product.discountPercentage > 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: _Badge(
                        label: '-${product.discountPercentage.round()}%',
                        color: colors.error,
                        textColor: colors.onError,
                      ),
                    ),
                  if (!product.inStock)
                    Positioned.fill(
                      child: ColoredBox(
                        color: Colors.black45,
                        child: Center(
                          child: _Badge(
                            label: 'Дууссан',
                            color: colors.surface,
                            textColor: colors.onSurface,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall,
                  ),
                  RatingStars(rating: product.rating, size: 14),
                  PriceTag(product: product),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Жижиг өнгөт шошго ("-13%", "Дууссан"). Бэлэн — C2, C3-т ашигла.
class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.color,
    required this.textColor,
  });

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall
              ?.copyWith(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
