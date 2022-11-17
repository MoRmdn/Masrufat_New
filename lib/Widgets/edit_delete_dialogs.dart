import 'package:flutter/material.dart';
import 'package:masrufat/Models/accounts.dart';
import 'package:masrufat/Providers/accounts_provider.dart';

import '../Screens/account_widgets/add_account_bottom_sheet.dart';
import '../dialog/custom_generic_dialog.dart';
import '../helper/app_config.dart';

void showCustomDialog({
  required BuildContext ctx,
  required AccountsProvider myProvider,
  required VoidCallback onRefresh,
  required CreditAccount? crAccount,
  required DebitAccount? drAccount,
  required AccountType type,
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
                    child: AddAccountBottomSheet(
                      crAccountToEdit: crAccount,
                      drAccountToEdit: drAccount,
                      onRefresh: onRefresh,
                      type: type,
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
                        deleteUserDebitAccount:
                            type == AccountType.debit ? drAccount : null,
                        deleteUserCreditAccount:
                            type == AccountType.credit ? crAccount : null,
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
