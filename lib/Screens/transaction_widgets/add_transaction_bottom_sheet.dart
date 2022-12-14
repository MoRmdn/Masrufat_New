import 'package:flutter/material.dart';
import 'package:masrufat/Models/accounts.dart';
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

class AddTransactionBottomSheet extends StatefulWidget {
  final Account account;
  final AccountType type;
  final VoidCallback reFresh;
  final int? transIndex;
  final bool? isUpdate;
  const AddTransactionBottomSheet({
    Key? key,
    required this.reFresh,
    this.isUpdate,
    this.transIndex,
    required this.account,
    required this.type,
  }) : super(key: key);

  @override
  State<AddTransactionBottomSheet> createState() =>
      _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState extends State<AddTransactionBottomSheet> {
  final transactionNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final balanceController = TextEditingController();
  final _textFocusNode = FocusNode();
  String timeAsID = DateTime.now().toIso8601String();
  late AccountsProvider myProvider;
  bool switchValue = false;
  TansMood mood = TansMood.add;
  final loading = LoadingScreen.instance();
  late AccountType type = widget.type;
  late int index = widget.transIndex!;
  late Account account = widget.account;

  @override
  void initState() {
    _textFocusNode.requestFocus();
    myProvider = Provider.of<AccountsProvider>(context, listen: false);
    _checkMood();
    if (mood == TansMood.update) _updateMode();
    super.initState();
  }

  @override
  void dispose() {
    _textFocusNode.dispose();
    descriptionController.dispose();
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
        if (type == AccountType.credit) {
          transactionNameController.text = account.transactions[index].name;
          balanceController.text =
              account.transactions[index].balance.abs().toString();
          descriptionController.text = account.transactions[index].description;
          switchValue = account.transactions[index].isIncome;
        } else {
          transactionNameController.text = account.transactions[index].name;
          balanceController.text =
              account.transactions[index].balance.abs().toString();
          descriptionController.text = account.transactions[index].description;
          switchValue = account.transactions[index].isIncome;
        }
      });

  void _onUpdateTransaction() {
    loading.show(context: context, content: AppConfig.pleaseWait);
    final balance = balanceController.text;
    final name = transactionNameController.text;
    final description = descriptionController.text;
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

    if (type == AccountType.credit) {
      if (switchValue) {
        final newTrans = Transactions(
          id: account.transactions[index].id,
          name: name,
          description: description,
          isIncome: switchValue,
          balance: double.parse(balance),
        );
        myProvider.updateTransaction(
          newTransaction: newTrans,
          creditAccount: account as CreditAccount,
          debitAccount: null,
        );
      } else {
        final newTrans = Transactions(
          id: account.transactions[index].id,
          name: name,
          description: description,
          isIncome: switchValue,
          balance: -double.parse(balance),
        );
        myProvider.updateTransaction(
          creditAccount: account as CreditAccount,
          newTransaction: newTrans,
          debitAccount: null,
        );
      }
    } else {
      if (switchValue) {
        final newTrans = Transactions(
          id: account.transactions[index].id,
          name: name,
          description: description,
          isIncome: switchValue,
          balance: double.parse(balance),
        );
        myProvider.updateTransaction(
          creditAccount: null,
          newTransaction: newTrans,
          debitAccount: account as DebitAccount,
        );
      } else {
        final newTrans = Transactions(
          id: account.transactions[index].id,
          name: name,
          description: description,
          isIncome: switchValue,
          balance: -double.parse(balance),
        );
        myProvider.updateTransaction(
          creditAccount: null,
          newTransaction: newTrans,
          debitAccount: account as DebitAccount,
        );
      }
    }
    widget.reFresh();
    Future.delayed(const Duration(milliseconds: 500))
        .then((value) => loading.hide());
    Navigator.of(context).pop();
  }

  void _onAddTransaction() {
    final type = widget.type;

    loading.show(context: context, content: AppConfig.pleaseWait);
    final description = descriptionController.text;
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

    if (type == AccountType.credit) {
      if (switchValue) {
        final newTrans = Transactions(
          id: timeAsID,
          name: transactionName,
          description: description,
          isIncome: switchValue,
          balance: double.parse(transactionBalance),
        );
        myProvider.addTransaction(
          existCreditAccount: account as CreditAccount,
          newTransaction: newTrans,
          existDebitAccount: null,
        );
      } else {
        final newTrans = Transactions(
          id: timeAsID,
          description: description,
          name: transactionName,
          isIncome: switchValue,
          balance: -double.parse(transactionBalance),
        );
        myProvider.addTransaction(
          existCreditAccount: account as CreditAccount,
          newTransaction: newTrans,
          existDebitAccount: null,
        );
      }
    } else {
      if (switchValue) {
        final newTrans = Transactions(
          id: timeAsID,
          name: transactionName,
          description: description,
          isIncome: switchValue,
          balance: double.parse(transactionBalance),
        );
        myProvider.addTransaction(
          existCreditAccount: null,
          newTransaction: newTrans,
          existDebitAccount: account as DebitAccount,
        );
      } else {
        final newTrans = Transactions(
          id: timeAsID,
          description: description,
          name: transactionName,
          isIncome: switchValue,
          balance: -double.parse(transactionBalance),
        );
        myProvider.addTransaction(
          existCreditAccount: null,
          newTransaction: newTrans,
          existDebitAccount: account as DebitAccount,
        );
      }
    }
    widget.reFresh();
    Future.delayed(const Duration(milliseconds: 500))
        .then((value) => loading.hide());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.type;
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
            focusNode: _textFocusNode,
            controller: transactionNameController,
            textFieldHint: AppConfig.transactionName,
            textFieldLabel: AppConfig.transactionNameHint,
            kType: TextInputType.name,
          ),
          kTextField(
            controller: descriptionController,
            textFieldHint: AppConfig.transactionDescription,
            textFieldLabel: AppConfig.transactionDescriptionHint,
            kType: TextInputType.text,
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
                  AppConfig.transactionIsIncome,
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
