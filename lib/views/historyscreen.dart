import 'package:flutter/material.dart';
import 'package:lilac_company_task/controller/transactioncontroller.dart';
import 'package:lilac_company_task/utils/apptheme.dart';
import 'package:lilac_company_task/utils/formatters.dart';
import 'package:lilac_company_task/views/transactionfromscreen.dart';
import 'package:lilac_company_task/widgets/appheaders.dart';
import 'package:lilac_company_task/widgets/conformdialog.dart';
import 'package:lilac_company_task/widgets/emptystate.dart';
import 'package:lilac_company_task/widgets/transactiontile.dart';
import 'package:provider/provider.dart';


class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tx = context.watch<TransactionController>();

    return Column(
      children: [
        const AppHeader(title: 'Transaction History'),
        Container(
          width: double.infinity,
          color: const Color(0xFFF1F7F6),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text('Total Expense',
                  style: TextStyle(fontSize: 13, color: AppColors.label)),
              Text(money(tx.totalExpense),
                  style:  TextStyle(
                      fontWeight: FontWeight.w700, color: AppColors.expense)),
            ],
          ),
        ),
        Expanded(
          child: tx.isLoading
              ? const Center(child: CircularProgressIndicator())
              : tx.isEmpty
                  ? const EmptyState(message: 'No transactions found.\nTap + to add one.')
                  : ListView.separated(
                      padding: const EdgeInsets.only(top: 8, bottom: 100),
                      itemCount: tx.items.length,
                      separatorBuilder: (_, __) => const Divider(height: 1, indent: 20),
                      itemBuilder: (context, i) {
                        final t = tx.items[i];
                        return TransactionTile(
                          key: ValueKey(t.id),
                          transaction: t,
                          actions: true,
                          onEdit: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => TransactionFormScreen(existing: t)),
                          ),
                          onDelete: () async {
                            final ok = await confirmDialog(
                              context,
                              title: 'Delete transaction?',
                              message:
                                  'Are you sure you want to delete "${t.title}"? This cannot be undone.',
                            );
                            if (!ok || !context.mounted) return;
                            final ctrl = context.read<TransactionController>();
                            final done = await ctrl.delete(t.id);
                            if (context.mounted) {
                              showMessage(context,
                                  done ? 'Transaction deleted' : (ctrl.error ?? 'Failed'));
                            }
                          },
                        );
                      },
                    ),
        ),
      ],
    );
  }
}