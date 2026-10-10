import 'package:flutter/foundation.dart';
import 'package:lilac_company_task/service/hiveservice.dart';


class ProfileController extends ChangeNotifier {
  String _name = HiveService.defaultName;
  String get name => _name;

  void load() {
    try {
      _name = HiveService.getName();
    } on DatabaseException {
      _name = HiveService.defaultName;
    }
    notifyListeners();
  }

  Future<bool> updateName(String name) async {
    try {
      await HiveService.saveName(name.trim());
      _name = name.trim();
      notifyListeners();
      return true;
    } on DatabaseException {
      return false;
    }
  }

  Future<bool> clearStorage() async {
    try {
      await HiveService.clearAll();
      _name = HiveService.defaultName;
      notifyListeners();
      return true;
    } on DatabaseException {
      return false;
    }
  }
}