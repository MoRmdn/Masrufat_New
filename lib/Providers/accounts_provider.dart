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
    _userExpenses();
    fetchBalance();
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
      _totalCreditBalance += userCreditAccount.balance;
      log('this is Credit Account You ADD $_userCreditAccounts');
    } else if (userDebitAccount != null) {
      _userDebitAccounts.add(userDebitAccount);
      _dataBaseBoxForDebit.put(userDebitAccount.id, userDebitAccount);
      _totalDebitBalance += userDebitAccount.balance;

      log('this is Debit Account You ADD $_userDebitAccounts');
    }
    _grandTotalBalance = _totalDebitBalance + _totalCreditBalance;
    notifyListeners();
  }

  Future<void> updateAccount({
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
      //? update Balance
      if (updatedUserCreditAccount.balance >
          _userCreditAccounts[oldAccountIndex].balance) {
        final newSurplus = updatedUserCreditAccount.balance -
            _userCreditAccounts[oldAccountIndex].balance;
        _totalCreditBalance += newSurplus;
      } else if (updatedUserCreditAccount.balance <
          _userCreditAccounts[oldAccountIndex].balance) {
        final shortage = updatedUserCreditAccount.balance -
            _userCreditAccounts[oldAccountIndex].balance;
        _totalCreditBalance -= shortage;
      }
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
      if (updatedUserDebitAccount.balance >
          _userDebitAccounts[oldAccountIndex].balance) {
        final newSurplus = updatedUserDebitAccount.balance -
            _userDebitAccounts[oldAccountIndex].balance;
        _totalCreditBalance += newSurplus;
      } else if (updatedUserDebitAccount.balance <
          _userDebitAccounts[oldAccountIndex].balance) {
        final shortage = updatedUserDebitAccount.balance -
            _userDebitAccounts[oldAccountIndex].balance;
        _totalCreditBalance += shortage;
      }
    }
    notifyListeners();
  }

  Future<void> deleteAccount({
    required CreditAccount? deleteUserCreditAccount,
    required DebitAccount? deleteUserDebitAccount,
  }) async {
    if (deleteUserCreditAccount != null) {
      _userCreditAccounts.remove(deleteUserCreditAccount);
      deleteUserCreditAccount.delete();
      _totalCreditBalance -= deleteUserCreditAccount.balance;
      log('deleteCreditAccount');
    } else if (deleteUserDebitAccount != null) {
      _userDebitAccounts.remove(deleteUserDebitAccount);
      deleteUserDebitAccount.delete();
      _totalDebitBalance -= deleteUserDebitAccount.balance;
      log('deleteDebitAccount');
    }
    _grandTotalBalance = _totalCreditBalance + _totalDebitBalance;
    notifyListeners();
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
    notifyListeners();
  }

  Future<void> updateTransaction({
    required CreditAccount? creditAccount,
    required DebitAccount? debitAccount,
    required Transactions newTransaction,
  }) async {
    if (creditAccount != null) {
      final index = creditAccount.transactions
          .indexWhere((element) => element.id == newTransaction.id);
      //? this is the old transaction
      final oldTransaction = creditAccount.transactions[index];
      creditAccount.balance -= oldTransaction.balance;
      creditAccount.balance += newTransaction.balance;
      creditAccount.transactions[index] = newTransaction;
      //? save New Updated Account to DataBase
      _dataBaseBoxForCredit.put(creditAccount.id, creditAccount);
    } else if (debitAccount != null) {
      final index = debitAccount.transactions
          .indexWhere((element) => element.id == newTransaction.id);
      //? this is the old transaction
      final oldTransaction = debitAccount.transactions[index];
      debitAccount.balance -= oldTransaction.balance;
      debitAccount.balance += newTransaction.balance;
      debitAccount.transactions[index] = newTransaction;
      //? save New Updated Account to DataBase
      _dataBaseBoxForDebit.put(debitAccount.id, debitAccount);
    }
    notifyListeners();
  }

  Future<void> fetchBalance() async {
    for (var element in _userCreditAccounts) {
      _totalCreditBalance += element.balance;
    }
    for (var element in _userDebitAccounts) {
      _totalDebitBalance += element.balance;
    }
    _grandTotalBalance = _totalDebitBalance + _totalCreditBalance;
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
      _totalCreditBalance -= currentTransaction.balance;
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
      _totalDebitBalance -= currentTransaction.balance;
      //? delete it
      debitAccount.transactions
          .removeWhere((element) => element.id == currentTransaction.id);
      //* save account
      _dataBaseBoxForDebit.put(debitAccount.id, debitAccount);
    }
    _grandTotalBalance = _totalDebitBalance + _totalCreditBalance;
    log('deleted Account');
    notifyListeners();
  }

  Future<void> _userExpenses() async {
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
    notifyListeners();
  }

  Future<void> deleteDataBase() async {
    _userCreditAccounts = [];
    _userDebitAccounts = [];
    _dataBaseBoxForCredit.deleteFromDisk();
    _dataBaseBoxForDebit.deleteFromDisk();
    notifyListeners();
  }

  Box<CreditAccount> get getCreditAccountsBox => _dataBaseBoxForCredit;
  List<CreditAccount> get getUserCreditAccounts => _userCreditAccounts;
  List<DebitAccount> get getUserDebitAccounts => _userDebitAccounts;
  List<Transactions> get getUserExpenses => _expensesTransaction;
  List<Transactions> get getUserExpensesPerMonth =>
      _expensesPerMonthTransaction;
  double get getTotalExpenses => _totalExpenses;
  double get getTotalPerMonthExpenses => _totalPerMonthExpenses;

  double get getTotalGrandBalance => _grandTotalBalance;
  double get getTotalCreditBalance => _totalCreditBalance;
  double get getTotalDebitBalance => _totalDebitBalance;
}
