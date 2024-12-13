// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserAccountModel {
  final String id;
  final String platform;
  final int installedTimestamp;
  final bool isPremium;
  final String fcmToken;
  final String email;
  final bool isAnonymous;

  UserAccountModel({
    required this.id,
    required this.platform,
    required this.installedTimestamp,
    required this.isPremium,
    required this.fcmToken,
    required this.email,
    required this.isAnonymous,
  });

  UserAccountModel copyWith({
    String? id,
    String? platform,
    int? installedTimestamp,
    bool? isPremium,
    String? fcmToken,
    String? email,
    bool? isAnonymous,
  }) {
    return UserAccountModel(
      id: id ?? this.id,
      platform: platform ?? this.platform,
      installedTimestamp: installedTimestamp ?? this.installedTimestamp,
      isPremium: isPremium ?? this.isPremium,
      fcmToken: fcmToken ?? this.fcmToken,
      email: email ?? this.email,
      isAnonymous: isAnonymous ?? this.isAnonymous,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'platform': platform,
      'installedTimestamp': installedTimestamp,
      'isPremium': isPremium,
      'fcmToken': fcmToken,
      'email': email,
      'isAnonymous': isAnonymous,
    };
  }

  factory UserAccountModel.fromMap(Map<String, dynamic> map) {
    return UserAccountModel(
      id: map['id'] ?? '',
      platform: map['platform'] ?? defaultTargetPlatform.toString(),
      installedTimestamp: map['installedTimestamp'] ?? 0,
      isPremium: map['isPremium'] ?? false,
      fcmToken: map['fcmToken'] ?? '',
      email: map['email'] ?? '',
      isAnonymous: map['isAnonymous'] ?? true,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserAccountModel.fromJson(String source) =>
      UserAccountModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, platform: $platform, installedTimestamp: $installedTimestamp, isPremium: $isPremium, fcmToken :$fcmToken, email : $email, isAnonymous: $isAnonymous)';
  }

  @override
  bool operator ==(covariant UserAccountModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.platform == platform &&
        other.installedTimestamp == installedTimestamp &&
        other.isPremium == isPremium &&
        other.fcmToken == fcmToken &&
        other.email == email &&
        other.isAnonymous == isAnonymous;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        platform.hashCode ^
        installedTimestamp.hashCode ^
        isPremium.hashCode ^
        fcmToken.hashCode ^
        email.hashCode ^
        isAnonymous.hashCode;
  }
}
