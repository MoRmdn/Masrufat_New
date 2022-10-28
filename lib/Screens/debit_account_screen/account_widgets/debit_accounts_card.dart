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

class _DebitAccountCardState extends State<DebitAccountCard> {
  late AccountsProvider myProvider;
  @override
  void initState() {
    myProvider = Provider.of(context, listen: false);
    super.initState();
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: AppConfig.primaryColor,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              height: MediaQuery.of(context).size.height * 0.1,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Consumer<AccountsProvider>(
                  builder: (_, snapShot, child) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: GridView.builder(
                itemCount: widget.accounts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
                  childAspectRatio: 3,
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
    );
  }
}
