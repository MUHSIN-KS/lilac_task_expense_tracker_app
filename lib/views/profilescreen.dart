import 'package:flutter/material.dart';
import 'package:lilac_company_task/controller/craditcontroller.dart';
import 'package:lilac_company_task/controller/profilecontroller.dart';
import 'package:lilac_company_task/controller/transactioncontroller.dart';
import 'package:lilac_company_task/utils/apptheme.dart';
import 'package:lilac_company_task/widgets/appheaders.dart';
import 'package:lilac_company_task/widgets/conformdialog.dart';
import 'package:provider/provider.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _editName(BuildContext context, String current) async {
    final c = TextEditingController(text: current);
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit name'),
        content: TextField(
            controller: c,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Your name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, c.text), child: const Text('Save')),
        ],
      ),
    );
    if (name == null || name.trim().isEmpty || !context.mounted) return;
    await context.read<ProfileController>().updateName(name);
  }

  Future<void> _clear(BuildContext context) async {
    final ok = await confirmDialog(
      context,
      title: 'Clear storage?',
      message: 'This permanently deletes all transactions and saved lists.',
      confirmText: 'Clear',
    );
    if (!ok || !context.mounted) return;
    final done = await context.read<ProfileController>().clearStorage();
    if (!context.mounted) return;
    await context.read<TransactionController>().load();
    if (!context.mounted) return;
    await context.read<CreditController>().load();
    if (context.mounted) {
      showMessage(context, done ? 'Storage cleared' : 'Could not clear storage');
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = context.watch<ProfileController>().name;

    return Column(
      children: [
        const AppHeader(title: 'Profile'),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const CircleAvatar(
                      radius: 42,
                      backgroundColor: Color(0xFFBDBDBD),
                      child: Icon(Icons.person, size: 64, color: Colors.white),
                    ),
                    Positioned(
                      right: -4,
                      bottom: -4,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.photo_camera, size: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(name,
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: () => _editName(context, name),
                      child: const Icon(Icons.edit, size: 15, color: AppColors.label),
                    ),
                  ],
                ),
                 SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => _clear(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.label,
                    shape:  StadiumBorder(),
                  ),
                  child:  Text('Clear Storage', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}