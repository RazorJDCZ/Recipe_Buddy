import 'package:flutter/material.dart';

class IngredientTile extends StatelessWidget {
  final String text;

  const IngredientTile({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: false,
      onChanged: (_) {},
      title: Text(text),
    );
  }
}
