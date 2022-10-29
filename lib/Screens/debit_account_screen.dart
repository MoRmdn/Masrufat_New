import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:masrufat/Models/debit_account.dart';
import 'package:masrufat/helper/app_config.dart';
import 'package:provider/provider.dart';

import '../Providers/accounts_provider.dart';
import 'debit_account_screen/transaction_widgets/add_debit_transaction_bottom_sheet.dart';
import 'debit_account_screen/transaction_widgets/debit_transaction_card.dart';

class DebitAccountScreen extends StatefulWidget {
  final DebitAccount account;
  final VoidCallback onRefresh;
  const DebitAccountScreen({
    Key? key,
    required this.account,
    required this.onRefresh,
  }) : super(key: key);

  @override
  State<DebitAccountScreen> createState() => _DebitAccountScreenState();
}

class _DebitAccountScreenState extends State<DebitAccountScreen> {
  late AccountsProvider myProvider;

  bool isExpanded = false;

  void _onRefresh() => setState(() {});

  @override
  void didChangeDependencies() {
    myProvider = Provider.of<AccountsProvider>(context, listen: false);
    super.didChangeDependencies();
  }

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
    log('DebitAccountScreen');
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
                  child: AddDebitTransactionBottomSheet(
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
              decoration: const BoxDecoration(
                color: AppConfig.primaryColor,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              constraints: BoxConstraints(
                maxHeight: dSize.height * 0.2,
                minHeight: dSize.height * 0.1,
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
                      value: myProvider.getTotalDebitBalance.toString(),
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
                    (element) => DebitTransactionCard(
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
