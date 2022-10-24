import 'package:flutter/material.dart';
import 'package:masrufat/Models/credit_account.dart';
import 'package:masrufat/Screens/account_screen.dart';
import 'package:masrufat/helper/app_config.dart';

import 'add_account_bottom_sheet.dart';

// ignore: must_be_immutable
class CreditAccountCard extends StatefulWidget {
  List<CreditAccount> accounts;
  CreditAccountCard({Key? key, required this.accounts}) : super(key: key);

  @override
  State<CreditAccountCard> createState() => _CreditAccountCardState();
}

class _CreditAccountCardState extends State<CreditAccountCard> {
  void _onRefresh() => setState(() {});
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
          onLongPress: () => showModalBottomSheet<void>(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: AddAccountBottomSheet(
                  accountToEdit: widget.accounts[index],
                  onRefresh: _onRefresh,
                ),
              );
            },
          ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AccountScreen(
                account: widget.accounts[index],
              ),
            ),
          ),
          child: Dismissible(
            onDismissed: (direction) {
              direction == DismissDirection.endToStart ? null : null;
            },
            key: Key(widget.accounts[index].id),
            background: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.edit),
            ),
            secondaryBackground: Container(
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
