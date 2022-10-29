import 'dart:io';

import 'package:flutter/material.dart';
import 'package:masrufat/Providers/accounts_provider.dart';
import 'package:masrufat/dialog/custom_generic_dialog.dart';
import 'package:masrufat/helper/app_config.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> OpenWhatsAPP() async {
    String whatsapp = '+201281100168';
    var whatsAppURlAndroid = Uri.parse('whatsapp://send?phone=$whatsapp');
    var whatAppURLIos = Uri.parse('https://wa.me/$whatsapp');
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunchUrl(
        whatAppURLIos,
      )) {
        await launchUrl(
          whatAppURLIos,
        );
      }
    } else {
      // android , web
      if (await canLaunchUrl(whatsAppURlAndroid)) {
        await launchUrl(whatsAppURlAndroid);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<AccountsProvider>(context, listen: false);
    final terms = Uri.parse(
      'https://www.freeprivacypolicy.com/live/ae71d61d-af62-4dee-9754-b0b3dc083581',
    );
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
          // _getListTile(
          //   title: AppConfig.rateUs,
          //   icon: Icons.favorite_outline,
          //   onTap: () {},
          // ),
          // _getListTile(
          //   title: AppConfig.share,
          //   icon: Icons.share,
          //   onTap: () {},
          // ),
          _getListTile(
            title: AppConfig.support,
            icon: Icons.support_agent,
            onTap: OpenWhatsAPP,
          ),
          _getListTile(
            title: AppConfig.termsAndConditions,
            icon: Icons.check_box_outlined,
            onTap: () async => _launchUrl(terms),
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
