import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';

class AppVersion extends StatelessWidget {
  final String prefix;
  final bool includeVersion;
  final bool includeBuildNumber;
  final String separator;

  const AppVersion({
    super.key,
    this.prefix = 'v',
    this.includeVersion = true,
    this.includeBuildNumber = true,
    this.separator = '.',
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint('Error fetching package info: ${snapshot.error}');
          return const SizedBox.shrink();
        }

        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final packageInfo = snapshot.data!;
        final List<String> versionParts = [];

        if (prefix.isNotEmpty) {
          versionParts.add(prefix);
        }

        if (includeVersion) {
          versionParts.add(packageInfo.version);
        }

        if (includeBuildNumber) {
          versionParts.add(packageInfo.buildNumber);
        }

        return ListTile(
          title: Text(
            versionParts.join(separator),
            style: TextStyle(
              color: AppColors.white.withAlpha(120),
            ),
          ),
        );
      },
    );
  }
}
