// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseDetailsModel {
  final String productId;
  final String orderId;
  final String iapSource;
  final String type;
  final Timestamp purchaseDate;
  final Timestamp expiryDate;
  final String status;

  PurchaseDetailsModel({
    required this.productId,
    required this.orderId,
    required this.iapSource,
    required this.type,
    required this.purchaseDate,
    required this.expiryDate,
    required this.status,
  });

  PurchaseDetailsModel copyWith({
    String? productId,
    String? orderId,
    String? iapSource,
    String? type,
    Timestamp? purchaseDate,
    Timestamp? expiryDate,
    String? status,
  }) {
    return PurchaseDetailsModel(
      productId: productId ?? this.productId,
      orderId: orderId ?? this.orderId,
      iapSource: iapSource ?? this.iapSource,
      type: type ?? this.type,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expiryDate: expiryDate ?? this.expiryDate,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': productId,
      'orderId': orderId,
      'iapSource': iapSource,
      'type': type,
      'purchaseDate': purchaseDate,
      'expiryDate': expiryDate,
      'status': status,
    };
  }

  factory PurchaseDetailsModel.fromMap(Map<String, dynamic> map) {
    return PurchaseDetailsModel(
      productId: map['productId'] as String,
      orderId: map['orderId'] as String,
      iapSource: map['iapSource'] as String,
      type: map['type'] as String,
      purchaseDate: map['purchaseDate'] as Timestamp,
      expiryDate: map['expiryDate'] as Timestamp,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PurchaseDetailsModel.fromJson(String source) =>
      PurchaseDetailsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PurchaseDetailsModel(productId: $productId, orderId: $orderId, iapSource: $iapSource, type: $type, purchaseDate: $purchaseDate, expiryDate: $expiryDate, status: $status)';
  }

  @override
  bool operator ==(covariant PurchaseDetailsModel other) {
    if (identical(this, other)) return true;

    return other.productId == productId &&
        other.orderId == orderId &&
        other.iapSource == iapSource &&
        other.type == type &&
        other.purchaseDate == purchaseDate &&
        other.expiryDate == expiryDate &&
        other.status == status;
  }

  @override
  int get hashCode {
    return productId.hashCode ^
        orderId.hashCode ^
        iapSource.hashCode ^
        type.hashCode ^
        purchaseDate.hashCode ^
        expiryDate.hashCode ^
        status.hashCode;
  }
}
