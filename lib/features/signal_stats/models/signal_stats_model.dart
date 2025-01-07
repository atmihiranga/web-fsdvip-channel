// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:project_3_forex_signals_daily/core/helpers/convert_date.dart';
import 'package:project_3_forex_signals_daily/features/signal_stats/models/data_points.dart';

class SignalStatsModel {
  final int closed;
  final int slHit;
  final int tp1Hit;
  final int tp2Hit;
  final int tp3Hit;
  final double profitPips;
  final double lossPips;
  final int lastUpdate;
  final Map<String, dynamic> resultsMap;

  SignalStatsModel({
    required this.closed,
    required this.slHit,
    required this.tp1Hit,
    required this.tp2Hit,
    required this.tp3Hit,
    required this.profitPips,
    required this.lossPips,
    required this.lastUpdate,
    required this.resultsMap,
  });

  SignalStatsModel copyWith({
    int? closed,
    int? slHit,
    int? tp1Hit,
    int? tp2Hit,
    int? tp3Hit,
    double? profitPips,
    double? lossPips,
    int? lastUpdate,
    Map<String, dynamic>? resultsMap,
  }) {
    return SignalStatsModel(
      closed: closed ?? this.closed,
      slHit: slHit ?? this.slHit,
      tp1Hit: tp1Hit ?? this.tp1Hit,
      tp2Hit: tp2Hit ?? this.tp2Hit,
      tp3Hit: tp3Hit ?? this.tp3Hit,
      profitPips: profitPips ?? this.profitPips,
      lossPips: lossPips ?? this.lossPips,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      resultsMap: resultsMap ?? this.resultsMap,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'closed': closed,
      'slHit': slHit,
      'tp1Hit': tp1Hit,
      'tp2Hit': tp2Hit,
      'tp3Hit': tp3Hit,
      'profitPips': profitPips,
      'lossPips': lossPips,
      'lastUpdate': lastUpdate,
      'resultsMap': resultsMap,
    };
  }

  factory SignalStatsModel.fromMap(Map<String, dynamic> map) {
    return SignalStatsModel(
        closed: (map['closed'] as num?)?.toInt() ?? 0,
        slHit: (map['slHit'] as num?)?.toInt() ?? 0,
        tp1Hit: (map['tp1Hit'] as num?)?.toInt() ?? 0,
        tp2Hit: (map['tp2Hit'] as num?)?.toInt() ?? 0,
        tp3Hit: (map['tp3Hit'] as num?)?.toInt() ?? 0,
        profitPips: convertToDouble(map['profitPips']) ?? 0.0,
        lossPips: convertToDouble(map['lossPips']) ?? 0.0,
        lastUpdate: (map['lastUpdate'] as num?)?.toInt() ?? 0,
        resultsMap: map['resultsMap'] as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  factory SignalStatsModel.fromJson(String source) =>
      SignalStatsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SignalStatsModel(closed: $closed, slHit: $slHit, tp1Hit: $tp1Hit, tp2Hit: $tp2Hit, tp3Hit: $tp3Hit, profitPips: $profitPips, lossPips: $lossPips, lastUpdate: $lastUpdate, resultsMap: $resultsMap)';
  }

  @override
  bool operator ==(covariant SignalStatsModel other) {
    if (identical(this, other)) return true;

    return other.closed == closed &&
        other.slHit == slHit &&
        other.tp1Hit == tp1Hit &&
        other.tp2Hit == tp2Hit &&
        other.tp3Hit == tp3Hit &&
        other.profitPips == profitPips &&
        other.lossPips == lossPips &&
        other.lastUpdate == lastUpdate &&
        mapEquals(other.resultsMap, resultsMap);
  }

  @override
  int get hashCode {
    return closed.hashCode ^
        slHit.hashCode ^
        tp1Hit.hashCode ^
        tp2Hit.hashCode ^
        tp3Hit.hashCode ^
        profitPips.hashCode ^
        lossPips.hashCode ^
        lastUpdate.hashCode ^
        resultsMap.hashCode;
  }
}
