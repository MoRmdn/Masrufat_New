import 'package:flutter/material.dart';
import 'package:masrufat/helper/app_config.dart';

import '../Screens/account_widgets/add_credit_account_bottom_sheet.dart';

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
                    child: AddAccountBottomSheet(
                      onRefresh: onRefresh,
                      type: AccountType.credit,
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
                    child: AddAccountBottomSheet(
                      onRefresh: onRefresh,
                      type: AccountType.debit,
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
