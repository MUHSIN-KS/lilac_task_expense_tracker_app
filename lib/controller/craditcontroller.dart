import 'package:flutter/foundation.dart';
import 'package:lilac_company_task/models/creditmodel.dart';
import 'package:lilac_company_task/service/hiveservice.dart';


class CreditController extends ChangeNotifier {
  List<CreditModel> _items = [];
  String? _error;

  List<CreditModel> get items => _items;
  String? get error => _error;

  Future<void> load() async {
    try {
      _items = HiveService.getCredits()..sort((a, b) => a.date.compareTo(b.date));
      _error = null;
    } on DatabaseException catch (e) {
      _error = e.message;
    }
    notifyListeners();
  }

  Future<bool> add(CreditModel c) => _run(() => HiveService.saveCredit(c));
  Future<bool> delete(String id) => _run(() => HiveService.deleteCredit(id));

  Future<bool> _run(Future<void> Function() action) async {
    try {
      await action();
      await load();
      return true;
    } on DatabaseException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    }
  }
}