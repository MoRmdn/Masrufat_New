import 'package:flutter/foundation.dart' show immutable;

@immutable
class DebitAccount {
  final String id;
  final String name;
  final String description;
  final double balance;
  const DebitAccount(
    this.id, {
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
      }.toString();
}
