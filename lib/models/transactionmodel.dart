import 'package:hive/hive.dart';

enum TransactionType { income, expense }

class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final String category;
  final DateTime date;
  final String? description;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.description,
  });

  bool get isExpense => type == TransactionType.expense;
}

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 0;

  @override
  TransactionModel read(BinaryReader reader) {
    final id = reader.readString();
    final title = reader.readString();
    final amount = reader.readDouble();
    final type = TransactionType.values[reader.readInt()];
    final category = reader.readString();
    final date = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final description = reader.read() as String?;
    return TransactionModel(
      id: id,
      title: title,
      amount: amount,
      type: type,
      category: category,
      date: date,
      description: description,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.title)
      ..writeDouble(obj.amount)
      ..writeInt(obj.type.index)
      ..writeString(obj.category)
      ..writeInt(obj.date.millisecondsSinceEpoch)
      ..write(obj.description);
  }
}