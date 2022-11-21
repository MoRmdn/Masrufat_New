import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:masrufat/Models/accounts.dart';
import 'package:masrufat/Providers/accounts_provider.dart';
import 'package:masrufat/Screens/transaction_widgets/transfer_money.dart';
import 'package:masrufat/helper/app_config.dart';
import 'package:provider/provider.dart';

import 'transaction_widgets/add_transaction_bottom_sheet.dart';
import 'transaction_widgets/transaction_card.dart';

// ignore: must_be_immutable
class AccountScreen extends StatefulWidget {
  final Account account;
  final int accountIndex;
  final AccountType type;
  final VoidCallback onRefresh;
  const AccountScreen({
    Key? key,
    required this.onRefresh,
    required this.type,
    required this.accountIndex,
    required this.account,
  }) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late int accountIndex = widget.accountIndex;
  late AccountsProvider myProvider =
      Provider.of<AccountsProvider>(context, listen: false);
  late Account account = widget.account;

  late final AccountType _type = widget.type;

  bool isExpanded = false;

  double getTotal(Account account) {
    double total = 0;
    for (var trans in account.transactions) {
      total += trans.balance;
    }
    return total;
  }

  void _onRefresh() => setState(() {
        // widget.onRefresh();
      });

  Widget accountInfo({
    required double hight,
    required String title,
    required String value,
    required TextStyle style,
  }) =>
      SizedBox(
        height: hight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: style,
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: style,
              ),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    log('AccountScreen');
    final dSize = MediaQuery.of(context).size;
    const style = TextStyle(color: Colors.white, fontSize: 20);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: AppConfig.secondaryColor,
        title: Text(
          account.name,
        ),
        actions: [
          if (_type == AccountType.credit)
            IconButton(
              onPressed: () => showModalBottomSheet<void>(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: TransferMoney(
                      reFresh: _onRefresh,
                      crAccount: account as CreditAccount,
                    ),
                  );
                },
              ),
              icon: const Icon(
                Icons.compare_arrows,
              ),
            ),
          IconButton(
            onPressed: () => showModalBottomSheet<void>(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: AddTransactionBottomSheet(
                    reFresh: _onRefresh,
                    account: account,
                    type: _type,
                  ),
                );
              },
            ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: dSize.height * 0.2,
              minHeight: dSize.height * 0.1,
            ),
            decoration: const BoxDecoration(
              color: AppConfig.primaryColor,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  accountInfo(
                    hight: 50,
                    title: AppConfig.accountName + ':',
                    value: account.name,
                    style: style,
                  ),
                  accountInfo(
                    hight: 50,
                    title: AppConfig.accountBalance + ':',
                    value: getTotal(account).toString(),
                    style: style,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: ListView.builder(
                physics: const ScrollPhysics(),
                reverse: true,
                shrinkWrap: true,
                itemCount: account.transactions.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TransactionCard(
                    accountIndex: accountIndex,
                    transactionIndex: index,
                    trans: account.transactions[index],
                    account: account,
                    type: _type,
                    onRefresh: _onRefresh,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
