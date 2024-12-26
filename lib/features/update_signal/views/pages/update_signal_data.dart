import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/helpers/convert_date.dart';
import 'package:project_3_forex_signals_daily/core/models/signal_model.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import 'package:project_3_forex_signals_daily/core/widgets/loading_widget.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:project_3_forex_signals_daily/features/signals/viewmodels/signals_viewmodel.dart';

class UpdateSignalDataPage extends ConsumerStatefulWidget {
  final SignalModel signalData;
  const UpdateSignalDataPage({super.key, required this.signalData});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateSignalDataPageState();
}

class _UpdateSignalDataPageState extends ConsumerState<UpdateSignalDataPage> {
  late SignalModel currentSignalData;

  late String _signalId;
  late int _timestamp;
  final _symbolController = TextEditingController();
  late String _action;
  final _entryPriceController = TextEditingController();
  final _stopLossController = TextEditingController();
  late bool _isSlHit;
  final _takeProfit1Controller = TextEditingController();
  late bool _isTp1Hit;
  final _takeProfit2Controller = TextEditingController();
  late bool _isTp2Hit;
  final _takeProfit3Controller = TextEditingController();
  late bool _isTp3Hit;
  late bool _isActive;
  final _resultController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void initState() {
    currentSignalData = widget.signalData;
    _signalId = currentSignalData.id.toString();
    _timestamp = currentSignalData.timestamp;
    _symbolController.text = currentSignalData.symbol.toUpperCase();
    _entryPriceController.text = currentSignalData.entry.toString();
    _stopLossController.text = currentSignalData.sl.toString();
    _takeProfit1Controller.text = currentSignalData.tp1.toString();
    _takeProfit2Controller.text = currentSignalData.tp2.toString();
    _takeProfit3Controller.text = currentSignalData.tp3.toString();
    _resultController.text = currentSignalData.result.toString();
    _noteController.text = currentSignalData.note.toString();
    _isActive = currentSignalData.isActive;
    _action = currentSignalData.action;
    _isSlHit = currentSignalData.isSlHit;
    _isTp1Hit = currentSignalData.isTp1Hit;
    _isTp2Hit = currentSignalData.isTp2Hit;
    _isTp3Hit = currentSignalData.isTp3Hit;
    super.initState();
  }

  SignalModel _updateSignalData() {
    final SignalModel updatedSignalData = currentSignalData.copyWith(
        id: _signalId,
        timestamp: _timestamp,
        symbol: _symbolController.text,
        action: _action,
        entry: double.parse(_entryPriceController.text),
        sl: double.parse(_stopLossController.text),
        isSlHit: _isSlHit,
        tp1: double.parse(_takeProfit1Controller.text),
        isTp1Hit: _isTp1Hit,
        tp2: double.parse(_takeProfit2Controller.text),
        isTp2Hit: _isTp2Hit,
        tp3: double.parse(_takeProfit3Controller.text),
        isTp3Hit: _isTp3Hit,
        isActive: _isActive,
        result: double.parse(_resultController.text),
        note: _noteController.text);
    return updatedSignalData;
  }

  void _deleteSignal(SignalModel signal) {
    ref.read(signalsViewmodelProvider.notifier).deleteSignal(signal);
  }

