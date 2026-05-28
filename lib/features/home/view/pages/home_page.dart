import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_3_forex_signals_daily/core/failure/failure_page.dart';
import 'package:project_3_forex_signals_daily/core/pages/loading_page.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import 'package:project_3_forex_signals_daily/features/signals/views/widgets/signals_list.dart';
import 'package:project_3_forex_signals_daily/features/user_account/viewmodels/user_account_viewmodel.dart';
import 'package:project_3_forex_signals_daily/core/theme/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAccountModel = ref.watch(userAccountViewmodelProvider);
    final themeMode = ref.watch(themeModeProvider);

    return userAccountModel.when(
        data: (user) {
          return Scaffold(
            appBar: AppBar(
              title: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    AppColors.orange,
                    Theme.of(context).colorScheme.onSurface
                  ],
                ).createShader(bounds),
                child: const Text(
                  'FOREX SIGNALS DAILY',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                    fontSize: 18,
                  ),
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    ref.read(themeModeProvider.notifier).state =
                        themeMode == ThemeMode.dark
                            ? ThemeMode.light
                            : ThemeMode.dark;
                  },
                  icon: Icon(
                    themeMode == ThemeMode.dark
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    color: themeMode == ThemeMode.dark
                        ? AppColors.orange
                        : AppColors.primary,
                  ),
                  tooltip: themeMode == ThemeMode.dark
                      ? 'Switch to Light Mode'
                      : 'Switch to Dark Mode',
                ),
                const SizedBox(width: 8),
                Center(
                  child: InkWell(
                    onTap: () async {
                      final url = Uri.parse('https://t.me/fsdvip');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url,
                            mode: LaunchMode.externalApplication);
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.accent.withAlpha(40), width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.telegram,
                            color: AppColors.accent,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'ADMIN',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
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
