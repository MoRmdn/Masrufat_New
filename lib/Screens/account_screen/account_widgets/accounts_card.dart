import 'package:flutter/material.dart';
import 'package:masrufat/Models/credit_account.dart';
import 'package:masrufat/Providers/accounts_provider.dart';
import 'package:masrufat/Screens/account_screen.dart';
import 'package:masrufat/dialog/custom_generic_dialog.dart';
import 'package:masrufat/helper/app_config.dart';
import 'package:provider/provider.dart';

import 'edit_delete_dialogs.dart';

// ignore: must_be_immutable
class CreditAccountCard extends StatefulWidget {
  List<CreditAccount> accounts;
  CreditAccountCard({Key? key, required this.accounts}) : super(key: key);

  @override
  State<CreditAccountCard> createState() => _CreditAccountCardState();
}

class _CreditAccountCardState extends State<CreditAccountCard> {
  late AccountsProvider myProvider;
  @override
  void initState() {
    myProvider = Provider.of<AccountsProvider>(context, listen: false);
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
    final orientation = MediaQuery.of(context).orientation;
    return GridView.builder(
      itemCount: widget.accounts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
        childAspectRatio: 3,
      ),
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onLongPress: () => showCustomDialog(
            context: context,
            myProvider: myProvider,
            onRefresh: _onRefresh,
            account: widget.accounts[index],
          ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AccountScreen(
                account: widget.accounts[index],
              ),
            ),
          ),
          child: Dismissible(
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) => _onDismiss(),
            onDismissed: (value) {
              myProvider.deleteCreditAccount(
                updatedUserAccount: widget.accounts[index],
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
              footer: Container(
                decoration: const BoxDecoration(
                  color: Colors.black12,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      const Text(AppConfig.accountBalance),
                      const Spacer(),
                      Text(widget.accounts[index].balance.toString()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
