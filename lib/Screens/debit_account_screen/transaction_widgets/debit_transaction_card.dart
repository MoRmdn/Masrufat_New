import 'package:flutter/material.dart';
import 'package:masrufat/Models/debit_account.dart';
import 'package:masrufat/Models/transaction.dart';
import 'package:masrufat/Providers/accounts_provider.dart';
import 'package:masrufat/dialog/custom_generic_dialog.dart';
import 'package:masrufat/helper/app_config.dart';
import 'package:provider/provider.dart';

import 'add_debit_transaction_bottom_sheet.dart';

class DebitTransactionCard extends StatefulWidget {
  final DebitAccount account;
  final Transactions trans;
  final VoidCallback onRefresh;
  const DebitTransactionCard({
    Key? key,
    required this.trans,
    required this.account,
    required this.onRefresh,
  }) : super(key: key);

  @override
  State<DebitTransactionCard> createState() => _DebitTransactionCardState();
}

class _DebitTransactionCardState extends State<DebitTransactionCard> {
  bool isExpanded = false;
  late AccountsProvider myProvider;
  @override
  void initState() {
    myProvider = Provider.of<AccountsProvider>(context, listen: false);
    super.initState();
  }

  void _onRefresh() => setState(() {});

  void _onDeleteTransaction(int index) {
    customGenericDialog(
      context: context,
      title: AppConfig.dialogConfirmationTitle,
      content: AppConfig.dialogConfirmationDelete,
      dialogOptions: () => {
        'No': null,
        'Yes': () => myProvider
                .deleteTransaction(
                  index: index,
                  debitAccount: widget.account,
                  creditAccount: null,
                )
                .then((value) => Navigator.of(context).pop())
                .then((value) {
              widget.onRefresh();
              _onRefresh();
            })
      },
    );
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final transaction = widget.trans;
    final account = widget.account;
    final index = account.transactions
        .indexWhere((element) => element.id == transaction.id);
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
            mainAxisSize: MainAxisSize.min,
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
                            child: AddDebitTransactionBottomSheet(
                              transIndex: index,
                              isUpdate: true,
                              account: account,
                              reFresh: _onRefresh,
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
