import 'package:flutter/material.dart';
import 'package:masrufat/Models/credit_account.dart';
import 'package:masrufat/Screens/account_screen.dart';
import 'package:masrufat/helper/app_config.dart';

// ignore: must_be_immutable
class CreditAccountCard extends StatefulWidget {
  List<CreditAccount> accounts;
  CreditAccountCard({Key? key, required this.accounts}) : super(key: key);

  @override
  State<CreditAccountCard> createState() => _CreditAccountCardState();
}

class _CreditAccountCardState extends State<CreditAccountCard> {
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return RefreshIndicator(
      onRefresh: () async => setState(() {}),
      child: GridView.builder(
        itemCount: widget.accounts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
          childAspectRatio: 3,
        ),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AccountScreen(
                  account: widget.accounts[index],
                ),
              ),
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
                color: Colors.black12,
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
