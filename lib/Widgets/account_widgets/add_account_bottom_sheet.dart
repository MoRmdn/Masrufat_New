import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/credit_account.dart';
import '../../Models/transaction.dart';
import '../../Providers/accounts_provider.dart';
import '../../dialog/custom_generic_dialog.dart';
import '../../dialog/loading_screen_dialog.dart';
import '../../helper/app_config.dart';
import '../custom_text_field.dart';

class AddAccountBottomSheet extends StatefulWidget {
  final VoidCallback onRefresh;
  const AddAccountBottomSheet({Key? key, required this.onRefresh})
      : super(key: key);

  @override
  State<AddAccountBottomSheet> createState() => _AddAccountBottomSheetState();
}

class _AddAccountBottomSheetState extends State<AddAccountBottomSheet> {
  final TextEditingController accNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();
  final loading = LoadingScreen.instance();
  late Size dSize;
  late AccountsProvider myProvider;

  @override
  void initState() {
    myProvider = Provider.of<AccountsProvider>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    accNameController.dispose();
    descriptionController.dispose();
    balanceController.dispose();
    super.dispose();
  }

  void _onAddAccount() {
    loading.show(context: context, content: AppConfig.pleaseWait);
    final name = accNameController.text;
    final description = descriptionController.text;
    final balance = balanceController.text;
    if (name.isEmpty) {
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
    final userCreditAccount = CreditAccount(
      id: DateTime.now().toIso8601String(),
      name: name,
      description:
          description.isEmpty ? AppConfig.accountDescriptionHint : description,
      balance: double.parse(
        balance.isEmpty ? AppConfig.accountBalanceHint : balance,
      ),
      transactions: [
        Transactions.initial(
          id: DateTime.now().toIso8601String(),
          balance: double.parse(balance),
        )
      ],
    );

    myProvider.addCreditAccount(userAccount: userCreditAccount);
    widget.onRefresh();
    Future.delayed(const Duration(milliseconds: 500))
        .then((value) => loading.hide());
    Navigator.of(context).pop();
  }

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
            AppConfig.addCreditAccount,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: dSize.height * 0.05),
          kTextField(
            controller: accNameController,
            textFieldHint: AppConfig.accountNameHint,
            textFieldLabel: AppConfig.accountName,
          ),
          kTextField(
            controller: descriptionController,
            textFieldHint: AppConfig.accountDescriptionHint,
            textFieldLabel: AppConfig.accountDescription,
          ),
          kTextField(
            controller: balanceController,
            textFieldHint: AppConfig.accountBalanceHint,
            textFieldLabel: AppConfig.accountBalance,
          ),
          SizedBox(height: dSize.height * 0.05),
          ElevatedButton(
            onPressed: _onAddAccount,
            child: const Text(AppConfig.addAccount),
          )
        ],
      ),
    );
  }
}
