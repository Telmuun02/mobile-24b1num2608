import 'package:flutter/material.dart';

import 'cart_screen.dart';
import 'catalog_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

/// Доод NavigationBar бүхий үндсэн бүтэц. IndexedStack нь таб солиход
/// дэлгэц бүрийн төлөвийг (хайлтын текст, scroll) хадгална.
class HomeShell extends StatefulWidget {
  const HomeShell({
    super.key,
    required this.darkMode,
    required this.onDarkModeChanged,
  });

  final bool darkMode;
  final ValueChanged<bool> onDarkModeChanged;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

typedef _Tab = ({IconData icon, IconData selectedIcon, String label});

const List<_Tab> _tabs = [
  (icon: Icons.home_outlined, selectedIcon: Icons.home, label: 'Нүүр'),
  (
    icon: Icons.grid_view_outlined,
    selectedIcon: Icons.grid_view,
    label: 'Каталог',
  ),
  (
    icon: Icons.shopping_cart_outlined,
    selectedIcon: Icons.shopping_cart,
    label: 'Сагс',
  ),
  (icon: Icons.person_outline, selectedIcon: Icons.person, label: 'Профайл'),
];

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  final _bodyKey = GlobalKey();

  void _select(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final body = IndexedStack(
      key: _bodyKey,
      index: _index,

      children: [
        const HomeScreen(),

        const CatalogScreen(),

        const CartScreen(),

        ProfileScreen(
          darkMode: widget.darkMode,
          onDarkModeChanged: widget.onDarkModeChanged,
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _index,
                  onDestinationSelected: _select,
                  labelType: NavigationRailLabelType.all,

                  destinations: [
                    for (final t in _tabs)
                      NavigationRailDestination(
                        icon: Icon(t.icon),
                        selectedIcon: Icon(t.selectedIcon),
                        label: Text(t.label),
                      ),
                  ],
                ),

                const VerticalDivider(width: 1),

                Expanded(child: body),
              ],
            ),
          );
        }

        return Scaffold(
          body: body,

          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: _select,

            destinations: [
              for (final t in _tabs)
                NavigationDestination(
                  icon: Icon(t.icon),
                  selectedIcon: Icon(t.selectedIcon),
                  label: t.label,
                ),
            ],
          ),
        );
      },
    );
  }
}
