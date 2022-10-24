import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:masrufat/Models/credit_account.dart';
import 'package:masrufat/Models/transaction.dart';

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
    _userCreditAccount = _dataBaseBox.values.toList().cast<CreditAccount>();
    log(_userCreditAccount.toString());
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

  Future<void> addTransaction({
    required CreditAccount existAccount,
    required Transactions newTransaction,
  }) async {
    existAccount.transactions.add(newTransaction);
    if (newTransaction.isIncome) {
      existAccount.balance += newTransaction.balance;
    } else {
      existAccount.balance -= newTransaction.balance;
    }

    //? save New Updated Account to DataBase
    existAccount.save();
  }

  Box<CreditAccount> get getCreditAccountsBox => _dataBaseBox;
  List<CreditAccount> get getUserCreditAccounts => _userCreditAccount;
}
