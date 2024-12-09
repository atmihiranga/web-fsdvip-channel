// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserAccountModel {
  final String id;
  final String platform;
  final int installedTimestamp;
  final bool isPremium;
  final String fcmToken;

  UserAccountModel({
    required this.id,
    required this.platform,
    required this.installedTimestamp,
    required this.isPremium,
    required this.fcmToken,
  });

  UserAccountModel copyWith({
    String? id,
    String? platform,
    int? installedTimestamp,
    bool? isPremium,
    String? fcmToken,
  }) {
    return UserAccountModel(
      id: id ?? this.id,
      platform: platform ?? this.platform,
      installedTimestamp: installedTimestamp ?? this.installedTimestamp,
      isPremium: isPremium ?? this.isPremium,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'platform': platform,
      'installedTimestamp': installedTimestamp,
      'isPremium': isPremium,
      'fcmToken': fcmToken,
    };
  }

  factory UserAccountModel.fromMap(Map<String, dynamic> map) {
    return UserAccountModel(
      id: map['id'] as String,
      platform: map['platform'] as String,
      installedTimestamp: map['installedTimestamp'] as int,
      isPremium: map['isPremium'] as bool,
      fcmToken: map['fcmToken'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserAccountModel.fromJson(String source) =>
      UserAccountModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, platform: $platform, installedTimestamp: $installedTimestamp, isPremium: $isPremium, fcmToken :$fcmToken)';
  }

  @override
  bool operator ==(covariant UserAccountModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.platform == platform &&
        other.installedTimestamp == installedTimestamp &&
        other.isPremium == isPremium &&
        other.fcmToken == fcmToken;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        platform.hashCode ^
        installedTimestamp.hashCode ^
        isPremium.hashCode ^
        fcmToken.hashCode;
  }
}
