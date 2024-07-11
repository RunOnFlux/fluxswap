import 'dart:convert';
import 'package:http/http.dart' as http;

class SwapHistoryData {
  final String swapId;
  final String buyAddress;
  final String buyAmount;
  final String buyAsset;
  final String buyTxid;
  final int createdAt;
  final String exchangeBuyAssetId;
  final String exchangeId;
  final String exchangeSellAssetId;
  final String rate;
  final String? refundTxid;
  final String sellAmount;
  final String sellAsset;
  final String sellTxid;
  final String status;
  final String zelid;

  SwapHistoryData({
    required this.swapId,
    required this.buyAddress,
    required this.buyAmount,
    required this.buyAsset,
    required this.buyTxid,
    required this.createdAt,
    required this.exchangeBuyAssetId,
    required this.exchangeId,
    required this.exchangeSellAssetId,
    required this.rate,
    this.refundTxid,
    required this.sellAmount,
    required this.sellAsset,
    required this.sellTxid,
    required this.status,
    required this.zelid,
  });

  factory SwapHistoryData.fromJson(Map<String, dynamic> json) {
    return SwapHistoryData(
      swapId: json['swapId'],
      buyAddress: json['buyAddress'],
      buyAmount: json['buyAmount'],
      buyAsset: json['buyAsset'],
      buyTxid: json['buyTxid'],
      createdAt: json['createdAt'],
      exchangeBuyAssetId: json['exchangeBuyAssetId'],
      exchangeId: json['exchangeId'],
      exchangeSellAssetId: json['exchangeSellAssetId'],
      rate: json['rate'],
      refundTxid: json['refundTxid'],
      sellAmount: json['sellAmount'],
      sellAsset: json['sellAsset'],
      sellTxid: json['sellTxid'],
      status: json['status'],
      zelid: json['zelid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'swapId': swapId,
      'buyAddress': buyAddress,
      'buyAmount': buyAmount,
      'buyAsset': buyAsset,
      'buyTxid': buyTxid,
      'createdAt': createdAt,
      'exchangeBuyAssetId': exchangeBuyAssetId,
      'exchangeId': exchangeId,
      'exchangeSellAssetId': exchangeSellAssetId,
      'rate': rate,
      'refundTxid': refundTxid,
      'sellAmount': sellAmount,
      'sellAsset': sellAsset,
      'sellTxid': sellTxid,
      'status': status,
      'zelid': zelid,
    };
  }
}

class UserHistoryResponse {
  final String status;
  final List<SwapHistoryData> data;

  UserHistoryResponse({
    required this.status,
    required this.data,
  });

  factory UserHistoryResponse.fromJson(Map<String, dynamic> json) {
    return UserHistoryResponse(
      status: json['status'],
      data: (json['data'] as List)
          .map((e) => SwapHistoryData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}
