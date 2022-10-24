import 'package:flutter/material.dart';
import 'package:masrufat/Models/credit_account.dart';
import 'package:masrufat/Models/transaction.dart';
import 'package:masrufat/Providers/accounts_provider.dart';
import 'package:masrufat/dialog/custom_generic_dialog.dart';
import 'package:masrufat/dialog/loading_screen_dialog.dart';
import 'package:provider/provider.dart';

import '../helper/app_config.dart';
import 'custom_text_field.dart';

class TransactionBottomSheet extends StatefulWidget {
  final CreditAccount account;
  final VoidCallback reFresh;
  const TransactionBottomSheet({
    Key? key,
    required this.account,
    required this.reFresh,
  }) : super(key: key);

  @override
  State<TransactionBottomSheet> createState() => _TransactionBottomSheetState();
}

class _TransactionBottomSheetState extends State<TransactionBottomSheet> {
  final transactionNameController = TextEditingController();
  final balanceController = TextEditingController();
  bool switchValue = false;
  final loading = LoadingScreen.instance();

  @override
  void dispose() {
    balanceController.dispose();
    transactionNameController.dispose();
    super.dispose();
  }

  void _onSave() {
    loading.show(context: context, content: AppConfig.pleaseWait);
    final myProvider = Provider.of<AccountsProvider>(context, listen: false);
    final transactionName = transactionNameController.text;
    final transactionBalance = balanceController.text;
    if (transactionName.isEmpty || transactionBalance.isEmpty) {
      customGenericDialog(
        context: context,
        title: AppConfig.dialogErrorTitle,
        content: AppConfig.dialogErrorEmptyAccountName,
        dialogOptions: () {
          return {AppConfig.ok: true};
        },
      );
      return;
    }
    final newTrans = Transactions(
      id: DateTime.now().toIso8601String(),
      name: transactionName,
      isIncome: switchValue,
      balance: double.parse(transactionBalance),
    );
    myProvider.addTransaction(
      existAccount: widget.account,
      newTransaction: newTrans,
    );
    widget.reFresh();
    Future.delayed(const Duration(milliseconds: 500))
        .then((value) => loading.hide());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final dSize = MediaQuery.of(context).size;
    return Container(
      constraints: BoxConstraints(
        maxHeight: dSize.height * 0.8,
        minHeight: dSize.height * 0.5,
        maxWidth: dSize.width,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: dSize.height * 0.01),
          Text(
            AppConfig.addTransAction,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: dSize.height * 0.05),
          kTextField(
            controller: transactionNameController,
            textFieldHint: AppConfig.transactionName,
            textFieldLabel: AppConfig.transactionNameHint,
          ),
          kTextField(
            controller: balanceController,
            textFieldHint: AppConfig.transactionBalance,
            textFieldLabel: AppConfig.transactionBalanceHint,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'is it income ?',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Switch(
                  value: switchValue,
                  onChanged: (value) {
                    setState(() {
                      switchValue = !switchValue;
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: dSize.height * 0.05),
          ElevatedButton(
            onPressed: _onSave,
            child: const Text(AppConfig.addTransAction),
          )
        ],
      ),
    );
  }
}
