import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  
  const CustomAppBar({
    super.key,
    required this.title,
  });

  static const Color _accentColor = Color(0xFF64FFDA);
  static const Color _surfaceColor = Color(0xFF112240);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: _surfaceColor,
      leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: _accentColor),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          color: _accentColor,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          letterSpacing: 1.0,
        ),
      ),
      centerTitle: false,
      elevation: 0,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Image.asset(
            'assets/images/app_icon_blank.png',
            height: 36,
            width: 36,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 