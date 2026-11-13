import 'package:flutter/material.dart';

/// Сагс — 3-р лабораторид Provider-оор бүрэн хэрэгжүүлнэ.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сагс')),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 64),
            SizedBox(height: 12),
            Text('Сагс хоосон байна'),
          ],
        ),
      ),
    );
  }
}
