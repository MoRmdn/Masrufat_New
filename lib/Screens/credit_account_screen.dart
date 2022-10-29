import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:masrufat/Models/credit_account.dart';
import 'package:masrufat/Providers/accounts_provider.dart';
import 'package:masrufat/helper/app_config.dart';
import 'package:provider/provider.dart';

import 'credit_account_screen/transaction_widgets/add_credit_transaction_bottom_sheet.dart';
import 'credit_account_screen/transaction_widgets/credit_transaction_card.dart';

class CreditAccountScreen extends StatefulWidget {
  final CreditAccount account;
  final VoidCallback onRefresh;
  const CreditAccountScreen({
    Key? key,
    required this.account,
    required this.onRefresh,
  }) : super(key: key);

  @override
  State<CreditAccountScreen> createState() => _CreditAccountScreenState();
}

class _CreditAccountScreenState extends State<CreditAccountScreen> {
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
    log('CreditAccountScreen');
    final dSize = MediaQuery.of(context).size;
    const style = TextStyle(color: Colors.white, fontSize: 20);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: AppConfig.secondaryColor,
        title: Text(widget.account.name),
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
                  child: AddCreditTransactionBottomSheet(
                    account: widget.account,
                    reFresh: _onRefresh,
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
                      value: widget.account.name,
                      style: style,
                    ),
                    accountInfo(
                      hight: 50,
                      title: AppConfig.accountBalance + ':',
                      value: myProvider.getTotalCreditBalance.toString(),
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
              children: widget.account.transactions
                  .map(
                    (element) => CreditTransactionCard(
                      trans: element,
                      account: widget.account,
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
