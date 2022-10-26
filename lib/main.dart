import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masrufat/Models/credit_account.dart';
import 'package:masrufat/Models/debit_account.dart';
import 'package:masrufat/Models/transaction.dart';
import 'package:masrufat/helper/app_config.dart';
import 'package:provider/provider.dart';

import '../Providers/accounts_provider.dart';
import 'Screens/home_screen/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  //? register multiple adapter
  Hive
    ..registerAdapter(CreditAccountAdapter())
    ..registerAdapter(TransactionsAdapter())
    ..registerAdapter(DebitAccountAdapter());

  await Hive.openBox<CreditAccount>(AppConfig.dataBaseBoxForCredit);
  await Hive.openBox<CreditAccount>(AppConfig.dataBaseBoxForDebit);
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AccountsProvider(),
      child: MaterialApp(
        theme: ThemeData().copyWith(
          colorScheme: ThemeData().colorScheme.copyWith(
                primary: AppConfig.primaryColor,
                secondary: AppConfig.secondaryColor,
              ),
        ),
        title: AppConfig.appTitle,
        home: const HomeScreen(),
        routes: {
          HomeScreen.routeName: (_) => const HomeScreen(),
        },
      ),
    );
  }
}
