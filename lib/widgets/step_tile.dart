import 'package:flutter/material.dart';

class StepTile extends StatelessWidget {
  final int number;
  final String text;

  const StepTile({super.key, required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$number.",
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: const TextStyle(fontSize: 15, height: 1.35)),
          ),
        ],
      ),
    );
  }
}
