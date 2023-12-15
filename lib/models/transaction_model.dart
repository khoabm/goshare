import 'dart:convert';

import 'package:flutter/foundation.dart';

class TransactionModel {
  final String id;
  final String tripId;
  final double amount;
  final String paymentMethod;
  final String? externalTransactionId;
  final String status;
  final String type;
  final DateTime createTime;
  TransactionModel({
    required this.id,
    required this.tripId,
    required this.amount,
    required this.paymentMethod,
    required this.externalTransactionId,
    required this.status,
    required this.type,
    required this.createTime,
  });

  TransactionModel copyWith({
    String? id,
    String? tripId,
    double? amount,
    String? paymentMethod,
    ValueGetter<String?>? externalTransactionId,
    String? status,
    String? type,
    DateTime? createTime,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      externalTransactionId:
          externalTransactionId?.call() ?? this.externalTransactionId,
      status: status ?? this.status,
      type: type ?? this.type,
      createTime: createTime ?? this.createTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tripId': tripId,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'externalTransactionId': externalTransactionId,
      'status': status,
      'type': type,
      //'createTime': createTime.millisecondsSinceEpoch,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
        id: map['id'] ?? '',
        tripId: map['tripId'] ?? '',
        amount: map['amount']?.toDouble() ?? 0.0,
        paymentMethod: map['paymentMethod'] ?? '',
        externalTransactionId: map['externalTransactionId'],
        status: map['status'] ?? '',
        type: map['type'] ?? '',
        createTime: DateTime.fromMillisecondsSinceEpoch(
          DateTime.parse(map['createTime']).millisecondsSinceEpoch,
        ));
  }

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromJson(String source) =>
      TransactionModel.fromMap(json.decode(source));
}

class WalletTransactionModel {
  final List<TransactionModel> items;
  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;
  WalletTransactionModel({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  WalletTransactionModel copyWith({
    List<TransactionModel>? items,
    int? totalCount,
    int? page,
    int? pageSize,
    int? totalPages,
    bool? hasPreviousPage,
    bool? hasNextPage,
  }) {
    return WalletTransactionModel(
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalPages: totalPages ?? this.totalPages,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((x) => x.toMap()).toList(),
      'totalCount': totalCount,
      'page': page,
      'pageSize': pageSize,
      'totalPages': totalPages,
      'hasPreviousPage': hasPreviousPage,
      'hasNextPage': hasNextPage,
    };
  }

  factory WalletTransactionModel.fromMap(Map<String, dynamic> map) {
    return WalletTransactionModel(
      items: List<TransactionModel>.from(
          map['items']?.map((x) => TransactionModel.fromMap(x))),
      totalCount: map['totalCount']?.toInt() ?? 0,
      page: map['page']?.toInt() ?? 0,
      pageSize: map['pageSize']?.toInt() ?? 0,
      totalPages: map['totalPages']?.toInt() ?? 0,
      hasPreviousPage: map['hasPreviousPage'] ?? false,
      hasNextPage: map['hasNextPage'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory WalletTransactionModel.fromJson(String source) =>
      WalletTransactionModel.fromMap(json.decode(source));
}
