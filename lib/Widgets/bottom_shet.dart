import 'package:flutter/material.dart';

import '../helper/app_config.dart';
import 'custom_text_field.dart';

Future<void> addAccountBottomSheet({
  required BuildContext context,
  required VoidCallback onPress,
  required Size dSize,
  required TextEditingController accNameController,
  required TextEditingController descriptionController,
  required TextEditingController balanceController,
}) async =>
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
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
                onPressed: onPress,
                child: const Text(AppConfig.addAccount),
              )
            ],
          ),
        );
      },
    );
