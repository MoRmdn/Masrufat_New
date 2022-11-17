import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Models/accounts.dart';
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
class AddAccountBottomSheet extends StatefulWidget {
  final VoidCallback onRefresh;
  final CreditAccount? crAccountToEdit;
  final DebitAccount? drAccountToEdit;
  final AccountType type;
  const AddAccountBottomSheet({
    Key? key,
    required this.onRefresh,
    required this.type,
    this.crAccountToEdit,
    this.drAccountToEdit,
  }) : super(key: key);

  @override
  State<AddAccountBottomSheet> createState() => _AddAccountBottomSheetState();
}

class _AddAccountBottomSheetState extends State<AddAccountBottomSheet> {
  final TextEditingController accNameController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();
  final _textFocusNode = FocusNode();

  SheetMood mood = SheetMood.add;
  final loading = LoadingScreen.instance();
  late Size dSize;
  late AccountsProvider myProvider;

  @override
  void initState() {
    _textFocusNode.requestFocus();
    myProvider = Provider.of<AccountsProvider>(context, listen: false);
    _checkAccount();
    if (mood == SheetMood.update) _updateMode();
    super.initState();
  }

  @override
  void dispose() {
    _textFocusNode.dispose();
    accNameController.dispose();
    balanceController.dispose();
    super.dispose();
  }

  void _updateMode() => setState(() {
        final crAccount = widget.crAccountToEdit;
        final drAccount = widget.drAccountToEdit;
        if (widget.type == AccountType.credit) {
          accNameController.text = crAccount!.name;
        } else {
          accNameController.text = drAccount!.name;
        }
      });

  void _onUpdateAccount() {
    loading.show(context: context, content: AppConfig.pleaseWait);
    final name = accNameController.text;
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

    if (widget.type == AccountType.credit) {
      CreditAccount account = widget.crAccountToEdit!;
      account = CreditAccount(
        id: account.id,
        name: name,
        transactions: account.transactions,
      );
      myProvider.updateAccount(
        updatedUserCreditAccount: account,
        updatedUserDebitAccount: null,
      );
    } else {
      DebitAccount account = widget.drAccountToEdit!;
      account = DebitAccount(
        id: account.id,
        name: name,
        transactions: account.transactions,
      );
      myProvider.updateAccount(
        updatedUserCreditAccount: null,
        updatedUserDebitAccount: account,
      );
    }

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
    if (widget.type == AccountType.credit) {
      final userCreditAccount = CreditAccount(
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
        userCreditAccount: userCreditAccount,
        userDebitAccount: null,
      );
    } else {
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
    }

    widget.onRefresh();
    Future.delayed(const Duration(milliseconds: 500))
        .then((value) => loading.hide());
    Navigator.of(context).pop();
  }

  void _checkAccount() =>
      widget.crAccountToEdit == null && widget.drAccountToEdit == null
          ? null
          : setState(() {
              mood = SheetMood.update;
            });

  @override
  Widget build(BuildContext context) {
    final type = widget.type;
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
                ? AppConfig.updateAccount
                : type == AccountType.credit
                    ? AppConfig.addCreditAccount
                    : AppConfig.addDebitAccount,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: dSize.height * 0.05),
          kTextField(
            focusNode: _textFocusNode,
            controller: accNameController,
            textFieldHint: AppConfig.accountNameHint,
            textFieldLabel: AppConfig.accountName,
            kType: TextInputType.name,
          ),
          if (mood == SheetMood.add)
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
                  : type == AccountType.credit
                      ? AppConfig.addCreditAccount
                      : AppConfig.addDebitAccount,
            ),
          ),
        ],
      ),
    );
  }
}
