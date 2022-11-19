import 'package:hive/hive.dart';

import 'accounts.dart';

part 'transaction.g.dart';

enum AccountTransferData {
  formCreditToDebit,
  formCreditToCredit,
  formDebitToCredit,
  formDebitToDebit,
}

@HiveType(typeId: 3)
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
  final String description;
  @HiveField(5)
  Account? transferTo;
  @HiveField(6)
  Account? transferFrom;
  @HiveField(7)
  AccountTransferData? fromTo;

  Transactions({
    required this.id,
    required this.name,
    required this.description,
    required this.isIncome,
    required this.balance,
    this.transferTo,
    this.transferFrom,
    this.fromTo,
  });

  factory Transactions.fromMap(Map map) {
    return Transactions(
      balance: map['balance'],
      name: map['name'],
      isIncome: map['isIncome'],
      id: map['id'],
      transferTo: map['transferTo'],
      description: map['description'],
    );
  }

  Transactions.initial({
    required this.id,
    required this.balance,
    this.description = 'initial Transaction',
    this.name = 'initial Transaction',
    this.isIncome = true,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'isIncome': isIncome,
        'balance': balance,
        'description': description,
        'transferTo': transferTo,
      };

  @override
  String toString() => {
        'id': id,
        'name': name,
        'isIncome': isIncome,
        'description': description,
        'transferTo': transferTo,
        'balance': balance,
      }.toString();
}
