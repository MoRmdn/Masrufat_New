import 'package:flutter/material.dart';
import 'package:masrufat/Models/accounts.dart';
import 'package:masrufat/Models/transaction.dart';
import 'package:masrufat/Providers/accounts_provider.dart';
import 'package:masrufat/dialog/custom_generic_dialog.dart';
import 'package:masrufat/helper/app_config.dart';
import 'package:provider/provider.dart';

import 'add_transaction_bottom_sheet.dart';

// ignore: must_be_immutable
class TransactionCard extends StatefulWidget {
  final CreditAccount? crAccount;
  final DebitAccount? drAccount;
  final AccountType type;
  final Transactions trans;
  final VoidCallback onRefresh;
  const TransactionCard({
    Key? key,
    required this.trans,
    required this.onRefresh,
    required this.crAccount,
    required this.drAccount,
    required this.type,
  }) : super(key: key);

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  bool isExpanded = false;
  late AccountsProvider myProvider;
  @override
  void initState() {
    myProvider = Provider.of<AccountsProvider>(context, listen: false);
    super.initState();
  }

  void _onRefresh() => setState(() {
        widget.onRefresh();
      });

  void _onDeleteTransaction(int index) {
    final crAccount = widget.crAccount;
    final drAccount = widget.drAccount;
    customGenericDialog(
      context: context,
      title: AppConfig.dialogConfirmationTitle,
      content: AppConfig.dialogConfirmationDelete,
      dialogOptions: () => {
        'No': null,
        'Yes': () async => await myProvider
                .deleteTransaction(
                  index: index,
                  creditAccount: crAccount,
                  debitAccount: drAccount,
                )
                .then((value) => Navigator.of(context).pop())
                .then((value) {
              widget.onRefresh();
              _onRefresh();
            })
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int index;
    final transaction = widget.trans;
    final crAccount = widget.crAccount;
    final drAccount = widget.drAccount;
    final _type = widget.type;
    if (_type == AccountType.credit) {
      index = crAccount!.transactions
          .indexWhere((element) => element.id == transaction.id);
    } else {
      index = drAccount!.transactions
          .indexWhere((element) => element.id == transaction.id);
    }
    final incomeStyle = TextStyle(
      color: transaction.isIncome ? Colors.black : Colors.white,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.all(10),
          color: transaction.isIncome ? Colors.green : Colors.red,
          child: ListTile(
            title: Text(
              transaction.name,
              style: incomeStyle,
            ),
            subtitle: Text(
              transaction.id,
              style: incomeStyle,
            ),
            leading: Text(
              transaction.balance.toString(),
              style: incomeStyle,
            ),
            trailing: GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: const Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
        if (isExpanded)
          Column(
            children: [
              Text(transaction.description),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => showModalBottomSheet<void>(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: AddTransactionBottomSheet(
                              transIndex: index,
                              isUpdate: true,
                              reFresh: _onRefresh,
                              crAccount: crAccount,
                              drAccount: drAccount,
                              type: _type,
                            ),
                          );
                        },
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Text('edit'),
                          Icon(Icons.edit),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () => _onDeleteTransaction(index),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Text('delete'),
                          Icon(Icons.delete),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
      ],
    );
  }
}
