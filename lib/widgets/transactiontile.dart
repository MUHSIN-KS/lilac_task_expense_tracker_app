import 'package:flutter/material.dart';
import 'package:lilac_company_task/models/transactionmodel.dart';
import 'package:lilac_company_task/utils/apptheme.dart';
import 'package:lilac_company_task/utils/formatters.dart';


class TransactionTile extends StatefulWidget {
  final TransactionModel transaction;

  final bool actions;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.actions = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<TransactionTile> createState() => _TransactionTileState();
}

class _TransactionTileState extends State<TransactionTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.transaction;
    final color = t.isExpense ? AppColors.expense : AppColors.income;
    final sign = t.isExpense ? '-' : '+';

    return InkWell(
      onTap: widget.actions ? () => setState(() => _open = !_open) : null,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 3),
                  Text('${t.category} • ${listDate(t.date)}',
                      style: const TextStyle(fontSize: 11, color: AppColors.label)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: _open ? 8 : 20),
              child: Text('$sign ${money(t.amount)}',
                  style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 15)),
            ),
            if (widget.actions && _open) ...[
              _ActionBox(
                  icon: Icons.edit,
                  color: const Color(0xFFE9E9E9),
                  iconColor: Colors.black87,
                  onTap: widget.onEdit),
              _ActionBox(
                  icon: Icons.delete,
                  color: AppColors.expense,
                  iconColor: Colors.white,
                  onTap: widget.onDelete),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActionBox extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback? onTap;
  const _ActionBox(
      {required this.icon, required this.color, required this.iconColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        color: color,
        child: Icon(icon, size: 18, color: iconColor),
      ),
    );
  }
}