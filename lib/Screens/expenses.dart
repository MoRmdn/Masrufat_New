import 'package:flutter/material.dart';
import 'package:masrufat/Models/transaction.dart';

class Expenses extends StatelessWidget {
  final List<Transactions> expenses;
  final List<Transactions> expensesThisMonth;
  final double totalExpenses;
  final double totalExpensesThisMonth;
  const Expenses({
    Key? key,
    required this.expenses,
    required this.expensesThisMonth,
    required this.totalExpenses,
    required this.totalExpensesThisMonth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: Card(
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('This Month Expenses'),
                    Text('$totalExpensesThisMonth \$'),
                  ],
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: expensesThisMonth
                .map(
                  (trans) => ListTile(
                    title: Text(
                      trans.name,
                    ),
                    subtitle: Text(
                      trans.id,
                    ),
                    leading: Text(
                      trans.balance.toString(),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
