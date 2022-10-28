import 'package:flutter/material.dart';
import 'package:masrufat/Models/debit_account.dart';
import 'package:provider/provider.dart';

import '../../../Models/transaction.dart';
import '../../../Providers/accounts_provider.dart';
import '../../../Widgets/custom_text_field.dart';
import '../../../dialog/custom_generic_dialog.dart';
import '../../../dialog/loading_screen_dialog.dart';
import '../../../helper/app_config.dart';

enum SheetMood {
  add,
  update,
}

// ignore: must_be_immutable
class AddDebitAccountBottomSheet extends StatefulWidget {
  final VoidCallback onRefresh;
  DebitAccount? accountToEdit;
  AddDebitAccountBottomSheet({
    Key? key,
    required this.onRefresh,
    this.accountToEdit,
  }) : super(key: key);

  @override
  State<AddDebitAccountBottomSheet> createState() =>
      _AddDebitAccountBottomSheetState();
}

class _AddDebitAccountBottomSheetState
    extends State<AddDebitAccountBottomSheet> {
  final TextEditingController accNameController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();
  SheetMood mood = SheetMood.add;
  final loading = LoadingScreen.instance();
  late Size dSize;
  late AccountsProvider myProvider;

  @override
  void initState() {
    myProvider = Provider.of<AccountsProvider>(context, listen: false);
    _checkAccount();
    if (mood == SheetMood.update) _updateMode();
    super.initState();
  }

  @override
  void dispose() {
    accNameController.dispose();
    balanceController.dispose();
    super.dispose();
  }

  void _updateMode() => setState(() {
        accNameController.text = widget.accountToEdit!.name;
        balanceController.text = myProvider.getTotalDebitBalance.toString();
      });

  void _onUpdateAccount() {
    loading.show(context: context, content: AppConfig.pleaseWait);
    final name = accNameController.text;

    final balance = double.parse(balanceController.text);
    if (name.isEmpty) {
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
      Future.delayed(const Duration(milliseconds: 500))
          .then((value) => loading.hide());
      return;
    }

    List<Transactions> transactionList = widget.accountToEdit!.transactions;
    transactionList.add(
      Transactions(
        id: DateTime.now().toIso8601String(),
        name: 'EditedBalance',
        description: 'EditedBalance',
        isIncome: false,
        balance: balance,
      ),
    );
    widget.accountToEdit = DebitAccount(
      id: widget.accountToEdit!.id,
      name: name,
      transactions: transactionList,
    );
    myProvider.updateAccount(
      updatedUserCreditAccount: null,
      updatedUserDebitAccount: widget.accountToEdit!,
    );
    //

    widget.onRefresh();
    Future.delayed(const Duration(milliseconds: 500))
        .then((value) => loading.hide());
    Navigator.of(context).pop();
  }

  void _onAddAccount() {
    loading.show(context: context, content: AppConfig.pleaseWait);
    final name = accNameController.text;
    final balance = balanceController.text;
    if (name.isEmpty) {
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
    final userDebitAccount = DebitAccount(
      id: DateTime.now().toIso8601String(),
      name: name,
      transactions: [
        Transactions.initial(
          id: DateTime.now().toIso8601String(),
          balance: double.parse(
            balance.isEmpty ? '0.0' : balance,
          ),
        )
      ],
    );

    myProvider.addAccount(
      userCreditAccount: null,
      userDebitAccount: userDebitAccount,
    );
    widget.onRefresh();
    Future.delayed(const Duration(milliseconds: 500))
        .then((value) => loading.hide());
    Navigator.of(context).pop();
  }

  void _checkAccount() => widget.accountToEdit == null
      ? null
      : setState(() {
          mood = SheetMood.update;
        });

  @override
  Widget build(BuildContext context) {
    dSize = MediaQuery.of(context).size;
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
            mood == SheetMood.update
                ? AppConfig.updateAccount + widget.accountToEdit!.name
                : AppConfig.addDebitAccount,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: dSize.height * 0.05),
          kTextField(
            controller: accNameController,
            textFieldHint: AppConfig.accountNameHint,
            textFieldLabel: AppConfig.accountName,
            kType: TextInputType.name,
          ),
          kTextField(
            controller: balanceController,
            textFieldHint: AppConfig.accountBalanceHint,
            textFieldLabel: AppConfig.accountBalance,
            kType: TextInputType.number,
          ),
          SizedBox(height: dSize.height * 0.05),
          ElevatedButton(
            onPressed:
                mood == SheetMood.update ? _onUpdateAccount : _onAddAccount,
            child: Text(
              mood == SheetMood.update
                  ? AppConfig.updateAccount
                  : AppConfig.addDebitAccount + accNameController.text,
            ),
          )
        ],
      ),
    );
  }
}
