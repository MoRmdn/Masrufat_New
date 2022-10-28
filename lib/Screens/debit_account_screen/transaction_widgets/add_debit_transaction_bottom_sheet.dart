import 'package:flutter/material.dart';
import 'package:masrufat/Models/debit_account.dart';
import 'package:masrufat/Models/transaction.dart';
import 'package:masrufat/Providers/accounts_provider.dart';
import 'package:masrufat/dialog/custom_generic_dialog.dart';
import 'package:masrufat/dialog/loading_screen_dialog.dart';
import 'package:provider/provider.dart';

import '../../../Widgets/custom_text_field.dart';
import '../../../helper/app_config.dart';

enum TansMood {
  add,
  update,
}

// ignore: must_be_immutable
class AddDebitTransactionBottomSheet extends StatefulWidget {
  final DebitAccount account;
  VoidCallback reFresh;
  final int? transIndex;
  final bool? isUpdate;
  AddDebitTransactionBottomSheet({
    Key? key,
    required this.account,
    required this.reFresh,
    this.isUpdate,
    this.transIndex,
  }) : super(key: key);

  @override
  State<AddDebitTransactionBottomSheet> createState() =>
      _AddDebitTransactionBottomSheetState();
}

class _AddDebitTransactionBottomSheetState
    extends State<AddDebitTransactionBottomSheet> {
  final transactionNameController = TextEditingController();
  final balanceController = TextEditingController();
  String timeAsID = DateTime.now().toIso8601String();
  late AccountsProvider myProvider;
  bool switchValue = true;
  TansMood mood = TansMood.add;
  final loading = LoadingScreen.instance();

  @override
  void initState() {
    myProvider = Provider.of<AccountsProvider>(context, listen: false);
    _checkMood();
    if (mood == TansMood.update) _updateMode();
    super.initState();
  }

  @override
  void dispose() {
    balanceController.dispose();
    transactionNameController.dispose();
    super.dispose();
  }

  void _checkMood() => setState(() {
        widget.isUpdate == null
            ? null
            : widget.isUpdate!
                ? mood = TansMood.update
                : mood = TansMood.add;
      });

  void _updateMode() => setState(() {
        final index = widget.transIndex!;
        transactionNameController.text =
            widget.account.transactions[index].name;
        balanceController.text =
            widget.account.transactions[index].balance.toString();
        switchValue = widget.account.transactions[index].isIncome;
      });

  void _onUpdateTransaction() {
    loading.show(context: context, content: AppConfig.pleaseWait);
    final balance = balanceController.text;
    final name = transactionNameController.text;
    if (balance.isEmpty || name.isEmpty) {
      Future.delayed(const Duration(milliseconds: 500))
          .then((value) => loading.hide());
      customGenericDialog(
        context: context,
        title: AppConfig.dialogErrorTitle,
        content: AppConfig.dialogErrorEmptyAccountName,
        dialogOptions: () => {
          AppConfig.ok: null,
        },
      );
      return;
    }
    final index = widget.transIndex!;

    if (switchValue) {
      final newTrans = Transactions(
        id: widget.account.transactions[index].id,
        name: name,
        isIncome: switchValue,
        balance: double.parse(balance),
      );
      myProvider.updateTransaction(
        debitAccount: widget.account,
        newTransaction: newTrans,
        creditAccount: null,
      );
    } else {
      final newTrans = Transactions(
        id: widget.account.transactions[index].id,
        name: name,
        isIncome: switchValue,
        balance: -double.parse(balance),
      );
      myProvider.updateTransaction(
        debitAccount: widget.account,
        newTransaction: newTrans,
        creditAccount: null,
      );
    }

    widget.reFresh();
    Future.delayed(const Duration(milliseconds: 500))
        .then((value) => loading.hide());
    Navigator.of(context).pop();
  }

  void _onAddTransaction() {
    loading.show(context: context, content: AppConfig.pleaseWait);

    final transactionName = transactionNameController.text;
    final transactionBalance = balanceController.text;
    if (transactionName.isEmpty || transactionBalance.isEmpty) {
      Future.delayed(const Duration(milliseconds: 500))
          .then((value) => loading.hide());
      customGenericDialog(
        context: context,
        title: AppConfig.dialogErrorTitle,
        content: AppConfig.dialogErrorEmptyAccountName,
        dialogOptions: () {
          return {
            AppConfig.ok: null,
          };
        },
      );
      return;
    }

    if (switchValue) {
      final newTrans = Transactions(
        id: timeAsID,
        name: transactionName,
        isIncome: switchValue,
        balance: double.parse(transactionBalance),
      );
      myProvider.addTransaction(
        existDebitAccount: widget.account,
        newTransaction: newTrans,
        existCreditAccount: null,
      );
    } else {
      final newTrans = Transactions(
        id: timeAsID,
        name: transactionName,
        isIncome: switchValue,
        balance: -double.parse(transactionBalance),
      );
      myProvider.addTransaction(
        existDebitAccount: widget.account,
        newTransaction: newTrans,
        existCreditAccount: null,
      );
    }

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
            mood == TansMood.add
                ? AppConfig.addTransAction
                : AppConfig.updateTransAction,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: dSize.height * 0.05),
          kTextField(
            controller: transactionNameController,
            textFieldHint: AppConfig.transactionName,
            textFieldLabel: AppConfig.transactionNameHint,
            kType: TextInputType.name,
          ),
          kTextField(
            controller: balanceController,
            textFieldHint: AppConfig.transactionBalanceHint,
            textFieldLabel: AppConfig.transactionBalance,
            kType: TextInputType.number,
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
            onPressed:
                mood == TansMood.add ? _onAddTransaction : _onUpdateTransaction,
            child: Text(
              mood == TansMood.add
                  ? AppConfig.addTransAction
                  : AppConfig.updateTransAction,
            ),
          )
        ],
      ),
    );
  }
}
