import 'package:flutter/material.dart';

/// B4. Үнэлгээг 5 одоор харуулна: бүтэн ★ (Icons.star), хагас (Icons.star_half),
/// хоосон ☆ (Icons.star_border). Жишээ: 3.5 → ★★★⯪☆, 4.2 → ★★★★☆.
/// Одны ард үнэлгээг нэг оронтой бутархайгаар (4.2) labelSmall загвараар бичнэ.
class RatingStars extends StatelessWidget {
  const RatingStars({super.key, required this.rating, this.size = 16});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = Colors.amber.shade700;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++)
          Icon(
            rating >= i
                ? Icons.star
                : rating >= i - 0.5
                ? Icons.star_half
                : Icons.star_border,
            size: size,
            color: color,
          ),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}
