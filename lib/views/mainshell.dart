import 'package:flutter/material.dart';
import 'package:lilac_company_task/controller/navcontroller.dart';
import 'package:lilac_company_task/utils/apptheme.dart';
import 'package:lilac_company_task/views/creditscreen.dart';
import 'package:lilac_company_task/views/historyscreen.dart';
import 'package:lilac_company_task/views/homescreen.dart';
import 'package:lilac_company_task/views/profilescreen.dart';
import 'package:lilac_company_task/views/transactionfromscreen.dart';
import 'package:provider/provider.dart';


class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavController>();

    return Scaffold(
      body: IndexedStack(
        index: nav.index,
        children: const [HomeScreen(), HistoryScreen(), CreditScreen(), ProfileScreen()],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(color: Color(0xFFE8E8E8), shape: BoxShape.circle),
        child: FloatingActionButton(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const CircleBorder(),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const TransactionFormScreen()),
          ),
          child: const Icon(Icons.add, size: 32),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.primary,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavIcon(icon: Icons.home_outlined, active: nav.index == 0, onTap: () => nav.go(0)),
            _NavIcon(icon: Icons.history, active: nav.index == 1, onTap: () => nav.go(1)),
            const SizedBox(width: 56),
            _NavIcon(
                icon: Icons.account_balance_wallet_outlined,
                active: nav.index == 2,
                onTap: () => nav.go(2)),
            _NavIcon(icon: Icons.person_outline, active: nav.index == 3, onTap: () => nav.go(3)),
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  const _NavIcon({required this.icon, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      iconSize: 28,
      icon: Icon(icon, color: active ? Colors.white : Colors.white54),
    );
  }
}