import 'package:hive/hive.dart';
import 'package:masrufat/Models/transaction.dart';

part 'debit_account.g.dart';

@HiveType(typeId: 3)
class DebitAccount extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  double balance;
  @HiveField(4)
  final List<Transactions> transactions;
  DebitAccount({
    required this.id,
    required this.transactions,
    required this.name,
    required this.description,
    required this.balance,
  });
  @override
  String toString() => {
        'id': id,
        'name': name,
        'description': description,
        'balance': balance,
        'transactions': transactions,
      }.toString();
}
