import 'package:flutter/material.dart';

void main() {
  runApp(const ShopLiteApp());
}

class ShopLiteApp extends StatelessWidget {
  const ShopLiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopLite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const CartPage(title: 'ShopLite — Сагс'),
    );
  }
}

class CartPage extends StatefulWidget {
  const CartPage({super.key, required this.title});

  final String title;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  static const int maxCount = 10;

  int _count = 0;

  bool get _isAtMax => _count >= maxCount;

  void _increment() {
    setState(() {
      if (_count < maxCount) _count++;
    });
  }

  void _decrement() {
    setState(() {
      if (_count > 0) _count--;
    });
  }

  void _reset() {
    setState(() {
      _count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Тэглэх',
            onPressed: _reset,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Сагсанд байгаа бараа:'),
            Text(
              '$_count',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (_isAtMax)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Нэг удаад 10-аас олон бараа захиалах боломжгүй',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colorScheme.error),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'increment',
            onPressed: _isAtMax ? null : _increment,
            tooltip: 'Нэмэх',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'decrement',
            onPressed: _decrement,
            tooltip: 'Хасах',
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
