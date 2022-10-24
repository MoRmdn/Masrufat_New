import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 2)
class Transactions extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final double balance;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final bool isIncome;
  @HiveField(4)
  String? transferTo;

  Transactions({
    required this.id,
    required this.name,
    required this.isIncome,
    required this.balance,
    this.transferTo,
  });

  factory Transactions.fromMap(Map map) {
    return Transactions(
      balance: map['balance'],
      name: map['name'],
      isIncome: map['isIncome'],
      id: map['id'],
      transferTo: map['transferTo'],
    );
  }

  Transactions.initial({
    required this.id,
    required this.balance,
    this.name = 'initial Transaction',
    this.isIncome = true,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'isIncome': isIncome,
        'balance': balance,
        'transferTo': transferTo,
      };

  @override
  String toString() => {
        'id': id,
        'name': name,
        'isIncome': isIncome,
        'transferTo': transferTo,
        'balance': balance,
      }.toString();
}
