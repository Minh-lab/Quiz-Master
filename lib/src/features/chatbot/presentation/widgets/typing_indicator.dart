import 'package:flutter/material.dart';

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomLeft: const Radius.circular(0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'AI đang suy nghĩ...',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
