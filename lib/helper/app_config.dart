import 'dart:math' as math show Random;

import 'package:flutter/material.dart' show Color, Colors, Widget;

import '../Widgets/iterable_list_view.dart';

enum LoginErrorHandler {
  invalidData,
}

enum AccountType {
  debit,
  credit,
}

enum AuthPageController {
  loginPage,
  signUpPage,
  forgetPassword,
}

extension ToListView<T> on Iterable<T> {
  Widget toListView() => IterableListView(
        iterableList: this,
      );
}

//* add this method to Iterable Class
extension GetRandomValue<T> on Iterable<T> {
  T getRandomValue() => elementAt(math.Random().nextInt(length));
}

class AppConfig {
  static const Color primaryColor = Colors.indigo;
  static const Color secondaryColor = Colors.amber;
  static const Color authColors = Colors.white;
  static const double textFieldSized = 0.8;
  static const Iterable<Color> cardColorList = [
    Colors.teal,
    Colors.blue,
    Colors.cyan,
    Colors.deepPurple,
    Colors.tealAccent,
    Colors.teal,
    Colors.blue,
    Colors.cyan,
    Colors.deepPurple,
    Colors.tealAccent,
    Colors.teal,
    Colors.blue,
    Colors.cyan,
    Colors.deepPurple,
    Colors.tealAccent,
  ];
  //? appTitle
  static const appTitle = 'Masrufat';

  //? Auth Screen ==>> routeName

  static const homeRouteName = '/homeScreen';
  static const navigationRouteName = '/navigationScreen';
  static const accountRouteName = '/navigationScreen';

  static const addCreditAccount = 'Add Credit Account';
  static const addDebitAccount = 'Add Debit Account';
  static const updateAccount = 'Update Account :';
  static const addTransAction = 'Add Transaction';

  static const updateTransAction = 'Update Transaction';
  static const accountName = 'Account Name';
  static const accountNameHint = 'Salary or CIB';
  static const accountDescription = 'Account Description';
  static const accountDescriptionHint = 'This is my Salary Account';
  static const accountBalance = 'Account Balance';
  static const accountBalanceHint = '500.00';
  static const addAccount = 'Add Account';
  static const myAccount = 'My Accounts';
  static const account = 'Credit';
  static const debit = 'Debit';
  static const expenses = 'Expenses';
  static const totalBalance = 'Total Balance';
  static const grandTotalBalance = 'Grand Total Balance';

  static const deleteDataBase = 'Delete All Accounts';
  static const settings = 'Settings';
  static const rateUs = 'Rate Us';
  static const share = 'Share';
  static const support = 'Support';
  static const termsAndConditions = 'Terms and Conditions';

  static const transferMoney = 'Transfer Money';
  static const transferMoneyFrom = 'Transfer From';
  static const transferMoneyTo = 'Transfer To';

  static const transactionName = 'Transaction Name ';

  static const transactionNameHint = 'Transaction Name';
  static const transactionDescription = 'Transaction Description ';
  static const transactionDescriptionHint = 'Transaction Description';
  static const transactionBalance = 'Transaction Balance';
  static const transactionBalanceHint = '500.00';
  static const transactionEditedBalance = 'EditedBalance';
  static const transactionIsIncome = 'Income';

  //? Dialog error info
  static const dialogErrorTitle = 'Error';
  static const dialogErrorEmptyAccountName = 'Please, Enter Valid Data';
  static const dialogConfirmationTitle = 'Confirmation';
  static const dialogConfirmationDelete =
      'are u sure you want to delete this account ?';
  static const dialogConfirmationDeleteDataBase =
      'are u sure you want to delete all Data on Application ? \nyou won\'t be able to retrieve it';
  static const dataBaseBoxForCredit = 'myAccounts';
  static const dataBaseBoxForDebit = 'myDebitAccounts';

  static const delete = 'Delete';
  static const edit = 'Edit';
  static const transfer = 'Transfer';

  //? assets
  static const loginBackgroundImage = 'assets/images/2.png';
  static const signUpBackgroundImage = 'assets/images/1.png';
  static const forgetPasswordBackgroundImage = 'assets/images/3.png';
  static const loadingSvg = 'assets/svg/loading.svg';
  static const loadingGif = 'assets/gif/loading.gif';
  static const loadingColorizedGif = 'assets/gif/loading_colorized.gif';
  static const loadingFaceGif = 'assets/gif/loading_face.gif';
  static const loadingAndDone = 'assets/gif/loading_and_done.gif';

  //? generic
  static const pleaseWait = 'Please wait...';
  static const ok = 'OK';
  static const homePage = 'Home Page';
}
