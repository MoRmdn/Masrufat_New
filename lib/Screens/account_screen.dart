import 'package:flutter/material.dart';
import 'package:masrufat/Models/credit_account.dart';
import 'package:masrufat/helper/app_config.dart';

import '../Widgets/transaction_widgets/add_transaction_bottom_sheet.dart';
import '../Widgets/transaction_widgets/transaction_card.dart';

class AccountScreen extends StatefulWidget {
  final CreditAccount account;
  const AccountScreen({Key? key, required this.account}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
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
                  child: AddTransactionBottomSheet(
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
                      (element) => TransactionCard(
                        trans: element,
                        account: widget.account,
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
