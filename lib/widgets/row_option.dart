import 'package:flutter/material.dart';

class RowOption extends StatelessWidget {
  final IconData icon;
  final String text;

  const RowOption({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ));
  }
}
