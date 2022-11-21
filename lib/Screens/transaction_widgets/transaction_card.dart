import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:masrufat/Models/accounts.dart';
import 'package:masrufat/Providers/accounts_provider.dart';
import 'package:masrufat/dialog/custom_generic_dialog.dart';
import 'package:masrufat/helper/app_config.dart';
import 'package:provider/provider.dart';

import '../../Models/transaction.dart';
import 'add_transaction_bottom_sheet.dart';

class TransactionCard extends StatefulWidget {
  final Account account;
  final AccountType type;
  final Transactions trans;
  final int accountIndex;
  final int transactionIndex;
  final VoidCallback onRefresh;
  const TransactionCard({
    Key? key,
    required this.trans,
    required this.account,
    required this.onRefresh,
    required this.type,
    required this.transactionIndex,
    required this.accountIndex,
  }) : super(key: key);

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  late Transactions transaction = widget.trans;
  late Account account = widget.account;
  late int transactionIndex = widget.transactionIndex;
  late int accountIndex = widget.accountIndex;
  late final _type = widget.type;
  bool isExpanded = false;
  late AccountsProvider myProvider =
      Provider.of<AccountsProvider>(context, listen: false);

  void _onRefresh() => setState(() {
        widget.onRefresh();
      });

  void _onDeleteTransaction() {
    customGenericDialog(
      context: context,
      title: AppConfig.dialogConfirmationTitle,
      content: AppConfig.dialogConfirmationDelete,
      dialogOptions: () => {
        'No': null,
        'Yes': () async => await myProvider
                .deleteTransaction(
                  trans: account.transactions[transactionIndex],
                  type: _type,
                  transIndex: transactionIndex,
                  accountIndex: accountIndex,
                )
                .then((value) => Navigator.of(context).pop())
                .then((value) {
              _onRefresh();
            })
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final incomeStyle = TextStyle(
      color: account.transactions[transactionIndex].isIncome
          ? Colors.black
          : Colors.white,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: Radius.circular(isExpanded ? 0 : 20),
              bottomRight: Radius.circular(isExpanded ? 0 : 20),
            ),
          ),
          color: account.transactions[transactionIndex].isIncome
              ? Colors.green
              : Colors.red,
          child: ListTile(
            title: Text(
              account.transactions[transactionIndex].name,
              style: incomeStyle,
            ),
            subtitle: Text(
              DateFormat('MMM d,h:mm a')
                  .format(
                    DateTime.parse(account.transactions[transactionIndex].id),
                  )
                  .toString(),
              style: incomeStyle,
            ),
            leading: Text(
              account.transactions[transactionIndex].balance.toString(),
              style: incomeStyle,
            ),
            trailing: GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Icon(
                !isExpanded
                    ? Icons.arrow_drop_down_circle
                    : Icons.arrow_drop_up_sharp,
                color: Colors.white,
              ),
            ),
          ),
        ),
        if (isExpanded)
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(left: 5, right: 5, bottom: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isExpanded ? 0 : 20),
                topRight: Radius.circular(isExpanded ? 0 : 20),
                bottomLeft: const Radius.circular(20),
                bottomRight: const Radius.circular(20),
              ),
              color: Colors.black12,
            ),
            child: Column(
              children: [
                Text(account.transactions[transactionIndex].description),
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
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: AddTransactionBottomSheet(
                                transIndex: transactionIndex,
                                isUpdate: true,
                                reFresh: _onRefresh,
                                account: account,
                                type: _type,
                              ),
                            );
                          },
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Text(AppConfig.edit),
                            Icon(Icons.edit),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Text(
                              AppConfig.transfer,
                            ),
                            Icon(
                              Icons.compare_arrows,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: _onDeleteTransaction,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              AppConfig.delete,
                              style: TextStyle(
                                color: Theme.of(context).errorColor,
                              ),
                            ),
                            Icon(
                              Icons.delete,
                              color: Theme.of(context).errorColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
      ],
    );
  }
}
