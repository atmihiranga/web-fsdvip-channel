// Side drawer widget
// This widget is used to display the side drawer in the app.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/models/user_account_model.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import 'package:project_3_forex_signals_daily/features/anonymous_authentication/views/google_sign_in_button.dart';
import 'package:project_3_forex_signals_daily/features/anonymous_authentication/views/sign_out_button.dart';

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
              color: AppColors.backgroundLighter,
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
                  onTap: () {},
                )
              : ListTile(
                  leading: Icon(Icons.workspace_premium),
                  title: Text('Join Premium'),
                  subtitle: Text('click to see premium benefits'),
                  onTap: () {},
                ),

          ListTile(
            leading: Icon(Icons.telegram),
            title: Text('Telegram Channel'),
            trailing: Icon(Icons.open_in_new),
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Rate us'),
          ),
          ListTile(
            leading: Icon(Icons.mail),
            title: Text('Contact us'),
          ),
          ListTile(
            title: Text('Other Apps'),
          ),
          ListTile(
            leading: Icon(Icons.speed),
            title: Text('Currency Strength Meter'),
          ),

          ListTile(
            title: Text('Policies'),
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacy Policy'),
          ),
          ListTile(
            leading: Icon(Icons.article),
            title: Text('Terms'),
          ),
          //UserAccountWidget(),
          SignOutButton()
        ],
      ),
    );
  }
}
