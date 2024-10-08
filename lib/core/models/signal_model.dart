// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SignalModel {
  final String id;
  final String symbol;
  final String action;
  final double entry;
  final double sl;
  final double tp1;
  final double tp2;
  final double tp3;
  final bool active;
  final String result;

  SignalModel({
    required this.id,
    required this.symbol,
    required this.action,
    required this.entry,
    required this.sl,
    required this.tp1,
    required this.tp2,
    required this.tp3,
    required this.active,
    required this.result,
  });

  SignalModel copyWith({
    String? id,
    String? symbol,
    String? action,
    double? entry,
    double? sl,
    double? tp1,
    double? tp2,
    double? tp3,
    bool? active,
    String? result,
  }) {
    return SignalModel(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      action: action ?? this.action,
      entry: entry ?? this.entry,
      sl: sl ?? this.sl,
      tp1: tp1 ?? this.tp1,
      tp2: tp2 ?? this.tp2,
      tp3: tp3 ?? this.tp3,
      active: active ?? this.active,
      result: result ?? this.result,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'symbol': symbol,
      'action': action,
      'entry': entry,
      'sl': sl,
      'tp1': tp1,
      'tp2': tp2,
      'tp3': tp3,
      'active': active,
      'result': result,
    };
  }

  factory SignalModel.fromMap(Map<String, dynamic> map) {
    return SignalModel(
      id: map['id'] as String,
      symbol: map['symbol'] as String,
      action: map['action'] as String,
      entry: map['entry'] as double,
      sl: map['sl'] as double,
      tp1: map['tp1'] as double,
      tp2: map['tp2'] as double,
      tp3: map['tp3'] as double,
      active: map['active'] as bool,
      result: map['result'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SignalModel.fromJson(String source) =>
      SignalModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SignalModel(id: $id, symbol: $symbol, action: $action, entry: $entry, sl: $sl, tp1: $tp1, tp2: $tp2, tp3: $tp3, active: $active, result: $result)';
  }

  @override
  bool operator ==(covariant SignalModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.symbol == symbol &&
        other.action == action &&
        other.entry == entry &&
        other.sl == sl &&
        other.tp1 == tp1 &&
        other.tp2 == tp2 &&
        other.tp3 == tp3 &&
        other.active == active &&
        other.result == result;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        symbol.hashCode ^
        action.hashCode ^
        entry.hashCode ^
        sl.hashCode ^
        tp1.hashCode ^
        tp2.hashCode ^
        tp3.hashCode ^
        active.hashCode ^
        result.hashCode;
  }
}
