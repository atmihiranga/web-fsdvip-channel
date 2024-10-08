// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String id;
  final String platform;
  final int installedTimestamp;

  UserModel({
    required this.id,
    required this.platform,
    required this.installedTimestamp,
  });

  UserModel copyWith({
    String? id,
    String? platform,
    int? installedTimestamp,
  }) {
    return UserModel(
      id: id ?? this.id,
      platform: platform ?? this.platform,
      installedTimestamp: installedTimestamp ?? this.installedTimestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'platform': platform,
      'installedTimestamp': installedTimestamp,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      platform: map['platform'] as String,
      installedTimestamp: map['installedTimestamp'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'UserModel(id: $id, platform: $platform, installedTimestamp: $installedTimestamp)';

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.platform == platform &&
        other.installedTimestamp == installedTimestamp;
  }

  @override
  int get hashCode =>
      id.hashCode ^ platform.hashCode ^ installedTimestamp.hashCode;
}
