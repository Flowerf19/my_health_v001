import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final Widget? leading;
  final Color? backgroundColor;
  final double elevation;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.centerTitle = true,
    this.leading,
    this.backgroundColor,
    this.elevation = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: AppTextStyles.heading2),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.background,
      elevation: elevation,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      actions: actions,
      leading: leading,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
