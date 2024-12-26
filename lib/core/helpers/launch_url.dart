import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:url_launcher/url_launcher.dart';

openUrl(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    printDebug('Could not launch $url');
  }
}
