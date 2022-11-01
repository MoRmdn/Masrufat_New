import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:masrufat/Models/accounts.dart';
import 'package:masrufat/Providers/accounts_provider.dart';
import 'package:masrufat/helper/app_config.dart';
import 'package:provider/provider.dart';

import 'transaction_widgets/add_credit_transaction_bottom_sheet.dart';
import 'transaction_widgets/credit_transaction_card.dart';

class AccountScreen extends StatefulWidget {
  final CreditAccount? crAccount;
  final DebitAccount? drAccount;
  final AccountType type;
  final VoidCallback onRefresh;
  const AccountScreen({
    Key? key,
    required this.onRefresh,
    required this.type,
    this.crAccount,
    this.drAccount,
  }) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late AccountsProvider myProvider;

  bool isExpanded = false;

  @override
  void didChangeDependencies() {
    myProvider = Provider.of<AccountsProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  void _onRefresh() => setState(() {});

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
    final crAccount = widget.crAccount;
    final drAccount = widget.drAccount;
    final _type = widget.type;
    final dSize = MediaQuery.of(context).size;
    const style = TextStyle(color: Colors.white, fontSize: 20);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: AppConfig.secondaryColor,
        title: Text(
          _type == AccountType.credit ? crAccount!.name : drAccount!.name,
        ),
        actions: [
          IconButton(
            onPressed: () => showModalBottomSheet<void>(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: AddTransactionBottomSheet(
                    reFresh: _onRefresh,
                    crAccount: crAccount,
                    drAccount: drAccount,
                    type: _type,
                  ),
                );
              },
            ),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints(
                maxHeight: dSize.height * 0.2,
                minHeight: dSize.height * 0.1,
              ),
              decoration: const BoxDecoration(
                color: AppConfig.primaryColor,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    accountInfo(
                      hight: 50,
                      title: AppConfig.accountName + ':',
                      value: _type == AccountType.credit
                          ? crAccount!.name
                          : drAccount!.name,
                      style: style,
                    ),
                    accountInfo(
                      hight: 50,
                      title: AppConfig.accountBalance + ':',
                      value: _type == AccountType.credit
                          ? myProvider.getTotalCreditBalance.toString()
                          : myProvider.getTotalDebitBalance.toString(),
                      style: style,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: _type == AccountType.credit
                  ? crAccount!.transactions
                      .map(
                        (element) => TransactionCard(
                          trans: element,
                          crAccount: crAccount,
                          drAccount: drAccount,
                          type: _type,
                          onRefresh: () {
                            widget.onRefresh();
                            _onRefresh();
                          },
                        ),
                      )
                      .toList()
                  : drAccount!.transactions
                      .map(
                        (element) => TransactionCard(
                          trans: element,
                          crAccount: crAccount,
                          drAccount: drAccount,
                          type: _type,
                          onRefresh: () {
                            widget.onRefresh();
                            _onRefresh();
                          },
                        ),
                      )
                      .toList(),
            )
          ],
        ),
      ),
    );
  }
}
