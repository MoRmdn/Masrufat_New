import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:masrufat/Models/credit_account.dart';
import 'package:masrufat/Models/transaction.dart';
import 'package:masrufat/Providers/accounts_provider.dart';
import 'package:masrufat/dialog/custom_generic_dialog.dart';
import 'package:masrufat/dialog/loading_screen_dialog.dart';
import 'package:masrufat/helper/app_config.dart';
import 'package:provider/provider.dart';

import '../Widgets/bottom_sheet.dart';
import 'navigation_screens.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = AppConfig.homeRouteName;
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController accNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();
  final loading = LoadingScreen.instance();
  final autoSizeGroup = AutoSizeGroup();
  var _bottomNavIndex = 0; //default index of a first screen

  late AnimationController _animationController;
  late Animation<double> animation;
  late CurvedAnimation curve;
  late Size dSize;
  late AccountsProvider myProvider;

  final iconList = <IconData>[
    Icons.account_balance_wallet_outlined,
    Icons.money,
  ];

  @override
  void initState() {
    myProvider = Provider.of<AccountsProvider>(context, listen: false);
    Future.delayed(
      const Duration(milliseconds: 500),
      () => myProvider.fetchDataBaseBox(),
    );

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.5,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    Future.delayed(
      const Duration(seconds: 1),
      () => _animationController.forward(),
    );
    _animationController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    accNameController.dispose();
    descriptionController.dispose();
    balanceController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _askedToLead() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select AccountType'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                addAccountBottomSheet(
                  context: context,
                  onPress: onAddAccount,
                  dSize: dSize,
                  accNameController: accNameController,
                  descriptionController: descriptionController,
                  balanceController: balanceController,
                );
              },
              child: const Text('Credit Account'),
            ),
          ],
        );
      },
    );
  }

  void onAddAccount() {
    loading.show(context: context, content: AppConfig.pleaseWait);
    Future.delayed(const Duration(milliseconds: 500))
        .then((value) => loading.hide());
    final name = accNameController.text;
    final description = descriptionController.text;
    final balance = balanceController.text;
    if (name.isEmpty) {
      customGenericDialog(
        context: context,
        title: AppConfig.dialogErrorTitle,
        content: AppConfig.dialogErrorEmptyAccountName,
        dialogOptions: () {
          return {AppConfig.ok: true};
        },
      );
      return;
    }
    final userCreditAccount = CreditAccount(
      id: DateTime.now().toIso8601String(),
      name: name,
      description:
          description.isEmpty ? AppConfig.accountDescriptionHint : description,
      balance: double.parse(
        balance.isEmpty ? AppConfig.accountBalanceHint : balance,
      ),
      transactions: [
        Transactions.initial(
          date: DateTime.now().toIso8601String(),
          id: DateTime.now().toIso8601String(),
        )
      ],
    );

    myProvider.addCreditAccount(userAccount: userCreditAccount);

    Navigator.of(context).pop();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    dSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConfig.account),
        actions: [
          IconButton(
            onPressed: () => _askedToLead(),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: NavigationScreen(
        index: _bottomNavIndex,
        iconData: iconList[_bottomNavIndex],
      ),
      floatingActionButton: ScaleTransition(
        scale: animation,
        child: FloatingActionButton(
          elevation: 8,
          backgroundColor: Colors.indigo,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            _animationController.reset();
            _animationController.forward();
            _askedToLead();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? Colors.amber : Colors.white;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconList[index],
                size: 24,
                color: color,
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: index == 0
                    ? AutoSizeText(
                        'Accounts',
                        maxLines: 1,
                        style: TextStyle(color: color),
                        group: autoSizeGroup,
                      )
                    : AutoSizeText(
                        'Expenses',
                        maxLines: 1,
                        style: TextStyle(color: color),
                        group: autoSizeGroup,
                      ),
              )
            ],
          );
        },
        backgroundColor: Colors.indigo,
        activeIndex: _bottomNavIndex,
        splashColor: Colors.amber,
        notchAndCornersAnimation: animation,
        splashSpeedInMilliseconds: 300,
        notchSmoothness: NotchSmoothness.defaultEdge,
        gapLocation: GapLocation.center,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }
}
