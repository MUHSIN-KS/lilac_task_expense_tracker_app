import 'package:hive_flutter/hive_flutter.dart';
import 'package:lilac_company_task/models/creditmodel.dart';
import 'package:lilac_company_task/models/transactionmodel.dart';


class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);
  @override
  String toString() => message;
}

class HiveService {
  static const _txBox = 'transactions';
  static const _creditBox = 'credits';
  static const _settingsBox = 'settings';
  static const _nameKey = 'user_name';
  static const defaultName = 'Sahal Muhammed';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TransactionModelAdapter());
    Hive.registerAdapter(CreditModelAdapter());
    await Hive.openBox<TransactionModel>(_txBox);
    await Hive.openBox<CreditModel>(_creditBox);
    await Hive.openBox(_settingsBox);
  }

  static Box<TransactionModel> get _tx => Hive.box<TransactionModel>(_txBox);
  static Box<CreditModel> get _credit => Hive.box<CreditModel>(_creditBox);
  static Box get _settings => Hive.box(_settingsBox);

  static T _guard<T>(String action, T Function() fn) {
    try {
      return fn();
    } catch (e) {
      throw DatabaseException('Could not $action. Please try again.');
    }
  }

  static Future<T> _guardAsync<T>(String action, Future<T> Function() fn) async {
    try {
      return await fn();
    } catch (e) {
      throw DatabaseException('Could not $action. Please try again.');
    }
  }

  static List<TransactionModel> getTransactions() =>
      _guard('load transactions', () => _tx.values.toList());

  static Future<void> saveTransaction(TransactionModel t) =>
      _guardAsync('save transaction', () => _tx.put(t.id, t)); // create + update

  static Future<void> deleteTransaction(String id) =>
      _guardAsync('delete transaction', () => _tx.delete(id));

  static List<CreditModel> getCredits() =>
      _guard('load saved lists', () => _credit.values.toList());

  static Future<void> saveCredit(CreditModel c) =>
      _guardAsync('save credit', () => _credit.put(c.id, c));

  static Future<void> deleteCredit(String id) =>
      _guardAsync('delete credit', () => _credit.delete(id));

  static String getName() => _guard(
      'load profile', () => _settings.get(_nameKey, defaultValue: defaultName) as String);

  static Future<void> saveName(String name) =>
      _guardAsync('save name', () => _settings.put(_nameKey, name));

  static Future<void> clearAll() => _guardAsync('clear storage', () async {
        await _tx.clear();
        await _credit.clear();
        await _settings.clear();
      });
}