import 'package:flutter/material.dart';

/// Профайл ба тохиргоо. Харанхуй горимын төлөв ShopLiteApp-д хадгалагдана
/// (lifting state up) — тиймээс утга болон callback-ийг параметрээр авна.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.darkMode,
    required this.onDarkModeChanged,
  });

  final bool darkMode;
  final ValueChanged<bool> onDarkModeChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профайл')),
      body: ListView(
        children: [
          const ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text('Зочин'),
            subtitle: Text('Нэвтрээгүй байна'),
          ),
          const Divider(),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Харанхуй горим'),
            value: darkMode,
            onChanged: onDarkModeChanged,
          ),
        ],
      ),
    );
  }
}
