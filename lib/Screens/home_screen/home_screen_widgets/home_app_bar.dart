import 'package:flutter/material.dart';

import '../../../helper/app_config.dart';
import '../../account_widgets/add_credit_account_bottom_sheet.dart';

AppBar getAppBar({
  required BuildContext context,
  required int bottomNavIndex,
  required VoidCallback onRefresh,
}) {
  if (bottomNavIndex == 0) {
    return AppBar(
      elevation: 0,
      foregroundColor: AppConfig.secondaryColor,
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
                child: AddAccountBottomSheet(
                  onRefresh: () => onRefresh(),
                  type: AccountType.credit,
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
      elevation: 0,
      foregroundColor: AppConfig.secondaryColor,
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
                child: AddAccountBottomSheet(
                  onRefresh: () => onRefresh(),
                  type: AccountType.debit,
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
      elevation: 0,
      foregroundColor: AppConfig.secondaryColor,
      title: const Text(AppConfig.expenses),
    );
  } else {
    return AppBar(
      foregroundColor: AppConfig.secondaryColor,
      title: const Text(AppConfig.settings),
    );
  }
}
