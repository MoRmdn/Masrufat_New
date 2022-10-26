import 'package:flutter/material.dart';
import 'package:masrufat/Models/credit_account.dart';
import 'package:masrufat/Models/transaction.dart';
import 'package:masrufat/Providers/accounts_provider.dart';
import 'package:masrufat/dialog/custom_generic_dialog.dart';
import 'package:masrufat/helper/app_config.dart';
import 'package:provider/provider.dart';

import 'add_transaction_bottom_sheet.dart';

class TransactionCard extends StatefulWidget {
  final CreditAccount account;
  final Transactions trans;
  const TransactionCard({
    Key? key,
    required this.trans,
    required this.account,
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

  void _onRefresh() => setState(() {});

  void _onDeleteTransaction(BuildContext ctx, int index) {
    customGenericDialog(
      context: ctx,
      title: AppConfig.dialogConfirmationTitle,
      content: AppConfig.dialogConfirmationDelete,
      dialogOptions: () => {
        'No': null,
        'Yes': () => myProvider.deleteTransaction(
              index: index,
              creditAccount: widget.account,
            )
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
                  onPressed: () => _onDeleteTransaction(context, index),
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
          )
      ],
    );
  }
}
