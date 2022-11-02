import 'package:flutter/material.dart';
import 'package:masrufat/Models/transaction.dart';
import 'package:provider/provider.dart';

import '../../Providers/accounts_provider.dart';
import '../../helper/app_config.dart';

class Expenses extends StatefulWidget {
  final List<Transactions> expenses;
  final List<Transactions> expensesThisMonth;
  final double totalExpenses;
  final double totalExpensesThisMonth;
  const Expenses({
    Key? key,
    required this.expenses,
    required this.expensesThisMonth,
    required this.totalExpenses,
    required this.totalExpensesThisMonth,
  }) : super(key: key);

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> with TickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _animationController;
  late Animation<Size> _hightController;
  late AccountsProvider myProvider;
  @override
  void initState() {
    myProvider = Provider.of(context, listen: false);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _hightController = Tween<Size>(
      begin: const Size(double.infinity, 0),
      end: const Size(double.infinity, 70),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
    _animationController.addListener(() => setState(() {}));
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: Colors.white, fontSize: 20);
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            isExpanded = !isExpanded;
            !isExpanded
                ? _animationController.reverse()
                : _animationController.forward();
          });
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: const BoxDecoration(
                      color: AppConfig.primaryColor,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(20)),
                    ),
                    constraints: BoxConstraints(
                      maxHeight: _hightController.value.height,
                      minHeight: _hightController.value.height,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            'This Month Expenses',
                            style: style,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${widget.totalExpensesThisMonth} \$',
                            style: style,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            isExpanded = !isExpanded;
                            !isExpanded
                                ? _animationController.reverse()
                                : _animationController.forward();
                          });
                        },
                        icon: const Icon(
                          Icons.keyboard_arrow_up_rounded,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.expensesThisMonth
                    .map(
                      (trans) => Container(
                        margin: const EdgeInsets.all(10),
                        color: Colors.red,
                        child: ListTile(
                          textColor: Colors.white,
                          title: Text(
                            trans.name,
                          ),
                          subtitle: Text(
                            trans.id,
                          ),
                          leading: Text(
                            trans.balance.toString(),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
