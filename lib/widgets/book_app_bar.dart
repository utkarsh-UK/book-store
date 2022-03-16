import 'package:flutter/material.dart';

import '../util/theme.dart';

class BookAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const BookAppBar({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AppBar(
      title: Text(title, style: textTheme.headline2),
      titleTextStyle: textTheme.headline2,
      backgroundColor: AppTheme.backgroundColor,
      elevation: 0,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
