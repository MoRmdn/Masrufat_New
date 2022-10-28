import 'package:hive/hive.dart';
import 'package:masrufat/Models/transaction.dart';

part 'credit_account.g.dart';

@HiveType(typeId: 1)
class CreditAccount extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final List<Transactions> transactions;
  CreditAccount({
    required this.transactions,
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'transactions': transactions,
      };

  factory CreditAccount.fromMap(Map map) {
    return CreditAccount(
      name: map['name'],
      id: map['id'],
      transactions: map['transactions'],
    );
  }

  @override
  String toString() => {
        'id': id,
        'name': name,
        'transactions': transactions,
      }.toString();
}
