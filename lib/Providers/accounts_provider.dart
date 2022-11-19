import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:masrufat/Models/accounts.dart';
import 'package:masrufat/Models/transaction.dart';

import '../helper/app_config.dart';

class AccountsProvider with ChangeNotifier {
  final Box<CreditAccount> _dataBaseBoxForCredit =
      Hive.box<CreditAccount>(AppConfig.dataBaseBoxForCredit);
  final Box<DebitAccount> _dataBaseBoxForDebit =
      Hive.box<DebitAccount>(AppConfig.dataBaseBoxForDebit);
  List<CreditAccount> _userCreditAccounts = [];
  List<DebitAccount> _userDebitAccounts = [];
  List<Transactions> _expensesTransaction = [];
  List<Transactions> _expensesThisMonthTransaction = [];
  //? debit + credit Balance
  double _grandTotalBalance = 0.0;
  double _totalCreditBalance = 0.0;
  double _totalDebitBalance = 0.0;
  double _totalExpenses = 0.0;
  double _totalThisMonthExpenses = 0.0;

  Future<void> fetchDataBaseBox() async {
    _userCreditAccounts =
        _dataBaseBoxForCredit.values.toList().cast<CreditAccount>();
    _userDebitAccounts =
        _dataBaseBoxForDebit.values.toList().cast<DebitAccount>();
    _userCreditExpenses();
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
      fetchCreditBalance();
      log('this is Credit Account You ADD $_userCreditAccounts');
    } else if (userDebitAccount != null) {
      _userDebitAccounts.add(userDebitAccount);
      _dataBaseBoxForDebit.put(userDebitAccount.id, userDebitAccount);
      fetchDebitBalance();
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
      fetchBalance();
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

  Future<void> deleteAccount({
    CreditAccount? deleteUserCreditAccount,
    DebitAccount? deleteUserDebitAccount,
  }) async {
    if (deleteUserCreditAccount != null) {
      _userCreditAccounts.remove(deleteUserCreditAccount);
      deleteUserCreditAccount.delete();
      fetchCreditBalance();
      log('deleteCreditAccount');
    } else if (deleteUserDebitAccount != null) {
      _userDebitAccounts.remove(deleteUserDebitAccount);
      deleteUserDebitAccount.delete();
      fetchDebitBalance();
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
      _totalCreditBalance += newTransaction.balance;
      //? save New Updated Account to DataBase
      _dataBaseBoxForCredit.put(existCreditAccount.id, existCreditAccount);
    } else if (existDebitAccount != null) {
      existDebitAccount.transactions.add(newTransaction);
      _totalDebitBalance += newTransaction.balance;
      _dataBaseBoxForDebit.put(existDebitAccount.id, existDebitAccount);
    }
    if (!newTransaction.isIncome) {
      _userCreditExpenses();
    }
    _grandTotalBalance = _totalCreditBalance + _totalDebitBalance;
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
      creditAccount.transactions[index] = newTransaction;
      fetchCreditBalance();
      //? save New Updated Account to DataBase
      _dataBaseBoxForCredit.put(creditAccount.id, creditAccount);
    } else if (debitAccount != null) {
      final index = debitAccount.transactions
          .indexWhere((element) => element.id == newTransaction.id);
      //? this is the old transaction
      debitAccount.transactions[index] = newTransaction;
      fetchDebitBalance();
      //? save New Updated Account to DataBase
      _dataBaseBoxForDebit.put(debitAccount.id, debitAccount);
    }
    if (!newTransaction.isIncome) {
      _userCreditExpenses();
    }
    notifyListeners();
  }

  Future<void> fetchBalance() async {
    fetchCreditBalance();
    fetchDebitBalance();
    _grandTotalBalance = _totalDebitBalance + _totalCreditBalance;
  }

  Future<void> fetchCreditBalance() async {
    double balance = 0;
    for (var element in _userCreditAccounts) {
      for (var trans in element.transactions) {
        balance += trans.balance;
      }
    }
    _totalCreditBalance = balance;
    _grandTotalBalance = _totalDebitBalance + _totalCreditBalance;
  }

  Future<void> fetchDebitBalance() async {
    double balance = 0;
    for (var element in _userDebitAccounts) {
      for (var trans in element.transactions) {
        balance += trans.balance;
      }
    }
    _totalDebitBalance = balance;
    _grandTotalBalance = _totalDebitBalance + _totalCreditBalance;
  }

  Future<void> deleteTransaction({
    required int transIndex,
    required int accountIndex,
    required AccountType type,
    required Transactions trans,
  }) async {
    if (type == AccountType.credit) {
      final crAccount = _userCreditAccounts[accountIndex];
      crAccount.transactions.removeAt(transIndex);

      _dataBaseBoxForCredit.put(crAccount.id, crAccount);
      fetchCreditBalance();
    } else {
      final drAccount = _userDebitAccounts[accountIndex];
      drAccount.transactions.removeAt(transIndex);

      _dataBaseBoxForDebit.put(drAccount.id, drAccount);
      fetchDebitBalance();
    }
    notifyListeners();
  }

  Future<void> _userCreditExpenses() async {
    List<Transactions> expensesNew = [];
    List<Transactions> expensesNewThisMonth = [];
    double expensesTotal = 0;
    double expensesThisMonth = 0;
    for (var element in _userCreditAccounts) {
      for (var element in element.transactions) {
        if (!element.isIncome) {
          expensesTotal += element.balance;
          expensesNew.add(element);
          DateTime date = DateTime.parse(element.id);
          //* check if this transaction happen this month or not
          if (date.month == DateTime.now().month) {
            expensesThisMonth += element.balance;
            expensesNewThisMonth.add(element);
          }
        }
      }
    }
    _totalExpenses = expensesTotal;
    _totalThisMonthExpenses = expensesThisMonth;
    _expensesTransaction = expensesNew;
    _expensesThisMonthTransaction = expensesNewThisMonth;
    notifyListeners();
  }

  Future<void> deleteDataBase() async {
    _grandTotalBalance = 0.0;
    _totalCreditBalance = 0.0;
    _totalDebitBalance = 0.0;
    _totalExpenses = 0.0;
    _totalThisMonthExpenses = 0.0;
    _expensesTransaction = [];
    _expensesThisMonthTransaction = [];
    _userCreditAccounts = [];
    _userDebitAccounts = [];
    _dataBaseBoxForCredit.deleteFromDisk();
    _dataBaseBoxForDebit.deleteFromDisk();

    //? debit + credit Balance

    notifyListeners();
  }

  Box<CreditAccount> get getCreditAccountsBox => _dataBaseBoxForCredit;
  List<CreditAccount> get getUserCreditAccounts => _userCreditAccounts;
  List<DebitAccount> get getUserDebitAccounts => _userDebitAccounts;
  List<Transactions> get getUserExpenses => _expensesTransaction;
  List<Transactions> get getUserExpensesPerMonth =>
      _expensesThisMonthTransaction;
  double get getTotalExpenses => _totalExpenses;
  double get getTotalPerMonthExpenses => _totalThisMonthExpenses;

  double get getTotalGrandBalance => _grandTotalBalance;
  double get getTotalCreditBalance => _totalCreditBalance;
  double get getTotalDebitBalance => _totalDebitBalance;
}
