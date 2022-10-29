import 'dart:developer';

import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/material.dart';
import 'package:masrufat/Models/credit_account.dart';
import 'package:masrufat/Models/debit_account.dart';
import 'package:masrufat/Models/transaction.dart';
import 'package:masrufat/Screens/expenses/expenses.dart';
import 'package:masrufat/Screens/settings_screen/settings.dart';
import 'package:masrufat/helper/app_config.dart';
import 'package:provider/provider.dart';

import '../Providers/accounts_provider.dart';
import 'credit_account_screen/account_widgets/credit_accounts_card.dart';
import 'debit_account_screen/account_widgets/debit_accounts_card.dart';

// ignore: must_be_immutable
class NavigationScreen extends StatefulWidget {
  static const routName = AppConfig.navigationRouteName;
  final IconData iconData;
  int index;

  NavigationScreen({
    Key? key,
    required this.iconData,
    required this.index,
  }) : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with TickerProviderStateMixin {
  late AccountsProvider myProvider;
  List<CreditAccount> creditAccount = [];
  List<DebitAccount> debitAccount = [];
  List<Transactions> expensesThisMonth = [];
  List<Transactions> expenses = [];
  double totalExpenses = 0.0;
  double totalExpensesThisMonth = 0.0;
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void didUpdateWidget(NavigationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.iconData != widget.iconData) {
      _startAnimation();
    }
  }

  @override
  void initState() {
    myProvider = Provider.of<AccountsProvider>(context, listen: false);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
    super.initState();
  }

  _startAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    Future.delayed(const Duration(microseconds: 0)).then((value) {
      creditAccount = myProvider.getUserCreditAccounts;
      debitAccount = myProvider.getUserDebitAccounts;
      expensesThisMonth = myProvider.getUserExpensesPerMonth;
      expenses = myProvider.getUserExpenses;
      totalExpenses = myProvider.getTotalExpenses;
      totalExpensesThisMonth = myProvider.getTotalPerMonthExpenses;
    });
  }

  @override
  Widget build(BuildContext context) {
    log('Navigation');
    fetchData();
    return creditAccount.isNotEmpty && widget.index == 0
        ? CreditAccountCard(
            accounts: creditAccount,
          )
        : debitAccount.isNotEmpty && widget.index == 1
            ? DebitAccountCard(
                accounts: debitAccount,
              )
            : widget.index == 2 && expenses.isNotEmpty
                ? Expenses(
                    expenses: expenses,
                    expensesThisMonth: expensesThisMonth,
                    totalExpenses: totalExpenses,
                    totalExpensesThisMonth: totalExpensesThisMonth,
                  )
                : widget.index == 3
                    ? const Settings()
                    : Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.white,
                        child: Center(
                          child: CircularRevealAnimation(
                            animation: animation,
                            centerOffset: const Offset(80, 80),
                            maxRadius:
                                MediaQuery.of(context).size.longestSide * 1.1,
                            child: Icon(
                              widget.iconData,
                              color: HexColor('#FFA400'),
                              size: 160,
                            ),
                          ),
                        ),
                      );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
