class Validators {
  static String? required(String? v, String field) {
    if (v == null || v.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? title(String? v) {
    final r = required(v, 'Name');
    if (r != null) return r;
    if (v!.trim().length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  static String? amount(String? v) {
    final r = required(v, 'Amount');
    if (r != null) return r;
    final n = double.tryParse(v!.trim());
    if (n == null) return 'Enter a valid number';
    if (n <= 0) return 'Amount must be greater than 0';
    return null;
  }
}