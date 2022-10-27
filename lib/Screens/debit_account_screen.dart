import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:masrufat/Models/debit_account.dart';
import 'package:masrufat/helper/app_config.dart';

import 'debit_account_screen/transaction_widgets/add_transaction_bottom_sheet.dart';
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
  bool isExpanded = false;

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
            Text(
              title,
              style: style,
            ),
            Text(
              value,
              style: style,
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    log('DebitAccountScreen');
    final dSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                constraints: BoxConstraints(
                  maxHeight: dSize.height * 0.3,
                  minHeight: dSize.height * 0.2,
                ),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
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
                          style: Theme.of(context).textTheme.bodyLarge!,
                        ),
                        accountInfo(
                          hight: 50,
                          title: AppConfig.accountDescription + ':',
                          value: widget.account.description,
                          style: Theme.of(context).textTheme.bodyLarge!,
                        ),
                        accountInfo(
                          hight: 50,
                          title: AppConfig.accountBalance + ':',
                          value: widget.account.balance.toString(),
                          style: Theme.of(context).textTheme.bodyLarge!,
                        ),
                      ],
                    ),
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
      ),
    );
  }
}
