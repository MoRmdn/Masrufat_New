import 'package:flutter/material.dart' show Color, Colors, Widget;

import '../Widgets/iterable_list_view.dart';

enum LoginErrorHandler {
  invalidData,
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

class AppConfig {
  static const Color primaryColor = Colors.indigo;
  static const Color secondaryColor = Colors.amber;
  static const Color authColors = Colors.white;
  static const double textFieldSized = 0.8;
  static const List<Color> cardColorList = [
    Colors.teal,
    Colors.blue,
    Colors.cyan,
    Colors.deepPurple,
    Colors.tealAccent
  ];
  //? appTitle
  static const appTitle = 'Masrufat';

  //? Auth Screen ==>> routeName

  static const homeRouteName = '/homeScreen';
  static const navigationRouteName = '/navigationScreen';
  static const accountRouteName = '/navigationScreen';

  static const addCreditAccount = 'Add Credit Account';
  static const updateCreditAccount = 'Update Account :';
  static const addTransAction = 'Add Transaction';
  static const accountName = 'Account Name';
  static const accountNameHint = 'Salary or CIB';
  static const accountDescription = 'Account Description';
  static const accountDescriptionHint = 'This is my Salary Account';
  static const accountBalance = 'Account Balance';
  static const accountBalanceHint = '500.00';
  static const addAccount = 'Add Account';
  static const account = 'My Accounts';

  static const transactionName = 'Transaction Info ';
  static const transactionNameHint = 'Transaction Description';
  static const transactionBalance = 'Transaction Balance';
  static const transactionBalanceHint = '500.00';
  static const transactionEditedBalance = 'EditedBalance';

  //? Dialog error info
  static const dialogErrorTitle = 'Error';
  static const dialogErrorEmptyAccountName = 'Please, Enter Valid Data';
  static const dialogConfirmationTitle = 'Confirmation';
  static const dialogConfirmationDelete =
      'are u sure you want to delete this account ?';
  static const dataBaseBoxName = 'myAccounts';

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
