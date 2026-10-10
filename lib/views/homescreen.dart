import 'package:flutter/material.dart';
import 'package:lilac_company_task/controller/navcontroller.dart';
import 'package:lilac_company_task/controller/profilecontroller.dart';
import 'package:lilac_company_task/controller/transactioncontroller.dart';
import 'package:lilac_company_task/utils/apptheme.dart';
import 'package:lilac_company_task/utils/formatters.dart';
import 'package:lilac_company_task/widgets/emptystate.dart';
import 'package:lilac_company_task/widgets/transactiontile.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning,';
    if (h < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  @override
  Widget build(BuildContext context) {
    final tx = context.watch<TransactionController>();
    final name = context.watch<ProfileController>().name;

    if (tx.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 100),
        children: [
          Text(_greeting(), style: const TextStyle(fontSize: 13)),
          Text(
            name,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          _BalanceCard(tx: tx),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  label: 'DAILY AVERAGE',
                  value: money(tx.dailyAverage),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatBox(
                  label: 'WEEKLY',
                  value: money(tx.weeklyExpense),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transactions History',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: () => context.read<NavController>().go(1),
                child: const Text(
                  'See all',
                  style: TextStyle(fontSize: 12, color: AppColors.label),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (tx.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 30),
              child: EmptyState(
                message: 'No transactions yet.\nTap + to add your first one.',
              ),
            )
          else
            ...tx.recent.map((t) => TransactionTile(transaction: t)),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final TransactionController tx;
  const _BalanceCard({required this.tx});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Balance',
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              money(tx.balance),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _Mini(
                  icon: Icons.arrow_downward,
                  label: 'Income',
                  value: money(tx.totalIncome),
                ),
              ),
              Expanded(
                child: _Mini(
                  icon: Icons.arrow_upward,
                  label: 'Expenses',
                  value: money(tx.totalExpense),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Mini extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _Mini({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 9,
              backgroundColor: Colors.white24,
              child: Icon(icon, size: 12, color: Colors.white),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.label,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}
