import 'package:flutter/foundation.dart';
import 'package:lilac_company_task/models/transactionmodel.dart';
import 'package:lilac_company_task/service/hiveservice.dart';


class TransactionController extends ChangeNotifier {
  List<TransactionModel> _items = [];
  bool _loading = true;
  String? _error;

  List<TransactionModel> get items => _items;
  bool get isLoading => _loading;
  String? get error => _error;
  bool get isEmpty => _items.isEmpty;
  List<TransactionModel> get recent => _items.take(3).toList();

  double get totalIncome =>
      _items.where((t) => !t.isExpense).fold(0.0, (s, t) => s + t.amount);
  double get totalExpense =>
      _items.where((t) => t.isExpense).fold(0.0, (s, t) => s + t.amount);
  double get balance => totalIncome - totalExpense;

  double get dailyAverage {
    final expenses = _items.where((t) => t.isExpense).toList();
    if (expenses.isEmpty) return 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final first = expenses.map((e) => e.date).reduce((a, b) => a.isBefore(b) ? a : b);
    final firstDay = DateTime(first.year, first.month, first.day);
    final days = today.difference(firstDay).inDays + 1;
    return totalExpense / (days < 1 ? 1 : days);
  }

  double get weeklyExpense {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));
    return _items
        .where((t) => t.isExpense && !t.date.isBefore(start))
        .fold(0.0, (s, t) => s + t.amount);
  }

  void _sort() => _items.sort((a, b) => b.date.compareTo(a.date));

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    try {
      _items = HiveService.getTransactions();
      _sort();
      _error = null;
    } on DatabaseException catch (e) {
      _error = e.message;
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> add(TransactionModel t) => _run(() => HiveService.saveTransaction(t));
  Future<bool> update(TransactionModel t) => _run(() => HiveService.saveTransaction(t));
  Future<bool> delete(String id) => _run(() => HiveService.deleteTransaction(id));

  Future<bool> _run(Future<void> Function() action) async {
    try {
      await action();
      _items = HiveService.getTransactions();
      _sort();
      _error = null;
      notifyListeners();
      return true;
    } on DatabaseException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    }
  }
}