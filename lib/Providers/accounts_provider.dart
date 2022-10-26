import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:masrufat/Models/credit_account.dart';
import 'package:masrufat/Models/debit_account.dart';
import 'package:masrufat/Models/transaction.dart';

import '../helper/app_config.dart';

enum AccountType {
  credit,
  debit,
}

class AccountsProvider with ChangeNotifier {
  final Box<CreditAccount> _dataBaseBoxForCredit =
      Hive.box<CreditAccount>(AppConfig.dataBaseBoxForCredit);
  final Box<DebitAccount> _dataBaseBoxForDebit =
      Hive.box<DebitAccount>(AppConfig.dataBaseBoxForDebit);
  List<CreditAccount> _userCreditAccounts = [];
  List<DebitAccount> _userDebitAccounts = [];
  final List<Transactions> _expensesTransaction = [];
  final List<Transactions> _expensesPerMonthTransaction = [];
  //? debit + credit Balance
  double _grandTotalBalance = 0.0;
  double _totalCreditBalance = 0.0;
  double _totalDebitBalance = 0.0;
  double _totalExpenses = 0.0;
  double _totalPerMonthExpenses = 0.0;

  Future<void> fetchDataBaseBox() async {
    _userCreditAccounts =
        _dataBaseBoxForCredit.values.toList().cast<CreditAccount>();
    _userDebitAccounts =
        _dataBaseBoxForDebit.values.toList().cast<DebitAccount>();
    log('this is your Credit Accounts $_userCreditAccounts');
    log('this is your Debit Accounts $_userDebitAccounts');
    notifyListeners();
  }

  Future<void> addAccount({
    required CreditAccount? userCreditAccount,
    required DebitAccount? userDebitAccount,
  }) async {
    if (userCreditAccount != null) {
      //? add account to Memory
      _userCreditAccounts.add(userCreditAccount);
      //? add account to Local DataBase
      _dataBaseBoxForCredit.put(userCreditAccount.id, userCreditAccount);
      log('this is Credit Account You ADD $_userCreditAccounts');
    } else if (userDebitAccount != null) {
      _userDebitAccounts.add(userDebitAccount);
      _dataBaseBoxForDebit.put(userDebitAccount.id, userDebitAccount);
      log('this is Debit Account You ADD $_userDebitAccounts');
    }
    notifyListeners();
  }

  Future<void> updateCreditAccount({
    required CreditAccount? updatedUserCreditAccount,
    required DebitAccount? updatedUserDebitAccount,
  }) async {
    if (updatedUserCreditAccount != null) {
      //? get old account
      final oldAccountIndex = _userCreditAccounts.indexWhere(
        (element) => element.id == updatedUserCreditAccount.id,
      );
      //? assign New Value to it in memory
      _userCreditAccounts[oldAccountIndex] = updatedUserCreditAccount;

      //? save New Updated Account to DataBase
      _dataBaseBoxForCredit.put(
        updatedUserCreditAccount.id,
        updatedUserCreditAccount,
      );
      log('updatedUserCreditAccount');
    } else if (updatedUserDebitAccount != null) {
      //? get old account
      final oldAccountIndex = _userDebitAccounts.indexWhere(
        (element) => element.id == updatedUserDebitAccount.id,
      );
      //? assign New Value to it in memory
      _userDebitAccounts[oldAccountIndex] = updatedUserDebitAccount;

      //? save New Updated Account to DataBase
      _dataBaseBoxForDebit.put(
        updatedUserDebitAccount.id,
        updatedUserDebitAccount,
      );
      log('updatedUserDebitAccount');
    }
    notifyListeners();
  }

  Future<void> deleteCreditAccount({
    required CreditAccount? deleteUserCreditAccount,
    required DebitAccount? deleteUserDebitAccount,
  }) async {
    if (deleteUserCreditAccount != null) {
      _userCreditAccounts.remove(deleteUserCreditAccount);
      deleteUserCreditAccount.delete();
      log('deleteCreditAccount');
    } else if (deleteUserDebitAccount != null) {
      _userDebitAccounts.remove(deleteUserDebitAccount);
      deleteUserDebitAccount.delete();
      log('deleteDebitAccount');
    }
  }

  Future<void> addTransaction({
    required CreditAccount? existCreditAccount,
    required DebitAccount? existDebitAccount,
    required Transactions newTransaction,
  }) async {
    if (existCreditAccount != null) {
      //? add transaction to accountTransactions
      existCreditAccount.transactions.add(newTransaction);

      //? add transactionBalance to total balance of the account
      existCreditAccount.balance += newTransaction.balance;

      //? save New Updated Account to DataBase
      _dataBaseBoxForCredit.put(existCreditAccount.id, existCreditAccount);
    } else if (existDebitAccount != null) {
      existDebitAccount.transactions.add(newTransaction);
      existDebitAccount.balance += newTransaction.balance;
      _dataBaseBoxForDebit.put(existDebitAccount.id, existDebitAccount);
    }
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
    _dataBaseBoxForCredit.put(existAccount.id, existAccount);
  }

  Future<void> deleteTransaction({
    required int index,
    required CreditAccount? creditAccount,
    required DebitAccount? debitAccount,
  }) async {
    if (creditAccount != null) {
      //? transaction i want to delete
      final currentTransaction = creditAccount.transactions[index];

      //? subtract transaction value from total balance
      creditAccount.balance -= currentTransaction.balance;
      //? delete it
      creditAccount.transactions
          .removeWhere((element) => element.id == currentTransaction.id);
      //* save account
      _dataBaseBoxForCredit.put(creditAccount.id, creditAccount);
    } else if (debitAccount != null) {
      //? transaction i want to delete
      final currentTransaction = debitAccount.transactions[index];

      //? subtract transaction value from total balance
      debitAccount.balance -= currentTransaction.balance;
      //? delete it
      debitAccount.transactions
          .removeWhere((element) => element.id == currentTransaction.id);
      //* save account
      _dataBaseBoxForDebit.put(debitAccount.id, debitAccount);
    }
    log('deleted Account');
  }

  Future<void> userExpenses() async {
    for (var element in _userCreditAccounts) {
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
    for (var element in _userCreditAccounts) {
      _totalCreditBalance += element.balance;
    }
    for (var element in _userDebitAccounts) {
      _totalDebitBalance += element.balance;
    }
    _grandTotalBalance = _totalDebitBalance + _totalCreditBalance;
    notifyListeners();
  }

  Future<void> deleteDataBase() async {
    _userCreditAccounts = [];
    _dataBaseBoxForCredit.deleteFromDisk();
  }

  Box<CreditAccount> get getCreditAccountsBox => _dataBaseBoxForCredit;
  List<CreditAccount> get getUserCreditAccounts => _userCreditAccounts;
  List<Transactions> get getUserExpenses => _expensesTransaction;
  List<Transactions> get getUserExpensesPerMonth =>
      _expensesPerMonthTransaction;
  double get getTotalExpenses => _totalExpenses;
  double get getTotalPerMonthExpenses => _totalPerMonthExpenses;

  double get getTotalGrandBalance => _grandTotalBalance;
  double get getTotalCreditBalance => _totalCreditBalance;
  double get getTotalDebitBalance => _totalDebitBalance;
}
