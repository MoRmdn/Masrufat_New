import 'package:flutter/material.dart';

import '../Screens/credit_account_screen/account_widgets/add_credit_account_bottom_sheet.dart';
import '../Screens/debit_account_screen/account_widgets/add_debit_account_bottom_sheet.dart';

Future<void> loadAccountCreation({
  required BuildContext context,
  required VoidCallback onRefresh,
}) async {
  await showDialog(
    context: context,
    builder: (_) {
      return SimpleDialog(
        title: const Text('Select AccountType'),
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
                    child: AddCreditAccountBottomSheet(
                      onRefresh: onRefresh,
                    ),
                  );
                },
              );
            },
            child: const Text('Credit Account'),
          ),
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
                    child: AddDebitAccountBottomSheet(
                      onRefresh: onRefresh,
                    ),
                  );
                },
              );
            },
            child: const Text('Debit Account'),
          ),
        ],
      );
    },
  );
}
