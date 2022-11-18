import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:masrufat/Models/accounts.dart';
import 'package:masrufat/Models/transaction.dart';
import 'package:masrufat/Providers/accounts_provider.dart';
import 'package:masrufat/dialog/custom_generic_dialog.dart';
import 'package:masrufat/dialog/loading_screen_dialog.dart';
import 'package:provider/provider.dart';

import '../../../Widgets/custom_text_field.dart';
import '../../../helper/app_config.dart';

class TransferMoney extends StatefulWidget {
  final CreditAccount crAccount;
  final VoidCallback reFresh;

  const TransferMoney({
    Key? key,
    required this.reFresh,
    required this.crAccount,
  }) : super(key: key);

  @override
  State<TransferMoney> createState() => _TransferMoneyState();
}

class _TransferMoneyState extends State<TransferMoney> {
  late AccountsProvider myProvider =
      Provider.of<AccountsProvider>(context, listen: false);
  late List<DebitAccount> debitAccounts = myProvider.getUserDebitAccounts;
  late List<CreditAccount> creditAccounts = myProvider.getUserCreditAccounts;
  late CreditAccount crAccount = widget.crAccount;
  final transactionNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final balanceController = TextEditingController();
  final _textFocusNode = FocusNode();
  final loading = LoadingScreen.instance();
  final List<String> accountsName = [
    "Choose Account",
  ];
  String timeAsID = DateTime.now().toIso8601String();
  String initial = "Choose Account";

  @override
  void initState() {
    for (var element in debitAccounts) {
      accountsName.add(element.name);
    }
    for (var element in creditAccounts) {
      if (element.name != crAccount.name) {
        accountsName.add(element.name);
      }
    }
    _textFocusNode.requestFocus();
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

  void _onAddTransaction() {
    loading.show(context: context, content: AppConfig.pleaseWait);
    final description = descriptionController.text;
    final transactionName = transactionNameController.text;
    final transactionBalance = balanceController.text;
    if (transactionName.isEmpty ||
        transactionBalance.isEmpty ||
        initial == "Choose Account") {
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

    DebitAccount? debitAccount = debitAccounts.firstWhereOrNull(
      (element) => element.name == initial,
    );
    CreditAccount? creditAccountToTransfer = creditAccounts.firstWhereOrNull(
      (element) => element.name == initial,
    );
    if (debitAccount != null) {
      final debitTrans = Transactions(
        id: timeAsID,
        name: transactionName,
        description: description,
        isIncome: true,
        balance: double.parse(transactionBalance),
        transferFrom: crAccount,
      );
      final creditTrans = Transactions(
        id: timeAsID,
        description: description,
        name: transactionName,
        isIncome: false,
        balance: -double.parse(transactionBalance),
        transferTo: debitAccount,
      );
      myProvider.addTransaction(
        existCreditAccount: crAccount,
        newTransaction: creditTrans,
        existDebitAccount: null,
      );
      myProvider.addTransaction(
        existCreditAccount: null,
        newTransaction: debitTrans,
        existDebitAccount: debitAccount,
      );
    } else {
      final creditTransTo = Transactions(
        id: timeAsID,
        name: transactionName,
        description: description,
        isIncome: true,
        balance: double.parse(transactionBalance),
        transferTo: creditAccountToTransfer,
      );
      final creditTransFrom = Transactions(
        id: timeAsID,
        description: description,
        name: transactionName,
        isIncome: false,
        balance: -double.parse(transactionBalance),
        transferFrom: crAccount,
      );
      myProvider.addTransaction(
        existCreditAccount: crAccount,
        newTransaction: creditTransFrom,
        existDebitAccount: null,
      );
      myProvider.addTransaction(
        existCreditAccount: creditAccountToTransfer,
        newTransaction: creditTransTo,
        existDebitAccount: null,
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
            AppConfig.transferMoney,
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
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppConfig.transferMoneyFrom,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  crAccount.name,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppConfig.transferMoneyTo,
                  style: Theme.of(context).textTheme.headline6,
                ),
                DropdownButton<String>(
                  value: initial,
                  items: accountsName.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      initial = value!;
                    });
                  },
                )
              ],
            ),
          ),
          SizedBox(height: dSize.height * 0.05),
          ElevatedButton(
            onPressed: _onAddTransaction,
            child: const Text(
              AppConfig.transferMoney,
            ),
          )
        ],
      ),
    );
  }
}
