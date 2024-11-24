// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:project_3_forex_signals_daily/core/helpers/convert_date.dart';

// import 'package:project_3_forex_signals_daily/core/models/signal_model.dart';
// import 'package:project_3_forex_signals_daily/core/theme/app_colors.dart';
// import 'package:project_3_forex_signals_daily/features/firestore_signals/viewmodels/firestore_signals_viewmodel.dart';

// class UpdateSignalPage extends ConsumerStatefulWidget {
//   final SignalModel signalData;
//   const UpdateSignalPage({
//     super.key,
//     required this.signalData,
//   });

//   @override
//   ConsumerState<UpdateSignalPage> createState() => _UpdateSignalPageState();
// }

// enum ActionValues { buy, sell }

// class _UpdateSignalPageState extends ConsumerState<UpdateSignalPage> {
//   final _symbolController = TextEditingController();
//   final _entryPriceController = TextEditingController();
//   final _stopLossController = TextEditingController();
//   final _takeProfit1Controller = TextEditingController();
//   final _takeProfit2Controller = TextEditingController();
//   final _takeProfit3Controller = TextEditingController();
//   final _resultController = TextEditingController();
//   ActionValues actionValues = ActionValues.buy;

//   @override
//   void dispose() {
//     _symbolController.dispose();
//     // _entryPriceController.dispose();
//     // _stopLossController.dispose();
//     // _takeProfit1Controller.dispose();
//     // _takeProfit2Controller.dispose();
//     // _takeProfit3Controller.dispose();
//     // _resultController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // _symbolController.text = widget.signalData.symbol.toUpperCase();
//     // _entryPriceController.text = widget.signalData.entry.toString();
//     // _stopLossController.text = widget.signalData.sl.toString();
//     // _takeProfit1Controller.text = widget.signalData.tp1.toString();
//     // _takeProfit2Controller.text = widget.signalData.tp2.toString();
//     // _takeProfit3Controller.text = widget.signalData.tp3.toString();
//     // _resultController.text = widget.signalData.result.toString();

//     final SignalModel currentSignalData = widget.signalData;
//     // widget.signalData.copyWith(isActive: !widget.signalData.isActive);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//             'Edit ${widget.signalData.symbol.toUpperCase()} Signal Details'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ListTile(
//               title: InputDecorator(
//                 decoration: InputDecoration(
//                     labelText: 'signal id', border: InputBorder.none),
//                 child: Text(
//                   widget.signalData.id,
//                   style: TextStyle(),
//                 ),
//               ),
//             ),
//             ListTile(
//               title: Text(
//                   'date : ${formatTimestamp(widget.signalData.timestamp)}'),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(widget.signalData.isActive ? 'active ' : 'closed '),
//                   Switch.adaptive(
//                     value: widget.signalData.isActive,
//                     onChanged: (onChanged) {},
//                     activeColor: AppColors.green,
//                   )
//                 ],
//               ),
//             ),
//             ListTile(
//               title: CustomTextField(
//                 controller: _symbolController,
//                 isNumberKeyboard: false,
//                 label: 'symbol',
//               ),
//             ),
//             ListTile(
//               title: InputDecorator(
//                   decoration: InputDecoration(
//                     labelText: 'action',
//                     border: OutlineInputBorder(),
//                   ),
//                   child: Row(
//                     children: [
//                       Radio(
//                           value: ActionValues.buy,
//                           groupValue: actionValues,
//                           onChanged: (onChanged) {}),
//                       Text('BUY'),
//                       Radio(
//                           value: ActionValues.sell,
//                           groupValue: actionValues,
//                           onChanged: (onChanged) {}),
//                       Text('SELL')
//                     ],
//                   )),
//             ),
//             ListTile(
//               title: CustomTextField(
//                 controller: _entryPriceController,
//                 label: 'entry price',
//               ),
//             ),
//             ListTile(
//               title: CustomTextField(
//                 controller: _stopLossController,
//                 label: 'stop loss',
//               ),
//               trailing: Checkbox.adaptive(
//                 value: widget.signalData.isSlHit,
//                 onChanged: (onChanged) {},
//                 activeColor: AppColors.red,
//               ),
//             ),
//             ListTile(
//               title: CustomTextField(
//                 controller: _takeProfit1Controller,
//                 label: 'take profit 1',
//               ),
//               trailing: Checkbox.adaptive(
//                 value: widget.signalData.isTp1Hit,
//                 onChanged: (onChanged) {},
//                 activeColor: AppColors.green,
//               ),
//             ),
//             ListTile(
//               title: CustomTextField(
//                 controller: _takeProfit2Controller,
//                 label: 'take profit 2',
//               ),
//               trailing: Checkbox.adaptive(
//                 value: widget.signalData.isTp2Hit,
//                 onChanged: (onChanged) {},
//                 activeColor: AppColors.green,
//               ),
//             ),
//             ListTile(
//               title: CustomTextField(
//                 controller: _takeProfit3Controller,
//                 label: 'take profit 3',
//               ),
//               trailing: Checkbox.adaptive(
//                 value: widget.signalData.isTp3Hit,
//                 onChanged: (onChanged) {},
//                 activeColor: AppColors.green,
//               ),
//             ),
//             TextButton(
//                 onPressed: () {
//                   ref
//                       .read(firestoreSignalsViewmodelProvider.notifier)
//                       .updateSignal(currentSignalData);
//                 },
//                 child: Text('Update Signal'))
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CustomTextField extends ConsumerWidget {
//   const CustomTextField({
//     super.key,
//     required this.controller,
//     required this.label,
//     this.isNumberKeyboard = true,
//   });

//   final TextEditingController controller;
//   final String label;
//   final bool isNumberKeyboard;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: isNumberKeyboard
//           ? TextInputType.numberWithOptions(signed: true, decimal: true)
//           : TextInputType.text,
//       decoration:
//           InputDecoration(label: Text(label), border: OutlineInputBorder()),
//     );
//   }
// }
