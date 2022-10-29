import 'package:flutter/material.dart';
import 'package:masrufat/Models/debit_account.dart';
import 'package:masrufat/Providers/accounts_provider.dart';

import '../Models/credit_account.dart';
import '../Screens/credit_account_screen/account_widgets/add_credit_account_bottom_sheet.dart';
import '../Screens/debit_account_screen/account_widgets/add_debit_account_bottom_sheet.dart';
import '../dialog/custom_generic_dialog.dart';
import '../helper/app_config.dart';

void showCustomDialog({
  required BuildContext ctx,
  required AccountsProvider myProvider,
  required VoidCallback onRefresh,
  CreditAccount? creditAccount,
  DebitAccount? debitAccount,
}) {
  showDialog(
    context: ctx,
    builder: (_) {
      return SimpleDialog(
        title: const Text('Select Option'),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(ctx).pop();
              showModalBottomSheet<void>(
                isScrollControlled: true,
                context: ctx,
                builder: (_) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(ctx).viewInsets.bottom,
                    ),
                    child: debitAccount == null
                        ? AddCreditAccountBottomSheet(
                            accountToEdit: creditAccount,
                            onRefresh: onRefresh,
                          )
                        : AddDebitAccountBottomSheet(
                            accountToEdit: debitAccount,
                            onRefresh: onRefresh,
                          ),
                  );
                },
              );
            },
            child: const Text('Edit'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(ctx).pop();
              customGenericDialog(
                context: ctx,
                title: AppConfig.dialogConfirmationTitle,
                content: AppConfig.dialogConfirmationDelete,
                dialogOptions: () => {
                  'No': null,
                  'Yes': () => myProvider
                          .deleteAccount(
                        deleteUserCreditAccount: creditAccount,
                        deleteUserDebitAccount: debitAccount,
                      )
                          .then((value) {
                        Navigator.of(ctx).popUntil((route) => route.isFirst);
                        onRefresh();
                      })
                },
              );
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
  onRefresh();
}
