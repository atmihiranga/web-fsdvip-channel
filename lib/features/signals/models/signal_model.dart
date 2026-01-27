class SignalModel {
  String id;
  int timestamp;
  String symbol;
  String action;
  double entry;
  int freeChannelMessageID;
  bool isActive;
  double sl;
  double tp1;
  double tp2;
  double tp3;
  bool isSlHit;
  bool isTp1Hit;
  bool isTp2Hit;
  bool isTp3Hit;
  int pipScale;
  double pnlPips;
  String source;
  int trackingTimestamp;
  double result;
  String note;
  bool isExpanded;
  String analysisLink;
  String analysisResultLink;
  int vipChannelMessageID;

  SignalModel({
    required this.id,
    required this.timestamp,
    required this.symbol,
    required this.action,
    required this.entry,
    required this.freeChannelMessageID,
    required this.isActive,
    required this.sl,
    required this.tp1,
    required this.tp2,
    required this.tp3,
    required this.isSlHit,
    required this.isTp1Hit,
    required this.isTp2Hit,
    required this.isTp3Hit,
    required this.pipScale,
    required this.pnlPips,
    required this.source,
    required this.trackingTimestamp,
    required this.result,
    required this.note,
    required this.isExpanded,
    required this.analysisLink,
    required this.analysisResultLink,
    required this.vipChannelMessageID,
  });

  SignalModel copyWith({
    String? id,
    int? timestamp,
    String? symbol,
    String? action,
    double? entry,
    int? freeChannelMessageID,
    bool? isActive,
    double? sl,
    double? tp1,
    double? tp2,
    double? tp3,
    bool? isSlHit,
    bool? isTp1Hit,
    bool? isTp2Hit,
    bool? isTp3Hit,
    int? pipScale,
    double? pnlPips,
    String? source,
    int? trackingTimestamp,
    double? result,
    String? note,
    bool? isExpanded,
    String? analysisLink,
    String? analysisResultLink,
    int? vipChannelMessageID,
  }) {
    return SignalModel(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      symbol: symbol ?? this.symbol,
      action: action ?? this.action,
      entry: entry ?? this.entry,
      freeChannelMessageID: freeChannelMessageID ?? this.freeChannelMessageID,
      isActive: isActive ?? this.isActive,
      sl: sl ?? this.sl,
      tp1: tp1 ?? this.tp1,
      tp2: tp2 ?? this.tp2,
      tp3: tp3 ?? this.tp3,
      isSlHit: isSlHit ?? this.isSlHit,
      isTp1Hit: isTp1Hit ?? this.isTp1Hit,
      isTp2Hit: isTp2Hit ?? this.isTp2Hit,
      isTp3Hit: isTp3Hit ?? this.isTp3Hit,
      pipScale: pipScale ?? this.pipScale,
      pnlPips: pnlPips ?? this.pnlPips,
      source: source ?? this.source,
      trackingTimestamp: trackingTimestamp ?? this.trackingTimestamp,
      result: result ?? this.result,
      note: note ?? this.note,
      isExpanded: isExpanded ?? this.isExpanded,
      analysisLink: analysisLink ?? this.analysisLink,
      analysisResultLink: analysisResultLink ?? this.analysisResultLink,
      vipChannelMessageID: vipChannelMessageID ?? this.vipChannelMessageID,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp,
      'symbol': symbol,
      'action': action,
      'entry': entry,
      'freeChannelMessageID': freeChannelMessageID,
      'isActive': isActive,
      'sl': sl,
      'tp1': tp1,
      'tp2': tp2,
      'tp3': tp3,
      'isSlHit': isSlHit,
      'isTp1Hit': isTp1Hit,
      'isTp2Hit': isTp2Hit,
      'isTp3Hit': isTp3Hit,
      'pipScale': pipScale,
      'pnlPips': pnlPips,
      'source': source,
      'trackingTimestamp': trackingTimestamp,
      'result': result,
      'note': note,
      'isExpanded': isExpanded,
      'analysisLink': analysisLink,
      'analysisResultLink': analysisResultLink,
      'vipChannelMessageID': vipChannelMessageID,
    };
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  factory SignalModel.fromMap(Map<String, dynamic> map) {
    return SignalModel(
      id: map['id']?.toString() ?? '',
      timestamp: _toInt(map['timestamp']),
      symbol: map['symbol']?.toString() ?? '',
      action: map['action']?.toString() ?? '',
      entry: _toDouble(map['entry']),
      freeChannelMessageID: _toInt(map['freeChannelMessageID']),
      isActive: map['isActive'] == true,
      sl: _toDouble(map['sl']),
      tp1: _toDouble(map['tp1']),
      tp2: _toDouble(map['tp2']),
      tp3: _toDouble(map['tp3']),
      isSlHit: map['isSlHit'] == true,
      isTp1Hit: map['isTp1Hit'] == true,
      isTp2Hit: map['isTp2Hit'] == true,
      isTp3Hit: map['isTp3Hit'] == true,
      pipScale: _toInt(map['pipScale']),
      pnlPips: _toDouble(map['pnlPips']),
      source: map['source']?.toString() ?? '',
      trackingTimestamp: _toInt(map['trackingTimestamp']),
      result: _toDouble(map['result']),
      note: map['note']?.toString() ?? '',
      isExpanded: map['isExpanded'] == true,
      analysisLink: map['analysisLink']?.toString() ?? '',
      analysisResultLink: map['analysisResultLink']?.toString() ?? '',
      vipChannelMessageID: _toInt(map['vipChannelMessageID']),
    );
  }

  Map<String, dynamic> toJson() => toMap();

  factory SignalModel.fromJson(Map<String, dynamic> json) =>
      SignalModel.fromMap(json);

  @override
  String toString() {
    return 'SignalModel(id: $id, timestamp: $timestamp, symbol: $symbol, action: $action, entry: $entry, freeChannelMessageID: $freeChannelMessageID, isActive: $isActive, sl: $sl, tp1: $tp1, tp2: $tp2, tp3: $tp3, isSlHit: $isSlHit, isTp1Hit: $isTp1Hit, isTp2Hit: $isTp2Hit, isTp3Hit: $isTp3Hit, pipScale: $pipScale, pnlPips: $pnlPips, source: $source, trackingTimestamp: $trackingTimestamp, result: $result, note: $note, isExpanded: $isExpanded, analysisLink: $analysisLink, analysisResultLink: $analysisResultLink)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SignalModel &&
        other.id == id &&
        other.timestamp == timestamp &&
        other.symbol == symbol &&
        other.action == action &&
        other.entry == entry &&
        other.freeChannelMessageID == freeChannelMessageID &&
        other.isActive == isActive &&
        other.sl == sl &&
        other.tp1 == tp1 &&
        other.tp2 == tp2 &&
        other.tp3 == tp3 &&
        other.isSlHit == isSlHit &&
        other.isTp1Hit == isTp1Hit &&
        other.isTp2Hit == isTp2Hit &&
        other.isTp3Hit == isTp3Hit &&
        other.pipScale == pipScale &&
        other.pnlPips == pnlPips &&
        other.source == source &&
        other.trackingTimestamp == trackingTimestamp &&
        other.result == result &&
        other.note == note &&
        other.isExpanded == isExpanded &&
        other.analysisLink == analysisLink &&
        other.analysisResultLink == analysisResultLink &&
        other.vipChannelMessageID == vipChannelMessageID;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        timestamp.hashCode ^
        symbol.hashCode ^
        action.hashCode ^
        entry.hashCode ^
        freeChannelMessageID.hashCode ^
        isActive.hashCode ^
        sl.hashCode ^
        tp1.hashCode ^
        tp2.hashCode ^
        tp3.hashCode ^
        isSlHit.hashCode ^
        isTp1Hit.hashCode ^
        isTp2Hit.hashCode ^
        isTp3Hit.hashCode ^
        pipScale.hashCode ^
        pnlPips.hashCode ^
        source.hashCode ^
        trackingTimestamp.hashCode ^
        result.hashCode ^
        note.hashCode ^
        isExpanded.hashCode ^
        analysisLink.hashCode ^
        analysisResultLink.hashCode ^
        vipChannelMessageID.hashCode;
  }
}
