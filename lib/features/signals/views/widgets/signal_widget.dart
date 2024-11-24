// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/failure/failure_widget.dart';
import 'package:project_3_forex_signals_daily/core/models/signal_model.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import 'package:project_3_forex_signals_daily/core/widgets/loading_widget.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:project_3_forex_signals_daily/features/free_signals/views/free_signal_more_details.dart';
import 'package:project_3_forex_signals_daily/features/premium_signals/view/widgets/premium_signal_more_details.dart';
import 'package:project_3_forex_signals_daily/features/update_signal/views/pages/update_signal_data.dart';
import 'package:project_3_forex_signals_daily/features/signals/views/widgets/signal_buttons_row.dart';
import 'package:project_3_forex_signals_daily/features/signals/views/widgets/signal_title_row.dart';
import 'package:project_3_forex_signals_daily/features/signals/views/widgets/sl_tp_price_data_row.dart';
import 'package:project_3_forex_signals_daily/features/user_account/viewmodels/user_account_viewmodel.dart';

class SignalWidget extends ConsumerStatefulWidget {
  final SignalModel signaldata;

  const SignalWidget({
    super.key,
    required this.signaldata,
  });

  @override
  ConsumerState<SignalWidget> createState() => _PremiumSignalWidgetState();
}

// bool showDetails = false;

class _PremiumSignalWidgetState extends ConsumerState<SignalWidget> {
  late SignalModel _currentSignalData;

  @override
  void initState() {
    printDebug('=====> premium signal widget : ');
    _currentSignalData = widget.signaldata;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userAccountModel = ref.watch(userAccountViewmodelProvider);
    return InkWell(
      splashFactory: NoSplash.splashFactory, // Disables the splash effect
      onTap: () {
        setState(() {
          printDebug('=====> ${_currentSignalData.isExpanded}');
          _currentSignalData = _currentSignalData.copyWith(
              isExpanded: !_currentSignalData.isExpanded);
        });
        printDebug('=====> ${_currentSignalData.isExpanded}');
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
                    ? Text(
                        'active',
                        style: TextStyle(color: AppColors.blue),
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
            ),
            const SizedBox(height: 4),
            Visibility(
              visible: _currentSignalData.isExpanded,
              child: userAccountModel.when(
                  data: (userAccount) {
                    // todo check if signal is active
                    if (userAccount.isPremium) {
                      return SignalMoreDetailsUnlocked(
                        signaldata: _currentSignalData,
                      );
                    } else {
                      if (_currentSignalData.isSlHit ||
                          _currentSignalData.isTp1Hit) {
                        return SignalMoreDetailsUnlocked(
                          signaldata: _currentSignalData,
                        );
                      } else {
                        return SignalMoreDetailsLocked();
                      }
                    }
                  },
                  error: (error, stack) {
                    return FailureWidget(
                      message: error.toString(),
                    );
                  },
                  loading: () => LoadingWidget()),
            ),
          ],
        ),
      ),
    );
  }
}
