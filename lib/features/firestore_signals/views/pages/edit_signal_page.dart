// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:project_3_forex_signals_daily/core/models/signal_model.dart';
import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
import 'package:project_3_forex_signals_daily/features/firestore_signals/viewmodels/firestore_signals_viewmodel.dart';

class EditSignalPage extends ConsumerWidget {
  final SignalModel signalData;
  const EditSignalPage({super.key, required this.signalData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO change this
    final SignalModel updated =
        signalData.copyWith(isActive: !signalData.isActive);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${signalData.symbol.toUpperCase()} Signal Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Table(
              border: TableBorder.all(
                  width: 1,
                  color: AppColors.backgroundDarker2,
                  borderRadius: BorderRadius.circular(8)),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(children: [
                  Center(child: Text('id')),
                  Center(child: Text(signalData.id))
                ]),
                TableRow(children: [
                  Center(child: Text('symbol')),
                  Center(child: Text(signalData.symbol.toUpperCase()))
                ]),
                TableRow(
                  children: [
                    Center(child: Text('Action')),
                    Center(child: Text(signalData.action.toString()))
                  ],
                ),
                TableRow(
                  children: [
                    Center(child: Text('Time')),
                    Center(child: Text(signalData.timestamp.toString()))
                  ],
                ),
                TableRow(
                  children: [
                    Center(child: Text('Entry')),
                    Center(child: Text(signalData.entry.toString()))
                  ],
                ),
                TableRow(
                  children: [
                    Center(child: Text('Stop Loss')),
                    Center(child: Text(signalData.sl.toString()))
                  ],
                ),
                TableRow(
                  children: [
                    Center(child: Text('Take Profit 1')),
                    Center(child: Text(signalData.tp1.toString()))
                  ],
                ),
                TableRow(
                  children: [
                    Center(child: Text('Take Profit 2')),
                    Center(child: Text(signalData.tp2.toString()))
                  ],
                ),
                TableRow(
                  children: [
                    Center(child: Text('Take Profit 3')),
                    Center(child: Text(signalData.tp3.toString()))
                  ],
                ),
                TableRow(children: [
                  Center(child: Text('Is Active')),
                  Center(child: Text(signalData.isActive.toString()))
                ]),
                TableRow(
                  children: [
                    Text('Result'),
                    Text(signalData.result.toString())
                  ],
                ),
                TableRow(
                  children: [Text('Note'), Text(signalData.note.toString())],
                ),
              ],
            ),
            TextButton(
                onPressed: () {
                  ref
                      .read(firestoreSignalsViewmodelProvider.notifier)
                      .updateSignal(updated);
                },
                child: Text('Update Signal'))
          ],
        ),
      ),
    );
  }
}

class CustomTableRow extends StatelessWidget {
  const CustomTableRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
