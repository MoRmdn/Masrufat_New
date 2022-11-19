import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:masrufat/Models/accounts.dart';
import 'package:masrufat/Providers/accounts_provider.dart';
import 'package:masrufat/Screens/account_screen.dart';
import 'package:masrufat/dialog/custom_generic_dialog.dart';
import 'package:masrufat/helper/app_config.dart';
import 'package:provider/provider.dart';

import '../../../Widgets/edit_delete_dialogs.dart';

// ignore: must_be_immutable
class AccountCards extends StatefulWidget {
  List<Account> accounts;
  int pageIndex;
  AccountType type;
  final VoidCallback onRefresh;

  AccountCards({
    Key? key,
    required this.type,
    required this.onRefresh,
    required this.accounts,
    required this.pageIndex,
  }) : super(key: key);

  @override
  State<AccountCards> createState() => _AccountCardsState();
}

class _AccountCardsState extends State<AccountCards>
    with TickerProviderStateMixin {
  late AccountsProvider myProvider = Provider.of(context, listen: false);
  late AnimationController _animationController;
  late Animation<Size> _hightController;
  bool isExpanded = true;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _hightController = Tween<Size>(
      begin: const Size(double.infinity, 0),
      end: const Size(double.infinity, 70),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
    _animationController.addListener(() => setState(() {}));
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onRefresh() => setState(() {
        widget.onRefresh();
      });

  Future<bool?> _onDismiss() => customGenericDialog(
        context: context,
        title: AppConfig.dialogConfirmationTitle,
        content: AppConfig.dialogConfirmationDelete,
        dialogOptions: () => {
          'no': null,
          'yes': () => Navigator.of(context).pop(true),
        },
      );

  @override
  Widget build(BuildContext context) {
    log('Account_Card');
    AccountType type = widget.type;
    int pageIndex = widget.pageIndex;
    List<Account> accounts = pageIndex == 0
        ? widget.accounts as List<CreditAccount>
        : widget.accounts as List<DebitAccount>;
    final orientation = MediaQuery.of(context).orientation;
    const style = TextStyle(color: Colors.white, fontSize: 20);
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          isExpanded = !isExpanded;
          !isExpanded
              ? _animationController.reverse()
              : _animationController.forward();
        });
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: const BoxDecoration(
                    color: AppConfig.primaryColor,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(20)),
                  ),
                  constraints: BoxConstraints(
                    maxHeight: _hightController.value.height,
                    minHeight: _hightController.value.height,
                  ),
                  child: isExpanded
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Consumer<AccountsProvider>(
                            builder: (_, snapShot, child) =>
                                SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (type == AccountType.credit)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Expanded(
                                          flex: 3,
                                          child: Text(
                                            AppConfig.grandTotalBalance,
                                            style: style,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${snapShot.getTotalGrandBalance} \$',
                                            style: style,
                                          ),
                                        ),
                                      ],
                                    ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Expanded(
                                        flex: 3,
                                        child: Text(
                                          AppConfig.totalBalance,
                                          style: style,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          type == AccountType.credit
                                              ? '${snapShot.getTotalCreditBalance} \$'
                                              : '${snapShot.getTotalDebitBalance} \$',
                                          style: style,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          isExpanded = !isExpanded;
                          !isExpanded
                              ? _animationController.reverse()
                              : _animationController.forward();
                        });
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_up_rounded,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: GridView.builder(
                physics: const ScrollPhysics(),
                itemCount: accounts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
                  childAspectRatio: 2.5,
                ),
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onLongPress: () => showCustomDialog(
                      ctx: context,
                      myProvider: myProvider,
                      onRefresh: _onRefresh,
                      crAccount: type == AccountType.credit
                          ? accounts[index] as CreditAccount
                          : null,
                      drAccount: type == AccountType.debit
                          ? accounts[index] as DebitAccount
                          : null,
                      type: type,
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AccountScreen(
                          accountIndex: index,
                          account: accounts[index],
                          onRefresh: _onRefresh,
                          type: type,
                        ),
                      ),
                    ),
                    child: Dismissible(
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) => _onDismiss(),
                      onDismissed: (value) {
                        myProvider.deleteAccount(
                          deleteUserCreditAccount: type == AccountType.credit
                              ? accounts[index] as CreditAccount
                              : null,
                          deleteUserDebitAccount: type == AccountType.debit
                              ? accounts[index] as DebitAccount
                              : null,
                        );
                        _onRefresh();
                      },
                      key: Key(
                        accounts[index].id,
                      ),
                      background: Container(
                        padding: const EdgeInsets.all(20),
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.delete),
                      ),
                      child: GridTile(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppConfig.cardColorList.elementAt(index),
                                AppConfig.cardColorList.elementAt(index + 1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              accounts[index].name,
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
