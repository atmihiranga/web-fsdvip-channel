// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/models/signal_model.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import 'package:project_3_forex_signals_daily/features/ads/viewmodels/ads_viewmodel.dart';
import 'package:project_3_forex_signals_daily/features/free_user/views/free_signal_more_details.dart';
import 'package:project_3_forex_signals_daily/features/premium_user/view/widgets/premium_user_more_signal_details.dart';
import 'package:project_3_forex_signals_daily/features/signals/views/widgets/signal_buttons_row.dart';
import 'package:project_3_forex_signals_daily/features/signals/views/widgets/signal_title_row.dart';
import 'package:project_3_forex_signals_daily/features/update_signal/views/pages/update_signal_data.dart';
import 'package:project_3_forex_signals_daily/features/user_account/viewmodels/user_account_viewmodel.dart';

class SignalWidget extends ConsumerStatefulWidget {
  final SignalModel signaldata;
  //final bool isLocked;

  const SignalWidget({
    super.key,
    required this.signaldata,
    // required this.isLocked,
  });

  @override
  ConsumerState<SignalWidget> createState() => _PremiumSignalWidgetState();
}

// bool showDetails = false;

class _PremiumSignalWidgetState extends ConsumerState<SignalWidget> {
  late SignalModel _currentSignalData;
  bool isLocked = true;
  bool isPremium = false;
  bool isAdmin = false;

  @override
  void initState() {
    _currentSignalData = widget.signaldata;
    // printDebug(
    //     '=====> signal widget init isExpanded: ${_currentSignalData.isExpanded}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userAccountModel = ref.watch(userAccountViewmodelProvider);
    userAccountModel.whenData(
      (value) {
        isPremium = value.isPremium;
        isAdmin = value.isAdmin ?? false;
      },
    );

    if (isPremium) {
      isLocked = false;
    } else {
      if (_currentSignalData.isSlHit || _currentSignalData.isTp1Hit) {
        isLocked = false;
      } else {
        isLocked = true;
      }
    }

    return InkWell(
      splashFactory: NoSplash.splashFactory, // Disables the splash effect
      onTap: () {
        ref.read(adsViewModelProvider.notifier).trackUserInteraction();
        setState(() {
          _currentSignalData = _currentSignalData.copyWith(
              isExpanded: !_currentSignalData.isExpanded);
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.backgroundDarker,
                      shape: BoxShape.circle,
                    ),
                    child: _currentSignalData.action.toUpperCase() == 'BUY'
                        ? const Icon(
                            Icons.trending_up,
                            size: 24,
                            color: AppColors.green,
                          )
                        : const Icon(Icons.trending_down,
                            size: 24, color: AppColors.red)),
                const SizedBox(width: 10),
                Expanded(
                    child: SignalTitleRow(
                  signaldata: _currentSignalData,
                )),
                const SizedBox(width: 10),
                _currentSignalData.isActive
                    ? Container(
                        margin: EdgeInsets.only(left: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: AppColors.blue.withAlpha(51)),
                        child: Text(
                          'active',
                          style: TextStyle(color: AppColors.blue),
                        ),
                      )
                    : _currentSignalData.result < 0
                        ? const Icon(
                            Icons.cancel,
                            color: AppColors.red,
                            size: 42,
                          )
                        : const Icon(
                            Icons.check_circle,
                            color: AppColors.green,
                            size: 42,
                          ),
              ],
            ),
            const SizedBox(height: 4),
            SignalButtonsRow(
              isExpanded: _currentSignalData.isExpanded,
              symbol: _currentSignalData.symbol.toUpperCase(),
              analysisLink: _currentSignalData.analysisLink,
              note: _currentSignalData.note,
            ),
            const SizedBox(height: 4),
            Visibility(
                visible: _currentSignalData.isExpanded,
                child: isLocked
                    ? FreeUserMoreSignalDetails()
                    : PremiumUserMoreSignalDetails(
                        signaldata: _currentSignalData,
                      )),
            Visibility(
              visible: isAdmin,
              child: Row(
                children: [
                  TextButton.icon(
                      icon: Icon(Icons.send),
                      onPressed: () {},
                      label: Text('Send Notification')),
                  TextButton.icon(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateSignalDataPage(
                              signalData: _currentSignalData),
                        ),
                      );
                    },
                    label: Text('Edit'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
