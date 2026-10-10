import 'package:flutter/material.dart';
import 'package:lilac_company_task/utils/apptheme.dart';


class AppHeader extends StatelessWidget {
  final String title;
  final bool showBack;
  const AppHeader({super.key, required this.title, this.showBack = false});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.only(top: top),
      height: 64 + top,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (showBack)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
          Text(title,
              style: const TextStyle(
                  color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}