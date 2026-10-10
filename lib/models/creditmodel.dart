import 'package:hive/hive.dart';

class CreditModel {
  final String id;
  final String creditType;
  final String to;
  final DateTime date;
  final String planType;
  final double amount;

  const CreditModel({
    required this.id,
    required this.creditType,
    required this.to,
    required this.date,
    required this.planType,
    required this.amount,
  });
}

class CreditModelAdapter extends TypeAdapter<CreditModel> {
  @override
  final int typeId = 1;

  @override
  CreditModel read(BinaryReader reader) {
    return CreditModel(
      id: reader.readString(),
      creditType: reader.readString(),
      to: reader.readString(),
      date: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      planType: reader.readString(),
      amount: reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, CreditModel obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.creditType)
      ..writeString(obj.to)
      ..writeInt(obj.date.millisecondsSinceEpoch)
      ..writeString(obj.planType)
      ..writeDouble(obj.amount);
  }
}