// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// NOTE : This data class is a generated code, if regenerate modify SignalModel.fromMap functions 'as String' type casting to ?? ' ' to avoid null errors
// tutorial : https://youtu.be/CWvlOU2Y3Ik?t=10781

class SignalModel {
  final String id;
  final int timestamp;
  final String symbol;
  final String action;
  final double entry;
  final double sl;
  final bool isSlHit;
  final double tp1;
  final bool isTp1Hit;
  final double tp2;
  final bool isTp2Hit;
  final double tp3;
  final bool isTp3Hit;
  final bool isActive;
  final double result;
  final String note;
  final bool isExpanded;

  SignalModel({
    required this.id,
    required this.timestamp,
    required this.symbol,
    required this.action,
    required this.entry,
    required this.sl,
    required this.isSlHit,
    required this.tp1,
    required this.isTp1Hit,
    required this.tp2,
    required this.isTp2Hit,
    required this.tp3,
    required this.isTp3Hit,
    required this.isActive,
    required this.result,
    required this.note,
    required this.isExpanded,
  });

  SignalModel copyWith({
    String? id,
    int? timestamp,
    String? symbol,
    String? action,
    double? entry,
    double? sl,
    bool? isSlHit,
    double? tp1,
    bool? isTp1Hit,
    double? tp2,
    bool? isTp2Hit,
    double? tp3,
    bool? isTp3Hit,
    bool? isActive,
    double? result,
    String? note,
    bool? isExpanded,
  }) {
    return SignalModel(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      symbol: symbol ?? this.symbol,
      action: action ?? this.action,
      entry: entry ?? this.entry,
      sl: sl ?? this.sl,
      isSlHit: isSlHit ?? this.isSlHit,
      tp1: tp1 ?? this.tp1,
      isTp1Hit: isTp1Hit ?? this.isTp1Hit,
      tp2: tp2 ?? this.tp2,
      isTp2Hit: isTp2Hit ?? this.isTp2Hit,
      tp3: tp3 ?? this.tp3,
      isTp3Hit: isTp3Hit ?? this.isTp3Hit,
      isActive: isActive ?? this.isActive,
      result: result ?? this.result,
      note: note ?? this.note,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'timestamp': timestamp,
      'symbol': symbol,
      'action': action,
      'entry': entry,
      'sl': sl,
      'isSlHit': isSlHit,
      'tp1': tp1,
      'isTp1Hit': isTp1Hit,
      'tp2': tp2,
      'isTp2Hit': isTp2Hit,
      'tp3': tp3,
      'isTp3Hit': isTp3Hit,
      'isActive': isActive,
      'result': result,
      'note': note,
      'isExpanded': isExpanded,
    };
  }

  factory SignalModel.fromMap(Map<String, dynamic> map) {
    return SignalModel(
      id: map['id'] as String,
      timestamp: map['timestamp'] as int,
      symbol: map['symbol'] as String,
      action: map['action'] as String,
      entry: map['entry'] as double,
      sl: map['sl'] as double,
      isSlHit: map['isSlHit'] as bool,
      tp1: map['tp1'] as double,
      isTp1Hit: map['isTp1Hit'] as bool,
      tp2: map['tp2'] as double,
      isTp2Hit: map['isTp2Hit'] as bool,
      tp3: map['tp3'] as double,
      isTp3Hit: map['isTp3Hit'] as bool,
      isActive: map['isActive'] as bool,
      result: map['result'] as double,
      note: map['note'] as String,
      isExpanded: map['isExpanded'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory SignalModel.fromJson(String source) =>
      SignalModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SignalModel(id: $id, timestamp: $timestamp, symbol: $symbol, action: $action, entry: $entry, sl: $sl, isSlHit: $isSlHit, tp1: $tp1, isTp1Hit: $isTp1Hit, tp2: $tp2, isTp2Hit: $isTp2Hit, tp3: $tp3, isTp3Hit: $isTp3Hit, isActive: $isActive, result: $result, note: $note, isExpanded: $isExpanded)';
  }

  @override
  bool operator ==(covariant SignalModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.timestamp == timestamp &&
        other.symbol == symbol &&
        other.action == action &&
        other.entry == entry &&
        other.sl == sl &&
        other.isSlHit == isSlHit &&
        other.tp1 == tp1 &&
        other.isTp1Hit == isTp1Hit &&
        other.tp2 == tp2 &&
        other.isTp2Hit == isTp2Hit &&
        other.tp3 == tp3 &&
        other.isTp3Hit == isTp3Hit &&
        other.isActive == isActive &&
        other.result == result &&
        other.note == note &&
        other.isExpanded == isExpanded;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        timestamp.hashCode ^
        symbol.hashCode ^
        action.hashCode ^
        entry.hashCode ^
        sl.hashCode ^
        isSlHit.hashCode ^
        tp1.hashCode ^
        isTp1Hit.hashCode ^
        tp2.hashCode ^
        isTp2Hit.hashCode ^
        tp3.hashCode ^
        isTp3Hit.hashCode ^
        isActive.hashCode ^
        result.hashCode ^
        note.hashCode ^
        isExpanded.hashCode;
  }
}
