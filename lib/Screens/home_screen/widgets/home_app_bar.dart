import 'package:flutter/material.dart';

import '../../../helper/app_config.dart';
import '../../credit_account_screen/account_widgets/add_credit_account_bottom_sheet.dart';
import '../../debit_account_screen/account_widgets/add_account_bottom_sheet.dart';

AppBar getAppBar({
  required BuildContext context,
  required int bottomNavIndex,
  required VoidCallback onRefresh,
  required VoidCallback askToLoad,
}) {
  if (bottomNavIndex == 0) {
    return AppBar(
      title: const Text(AppConfig.myAccount),
      actions: [
        IconButton(
          onPressed: () => showModalBottomSheet<void>(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: AddCreditAccountBottomSheet(
                  onRefresh: () => onRefresh(),
                ),
              );
            },
          ),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  } else if (bottomNavIndex == 1) {
    return AppBar(
      title: const Text(AppConfig.debit),
      actions: [
        IconButton(
          onPressed: () => showModalBottomSheet<void>(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: AddDebitAccountBottomSheet(
                  onRefresh: () => onRefresh(),
                ),
              );
            },
          ),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  } else if (bottomNavIndex == 2) {
    return AppBar(
      title: const Text(AppConfig.expenses),
    );
  } else {
    return AppBar(
      title: const Text(AppConfig.settings),
    );
  }
}