  @override
  void dispose() {
    _symbolController.dispose();
    _entryPriceController.dispose();
    _stopLossController.dispose();
    _takeProfit1Controller.dispose();
    _takeProfit2Controller.dispose();
    _takeProfit3Controller.dispose();
    _resultController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(signalsViewmodelProvider).isLoading == false;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${currentSignalData.symbol.toUpperCase()} Signal'),
        actions: [
          InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showMaterialBanner(
                  MaterialBanner(
                    content: Text('Long Press to delete signal!'),
                    leading: Icon(Icons.info),
                    //backgroundColor: Colors.blue[50],
                    actions: [
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                              .hideCurrentMaterialBanner();
                        },
                        child: Text('Dismiss'),
                      ),
                    ],
                  ),
                );
              },
              onLongPress: () {
                _deleteSignal(currentSignalData);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.delete,
                  color: AppColors.red,
                ),
              ))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: InputDecorator(
                      decoration: InputDecoration(
                          labelText: 'signal doc id', border: InputBorder.none),
                      child: Text(
                        _signalId,
                        style: TextStyle(),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('date : ${formatTimestamp(_timestamp)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_isActive ? 'active ' : 'closed '),
                        Switch.adaptive(
                          value: _isActive,
                          onChanged: (onChanged) {
                            setState(() {
                              _isActive = onChanged;
                            });
                          },
                          activeColor: AppColors.blue,
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    title: CustomTextField(
                      controller: _symbolController,
                      isNumberKeyboard: false,
                      label: 'symbol',
                    ),
                  ),
                  ListTile(
                    title: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'action',
                          border: OutlineInputBorder(),
                        ),
                        child: Row(
                          children: [
                            Radio(
                                value: 'BUY',
                                groupValue: _action.toUpperCase(),
                                activeColor: AppColors.green,
                                onChanged: (onChanged) {
                                  setState(() {
                                    _action = onChanged!;
                                  });
                                }),
                            Text('BUY'),
                            Radio(
                                value: 'SELL',
                                groupValue: _action.toUpperCase(),
                                activeColor: AppColors.red,
                                onChanged: (onChanged) {
                                  setState(() {
                                    _action = onChanged!;
                                  });
                                }),
                            Text('SELL')
                          ],
                        )),
                  ),
                  ListTile(
                    title: CustomTextField(
                      controller: _entryPriceController,
                      label: 'entry price',
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _stopLossController,
                            label: 'stop loss',
                          ),
                        ),
                      ],
                    ),
                    trailing: Checkbox.adaptive(
                      value: _isSlHit,
                      onChanged: (onChanged) {
                        setState(() {
                          _isSlHit = onChanged!;
                          if (onChanged) {
                            _isActive = false;
                            _isTp1Hit = false;
                            _isTp2Hit = false;
                            _isTp3Hit = false;
                          }
                        });
                      },
                      activeColor: AppColors.red,
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _takeProfit1Controller,
                            label: 'take profit 1',
                          ),
                        ),
                      ],
                    ),
                    trailing: Checkbox.adaptive(
                      value: _isTp1Hit,
                      onChanged: (onChanged) {
                        printDebug('isTp1Hit : $onChanged');
                        setState(() {
                          _isTp1Hit = onChanged!;
                          if (onChanged) {
                            _isSlHit = false;
                          }
                        });
                      },
                      activeColor: AppColors.green,
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _takeProfit2Controller,
                            label: 'take profit 2',
                          ),
                        ),
                      ],
                    ),
                    trailing: Checkbox.adaptive(
                      value: _isTp2Hit,
                      onChanged: (onChanged) {
                        setState(() {
                          _isTp2Hit = onChanged!;
                          if (onChanged) {
                            _isSlHit = false;
                            _isTp1Hit = true;
                          }
                        });
                      },
                      activeColor: AppColors.green,
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _takeProfit3Controller,
                            label: 'take profit 3',
                          ),
                        ),
                      ],
                    ),
                    trailing: Checkbox.adaptive(
                      value: _isTp3Hit,
                      onChanged: (onChanged) {
                        setState(() {
                          _isTp3Hit = onChanged!;
                          if (onChanged) {
                            _isSlHit = false;
                            _isTp1Hit = true;
                            _isTp2Hit = true;
                          }
                        });
                      },
                      activeColor: AppColors.green,
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _resultController,
                            label: 'result',
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _noteController,
                            label: 'note',
                            isNumberKeyboard: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showMaterialBanner(
                MaterialBanner(
                  content: Text('Long Press to submit changes!'),
                  leading: Icon(Icons.info),
                  //backgroundColor: Colors.blue[50],
                  actions: [
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                            .hideCurrentMaterialBanner();
                      },
                      child: Text('Dismiss'),
                    ),
                  ],
                ),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Update'),
                Visibility(visible: !isLoading, child: LoadingWidget())
              ],
            ),
            onLongPress: () {
              final SignalModel updatedSignalData = _updateSignalData();
              ref
                  .read(signalsViewmodelProvider.notifier)
                  .updateSignal(updatedSignalData)
                  .then((onValue) {
                printDebug('=====> updated');
              });
            },
          ),
        ],
      ),
    );
  }
}

class CustomTextField extends ConsumerWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.isNumberKeyboard = true,
  });

  final TextEditingController controller;
  final String label;
  final bool isNumberKeyboard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumberKeyboard
          ? TextInputType.numberWithOptions(signed: true, decimal: true)
          : TextInputType.text,
      decoration:
          InputDecoration(label: Text(label), border: OutlineInputBorder()),
    );
  }
}
