import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:masrufat/Models/debit_account.dart';
import 'package:masrufat/Providers/accounts_provider.dart';
import 'package:masrufat/dialog/custom_generic_dialog.dart';
import 'package:masrufat/helper/app_config.dart';
import 'package:provider/provider.dart';

import '../../../Widgets/edit_delete_dialogs.dart';
import '../../debit_account_screen.dart';

// ignore: must_be_immutable
class DebitAccountCard extends StatefulWidget {
  List<DebitAccount> accounts;

  DebitAccountCard({
    Key? key,
    required this.accounts,
  }) : super(key: key);

  @override
  State<DebitAccountCard> createState() => _DebitAccountCardState();
}

class _DebitAccountCardState extends State<DebitAccountCard>
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
      end: const Size(double.infinity, 50),
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

  void _onRefresh() => setState(() {});

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
    log('debitAccount');
    final orientation = MediaQuery.of(context).orientation;
    const style = TextStyle(color: Colors.white, fontSize: 20);

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: RefreshIndicator(
        onRefresh: () async => setState(() {
          isExpanded = !isExpanded;
          !isExpanded
              ? _animationController.reverse()
              : _animationController.forward();
        }),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
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
                            padding: const EdgeInsets.all(10.0),
                            child: Consumer<AccountsProvider>(
                              builder: (_, snapShot, child) => Row(
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
                                      '${snapShot.getTotalDebitBalance} \$',
                                      style: style,
                                    ),
                                  ),
                                ],
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
                  itemCount: widget.accounts.length,
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
                        debitAccount: widget.accounts[index],
                      ),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => DebitAccountScreen(
                            account: widget.accounts[index],
                            onRefresh: _onRefresh,
                          ),
                        ),
                      ),
                      child: Dismissible(
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) => _onDismiss(),
                        onDismissed: (value) {
                          myProvider.deleteAccount(
                            deleteUserCreditAccount: null,
                            deleteUserDebitAccount: widget.accounts[index],
                          );
                          _onRefresh();
                        },
                        key: Key(widget.accounts[index].id),
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
                                widget.accounts[index].name,
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
