import 'package:flutter/material.dart';
import 'package:masrufat/Providers/accounts_provider.dart';
import 'package:masrufat/dialog/custom_generic_dialog.dart';
import 'package:masrufat/helper/app_config.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  Future<void> _deleteDataBase({
    required BuildContext context,
    required AccountsProvider myProvider,
  }) async =>
      customGenericDialog(
        context: context,
        title: AppConfig.dialogConfirmationTitle,
        content: AppConfig.dialogConfirmationDeleteDataBase,
        dialogOptions: () => {
          'No': null,
          'Yes': () {
            myProvider
                .deleteDataBase()
                .then((value) => Navigator.of(context).pop());
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<AccountsProvider>(context, listen: false);
    return SingleChildScrollView(
      child: Column(
        children: [
          _getListTile(
            title: AppConfig.deleteDataBase,
            icon: Icons.cleaning_services_outlined,
            onTap: () => _deleteDataBase(
              context: context,
              myProvider: myProvider,
            ),
          ),
          _getListTile(
            title: AppConfig.rateUs,
            icon: Icons.favorite_outline,
            onTap: () {},
          ),
          _getListTile(title: AppConfig.share, icon: Icons.share, onTap: () {}),
          _getListTile(
            title: AppConfig.support,
            icon: Icons.support_agent,
            onTap: () {},
          ),
          _getListTile(
            title: AppConfig.termsAndConditions,
            icon: Icons.check_box_outlined,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

Widget _getListTile({
  required String title,
  required IconData icon,
  required VoidCallback onTap,
}) =>
    GestureDetector(
      onTap: onTap,
      child: ListTile(
        title: Text(title),
        leading: Icon(icon),
      ),
    );
