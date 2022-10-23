import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:masrufat/Models/credit_account.dart';

import '../helper/app_config.dart';

enum AccountType {
  credit,
  debit,
}

class AccountsProvider with ChangeNotifier {
  final Box<CreditAccount> _dataBaseBox =
      Hive.box<CreditAccount>(AppConfig.dataBaseBoxName);
  List<CreditAccount> _userCreditAccount = [];

  Future<void> fetchDataBaseBox() async {
    log('test');
    _userCreditAccount = _dataBaseBox.values.toList().cast<CreditAccount>();
    log(_userCreditAccount.length.toString());
    notifyListeners();
  }

  Future<void> addCreditAccount({
    required CreditAccount userAccount,
  }) async {
    _userCreditAccount.add(userAccount);
    _dataBaseBox.add(userAccount);
    log(_userCreditAccount.toString());
    notifyListeners();
  }

  Box<CreditAccount> get getCreditAccountsBox => _dataBaseBox;
  List<CreditAccount> get getUserCreditAccounts => _userCreditAccount;
}
