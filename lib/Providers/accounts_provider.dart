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
  final List<Transactions> _expensesTransaction = [];
  final List<Transactions> _expensesPerMonthTransaction = [];
  double grandTotal = 0.0;
  double _totalExpenses = 0.0;
  double _totalPerMonthExpenses = 0.0;
  double _grandTotalBalance = 0.0;
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

  Future<void> userExpenses() async {
    for (var element in _userCreditAccount) {
      for (var element in element.transactions) {
        if (element.isIncome == false) {
          _totalExpenses += element.balance;
          _expensesTransaction.add(element);
          DateTime date = DateTime.parse(element.id);
          //* check if this transaction happen this month or not
          if (date.month == DateTime.now().month) {
            _totalPerMonthExpenses += element.balance;
            _expensesPerMonthTransaction.add(element);
          }
        }
      }
    }
  }

  Future<void> userTotalBlanca() async {
    for (var element in _userCreditAccount) {
      _grandTotalBalance += element.balance;
    }
    notifyListeners();
  }

  Future<void> deleteDataBase() async {
    _userCreditAccount = [];
    _dataBaseBox.deleteFromDisk();
  }

  Box<CreditAccount> get getCreditAccountsBox => _dataBaseBox;
  List<CreditAccount> get getUserCreditAccounts => _userCreditAccount;
  List<Transactions> get getUserExpenses => _expensesTransaction;
  List<Transactions> get getUserExpensesPerMonth =>
      _expensesPerMonthTransaction;
  double get getTotalExpenses => _totalExpenses;
  double get getTotalPerMonthExpenses => _totalPerMonthExpenses;
  double get getGrandTotalBalance => _grandTotalBalance;
}
