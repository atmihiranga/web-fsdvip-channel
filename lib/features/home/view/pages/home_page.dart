import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_3_forex_signals_daily/core/failure/failure_page.dart';
import 'package:project_3_forex_signals_daily/core/pages/loading_page.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import 'package:project_3_forex_signals_daily/features/signals/views/widgets/signals_list.dart';
import 'package:project_3_forex_signals_daily/features/user_account/viewmodels/user_account_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAccountModel = ref.watch(userAccountViewmodelProvider);

    return userAccountModel.when(
        data: (user) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Forex Signals Daily'),
              centerTitle: true,
              actions: [
                InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: () async {
                    final url = Uri.parse('https://t.me/fsdvip');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    }
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: FaIcon(
                          FontAwesomeIcons.telegram,
                          color: AppColors.white,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            'Admin',
                            style: TextStyle(
                              fontSize: 6,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: const SignalsList(),
                ),
              ],
            ),
          );
        },
        error: (error, stack) {
          return FailurePage(
            errorMessage: error.toString(),
          );
        },
        loading: () => LoadingPage());
  }
}
