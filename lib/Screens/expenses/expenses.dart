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
                    Expanded(
                      flex: 3,
                      child: Text(
                        'This Month Expenses',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '$totalExpensesThisMonth \$',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: expensesThisMonth
                .map(
                  (trans) => Container(
                    margin: const EdgeInsets.all(10),
                    color: Colors.red,
                    child: ListTile(
                      textColor: Colors.white,
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
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
