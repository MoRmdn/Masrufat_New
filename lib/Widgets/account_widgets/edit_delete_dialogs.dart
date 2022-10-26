import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:masrufat/Providers/accounts_provider.dart';

import '../../Models/credit_account.dart';
import '../../dialog/custom_generic_dialog.dart';
import '../../helper/app_config.dart';
import 'add_account_bottom_sheet.dart';

void showCustomDialog({
  required BuildContext context,
  required AccountsProvider myProvider,
  required VoidCallback onRefresh,
  CreditAccount? account,
}) {
  log('test');
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: const Text('Select Option'),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context).pop();
              showModalBottomSheet<void>(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: AddAccountBottomSheet(
                      accountToEdit: account,
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
              Navigator.of(context).pop();
              customGenericDialog(
                context: context,
                title: AppConfig.dialogConfirmationTitle,
                content: AppConfig.dialogConfirmationDelete,
                dialogOptions: () => {
                  'No': null,
                  'Yes': () => myProvider.deleteCreditAccount(
                        updatedUserAccount: account!,
                      ),
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
  Navigator.of(context).pop();
}
