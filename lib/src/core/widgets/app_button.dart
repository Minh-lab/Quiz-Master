import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppButton extends StatelessWidget {
  final String title;
  final Widget? leadingIcon;
  final VoidCallback onPressed;

  const AppButton({
    super.key,
    required this.title,
    this.leadingIcon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(5),
      child: ElevatedButton(
        onPressed: onPressed,
        child: (leadingIcon != null)
            ? (Center(child: Row(children: [leadingIcon!, Text(title)])))
            : Center(child: Text(title)),
      ),
    );
  }
}
