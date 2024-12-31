// Side drawer widget
// This widget is used to display the side drawer in the app.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/constants/constants.dart';
import 'package:project_3_forex_signals_daily/core/helpers/launch_mailto.dart';
import 'package:project_3_forex_signals_daily/core/helpers/launch_url.dart';
import 'package:project_3_forex_signals_daily/core/models/user_account_model.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import 'package:project_3_forex_signals_daily/features/anonymous_authentication/views/google_sign_in_button.dart';
import 'package:project_3_forex_signals_daily/features/anonymous_authentication/views/sign_out_button.dart';
import 'package:project_3_forex_signals_daily/features/in_app_purchases/views/pages/in_app_purchase_page.dart';
import 'package:project_3_forex_signals_daily/features/side_drawer/view/widgets/app_version.dart';

class SideDrawer extends ConsumerWidget {
  final UserAccountModel userAccount;
  const SideDrawer(this.userAccount, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: AppColors.backgroundDarker,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: AppColors.backgroundDarker2,
            ),
            child: Center(child: GoogleSignInButton()),
          ),
          userAccount.isPremium
              ? ListTile(
                  leading: Icon(
                    Icons.workspace_premium,
                    color: AppColors.orange,
                  ),
                  title: Text('Premium Member'),
                  subtitle: Text('click to see details'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InAppPurchasePage(),
                      ),
                    );
                  },
                )
              : Container(
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.red.withAlpha(200),
                        AppColors.orange.withAlpha(200),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.workspace_premium),
                    title: Text(
                      'Join Premium',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('click to see premium benefits'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InAppPurchasePage(),
                        ),
                      );
                    },
                  ),
                ),

          ListTile(
            leading: Icon(Icons.telegram),
            title: Text('Telegram Channel'),
            trailing: Icon(Icons.open_in_new),
            onTap: () async {
              openUrl(Links.telegramChannel);
            },
          ),
          ListTile(
            leading: Icon(Icons.mail),
            title: Text('Contact us'),
            onTap: () {
              launchMailto(
                  Links.contactEmail,
                  'Contact/FSD/${defaultTargetPlatform.toString().replaceAll('TargetPlatform.', '')}',
                  '');
            },
          ),
          ListTile(
            title: Text('Other Apps'),
          ),
          ListTile(
              leading: Icon(Icons.speed),
              title: Text('Currency Strength Meter'),
              onTap: () {
                if (defaultTargetPlatform == TargetPlatform.android) {
                  openUrl(Links.csmAndroid);
                } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                  openUrl(Links.csmIos);
                }
              }),

          ListTile(
            title: Text('Policies'),
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacy Policy'),
            onTap: () {
              openUrl(Links.privacyPolicy);
            },
          ),
          ListTile(
            leading: Icon(Icons.article),
            title: Text('Terms'),
            onTap: () {
              openUrl(Links.terms);
            },
          ),
          //UserAccountWidget(),
          SignOutButton(),
          AppVersion(),
        ],
      ),
    );
  }
}
