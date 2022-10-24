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
    _dataBaseBox.put(userAccount.id, userAccount);
    log(_userCreditAccount.toString());
    notifyListeners();
  }

  Future<void> updateCreditAccount({
    required CreditAccount updatedUserAccount,
  }) async {
    final oldAccountIndex = _userCreditAccount.indexWhere(
      (element) => element.id == updatedUserAccount.id,
    );
    _userCreditAccount[oldAccountIndex] = updatedUserAccount;

    log(updatedUserAccount.balance.toString());
    //? save New Updated Account to DataBase
    _dataBaseBox.put(updatedUserAccount.id, updatedUserAccount);
    notifyListeners();
  }

  Future<void> deleteCreditAccount({
    required CreditAccount updatedUserAccount,
  }) async {
    log('deleteCreditAccount');
    _userCreditAccount.remove(updatedUserAccount);
    updatedUserAccount.delete();
  }

  Future<void> addTransaction({
    required CreditAccount existAccount,
    required Transactions newTransaction,
  }) async {
    //? add transaction to accountTransactions
    existAccount.transactions.add(newTransaction);

    //? add transactionBalance to total balance of the account
    existAccount.balance += newTransaction.balance;

    //? save New Updated Account to DataBase
    _dataBaseBox.put(existAccount.id, existAccount);
  }

  Future<void> updateTransaction({
    required CreditAccount existAccount,
    required Transactions newTransaction,
  }) async {
    final index = existAccount.transactions
        .indexWhere((element) => element.id == newTransaction.id);
    //? this is the old transaction
    final oldTransaction = existAccount.transactions[index];
    existAccount.balance -= oldTransaction.balance;
    ////
    existAccount.balance += newTransaction.balance;
    existAccount.transactions[index] = newTransaction;
    //? save New Updated Account to DataBase
    _dataBaseBox.put(existAccount.id, existAccount);
  }

  Future<void> deleteTransaction({
    required int index,
    required CreditAccount account,
  }) async {
    log('deleted');
    //? transaction i want to delete
    final currentTransaction = account.transactions[index];

    //? subtract transaction value from total balance
    account.balance -= currentTransaction.balance;
    //? delete it
    account.transactions
        .removeWhere((element) => element.id == currentTransaction.id);
    //* save account
    _dataBaseBox.put(account.id, account);
  }

  Box<CreditAccount> get getCreditAccountsBox => _dataBaseBox;
  List<CreditAccount> get getUserCreditAccounts => _userCreditAccount;
}
