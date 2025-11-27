import 'package:flutter/material.dart';

class StepTile extends StatelessWidget {
  final String text;

  const StepTile({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.check_circle_outline),
      title: Text(text),
    );
  }
}
