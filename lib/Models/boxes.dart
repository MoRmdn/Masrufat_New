import 'package:hive/hive.dart';
import 'package:masrufat/Models/credit_account.dart';
import 'package:masrufat/helper/app_config.dart';

class Boxes {
  //* i have CreditAccount box now (database)
  static Box<CreditAccount> getCreditAccountsBox() =>
      Hive.box<CreditAccount>(AppConfig.dataBaseBoxName);
}
