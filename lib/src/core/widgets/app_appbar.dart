import 'package:flutter/material.dart';

class AppAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final Widget? actions;

  const AppAppbar({super.key, required this.title, this.leading, this.actions});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(title),
      ),
      leading: leading,
      actions: [actions ?? Container()],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
