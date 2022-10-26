import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:masrufat/Providers/accounts_provider.dart';
import 'package:masrufat/Screens/home_screen/widgets/home_app_bar.dart';
import 'package:masrufat/helper/app_config.dart';
import 'package:provider/provider.dart';

import '../account_screen/account_widgets/add_account_bottom_sheet.dart';
import '../navigation_screens.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = AppConfig.homeRouteName;
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final autoSizeGroup = AutoSizeGroup();
  var _bottomNavIndex = 0; //default index of a first screen

  late AnimationController _animationController;
  late Animation<double> animation;
  late CurvedAnimation curve;
  late Size dSize;
  late AccountsProvider myProvider;

  final iconList = <IconData>[
    Icons.account_balance_rounded,
    Icons.account_balance_wallet_outlined,
    Icons.money,
    Icons.settings,
  ];

  @override
  void initState() {
    myProvider = Provider.of<AccountsProvider>(context, listen: false);
    Future.delayed(
      const Duration(milliseconds: 500),
      () => myProvider.fetchDataBaseBox(),
    )
        .then(
          (value) => myProvider.userTotalBlanca(),
        )
        .then((value) => myProvider.userExpenses());

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
    _animationController.dispose();
    super.dispose();
  }

  void _onRefresh() {
    setState(() {
      _bottomNavIndex = 0;
    });
  }

  Future<void> _askedToLoad() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select AccountType'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                showModalBottomSheet<void>(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: AddAccountBottomSheet(
                        onRefresh: _onRefresh,
                      ),
                    );
                  },
                );
              },
              child: const Text('Credit Account'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    dSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: getAppBar(
        context: context,
        bottomNavIndex: _bottomNavIndex,
        onRefresh: _onRefresh,
        askToLoad: _askedToLoad,
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
            _askedToLoad();
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
                        AppConfig.account,
                        maxLines: 1,
                        minFontSize: 8,
                        style: TextStyle(color: color),
                        group: autoSizeGroup,
                      )
                    : index == 1
                        ? AutoSizeText(
                            AppConfig.debit,
                            maxLines: 1,
                            style: TextStyle(color: color),
                            group: autoSizeGroup,
                          )
                        : index == 2
                            ? AutoSizeText(
                                AppConfig.expenses,
                                maxLines: 1,
                                style: TextStyle(color: color),
                                group: autoSizeGroup,
                              )
                            : AutoSizeText(
                                AppConfig.settings,
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
