import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchMailto(String email, String subject, String? body) async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: email,
    queryParameters: {
      'subject': subject,
      'body': body,
    },
  );

  // TODO : Handle errors
  try {
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      printDebug('=====> Could not launch $emailUri');
    }
  } catch (e) {
    printDebug('=====> Error : $e');
  }
}
