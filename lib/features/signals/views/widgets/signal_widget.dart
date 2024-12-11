// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/models/signal_model.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:project_3_forex_signals_daily/features/free_user/views/free_signal_more_details.dart';
import 'package:project_3_forex_signals_daily/features/premium_user/view/widgets/premium_user_more_signal_details.dart';
import 'package:project_3_forex_signals_daily/features/signals/views/widgets/signal_buttons_row.dart';
import 'package:project_3_forex_signals_daily/features/signals/views/widgets/signal_title_row.dart';
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

  @override
  void initState() {
    _currentSignalData = widget.signaldata;
    //_isLocked = widget.isLocked;
    printDebug('=====> signal widget init ${_currentSignalData.isExpanded}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userAccountModel = ref.watch(userAccountViewmodelProvider);
    userAccountModel.whenData(
      (value) {
        isPremium = value.isPremium;
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

    printDebug('=====> signal widget');
    return InkWell(
      splashFactory: NoSplash.splashFactory, // Disables the splash effect
      onTap: () {
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
                            color: AppColors.blue.withOpacity(0.2)),
                        child: Text(
                          'active',
                          style: TextStyle(color: AppColors.blue),
                        ),
                      )
                    : _currentSignalData.result < 0
                        ? const Icon(Icons.cancel, color: AppColors.red)
                        : const Icon(Icons.check_circle,
                            color: AppColors.green),
              ],
            ),
            const SizedBox(height: 4),
            SignalButtonsRow(
                isExpanded: _currentSignalData.isExpanded,
                symbol: _currentSignalData.symbol.toUpperCase()),
            const SizedBox(height: 4),
            Visibility(
                visible: _currentSignalData.isExpanded,
                child: isLocked
                    ? FreeUserMoreSignalDetails()
                    : PremiumUserMoreSignalDetails(
                        signaldata: _currentSignalData,
                      )),
          ],
        ),
      ),
    );
  }
}
