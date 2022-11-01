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
  final List<CreditAccount>? creditAccounts;
  final List<DebitAccount>? debitAccounts;
  final AccountType type;
  final VoidCallback onRefresh;
  const AccountCards({
    Key? key,
    required this.type,
    required this.creditAccounts,
    required this.debitAccounts,
    required this.onRefresh,
  }) : super(key: key);

  @override
  State<AccountCards> createState() => _AccountCardsState();
}

class _AccountCardsState extends State<AccountCards>
    with TickerProviderStateMixin {
  late AccountsProvider myProvider;
  bool isExpanded = true;
  late AnimationController _animationController;
  late Animation<Size> _hightController;

  @override
  void initState() {
    myProvider = Provider.of(context, listen: false);
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
    final creditAccounts = widget.creditAccounts;
    final debitAccounts = widget.debitAccounts;
    final _type = widget.type;
    final orientation = MediaQuery.of(context).orientation;
    const style = TextStyle(color: Colors.white, fontSize: 20);
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            isExpanded = !isExpanded;
            !isExpanded
                ? _animationController.reverse()
                : _animationController.forward();
          });
        },
        child: SingleChildScrollView(
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
                                    if (_type == AccountType.credit)
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
                                            _type == AccountType.credit
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
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: GridView.builder(
                  itemCount: _type == AccountType.credit
                      ? creditAccounts!.length
                      : debitAccounts!.length,
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
                        crAccount: _type == AccountType.credit
                            ? creditAccounts![index]
                            : null,
                        drAccount: _type == AccountType.debit
                            ? debitAccounts![index]
                            : null,
                        type: _type,
                      ),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AccountScreen(
                            crAccount: _type == AccountType.credit
                                ? creditAccounts![index]
                                : null,
                            drAccount: _type == AccountType.debit
                                ? debitAccounts![index]
                                : null,
                            onRefresh: _onRefresh,
                            type: _type,
                          ),
                        ),
                      ),
                      child: Dismissible(
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) => _onDismiss(),
                        onDismissed: (value) {
                          myProvider.deleteAccount(
                            deleteUserCreditAccount: _type == AccountType.credit
                                ? creditAccounts![index]
                                : null,
                            deleteUserDebitAccount: _type == AccountType.debit
                                ? debitAccounts![index]
                                : null,
                          );
                          _onRefresh();
                        },
                        key: Key(
                          _type == AccountType.credit
                              ? creditAccounts![index].id
                              : debitAccounts![index].id,
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
                              color: AppConfig.cardColorList[index],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                _type == AccountType.credit
                                    ? creditAccounts![index].name
                                    : debitAccounts![index].name,
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
      ),
    );
  }
}
