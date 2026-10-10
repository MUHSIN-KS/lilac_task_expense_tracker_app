import 'package:flutter/material.dart';
import 'package:lilac_company_task/utils/apptheme.dart';


class LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  const LabeledField({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(),
              style: const TextStyle(fontSize: 11, letterSpacing: 0.8, color: AppColors.label)),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

InputDecoration fieldDecoration({String? hint, Widget? suffix}) {
  OutlineInputBorder b(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: c),
      );
  return InputDecoration(
    hintText: hint,
    suffixIcon: suffix,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: b(AppColors.border),
    enabledBorder: b(AppColors.border),
    focusedBorder: b(AppColors.primary),
    errorBorder: b(AppColors.expense),
    focusedErrorBorder: b(AppColors.expense),
  );
}