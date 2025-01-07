// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DataPoint {
  final int timestamp;
  final double result;

  DataPoint({
    required this.timestamp,
    required this.result,
  });

  DataPoint copyWith({
    int? timestamp,
    double? result,
  }) {
    return DataPoint(
      timestamp: timestamp ?? this.timestamp,
      result: result ?? this.result,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'timestamp': timestamp,
      'result': result,
    };
  }

  factory DataPoint.fromMap(Map<String, dynamic> map) {
    return DataPoint(
      timestamp: map['timestamp'] as int,
      result: map['result'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory DataPoint.fromJson(String source) =>
      DataPoint.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DataPoint(timestamp: $timestamp, result: $result)';

  @override
  bool operator ==(covariant DataPoint other) {
    if (identical(this, other)) return true;

    return other.timestamp == timestamp && other.result == result;
  }

  @override
  int get hashCode => timestamp.hashCode ^ result.hashCode;
}
