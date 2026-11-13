import 'package:flutter/material.dart';

/// Сүлжээний зураг. URL хоосон эсвэл ачаалж чадаагүй бол placeholder харуулна.
class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.url, this.fit = BoxFit.cover});

  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final placeholder = ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Center(child: Icon(Icons.image_outlined, size: 40)),
    );
    if (url.isEmpty) return placeholder;
    return Image.network(
      url,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => placeholder,
    );
  }
}
