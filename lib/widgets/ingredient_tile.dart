import 'package:flutter/material.dart';

class IngredientTile extends StatelessWidget {
  final String text;
  final Color mint;

  const IngredientTile({super.key, required this.text, required this.mint});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(Icons.circle, size: 10, color: mint),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}
