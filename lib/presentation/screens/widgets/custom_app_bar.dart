import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;
  final VoidCallback? onLogout;
  final bool? showArrow;

  const CustomAppBar({
    super.key,
    required this.title,
    this.backgroundColor = const Color.fromARGB(255, 164, 221, 248),
    this.foregroundColor = const Color(0xFF37474F),
    this.elevation = 0.0,
    this.onLogout,
    this.showArrow,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      leading: context.canPop() && showArrow == true
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: foregroundColor),
              onPressed: () => context.pop(),
            )
          : null,
      automaticallyImplyLeading: showArrow ?? true,
      actions: onLogout != null
          ? [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: onLogout,
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
