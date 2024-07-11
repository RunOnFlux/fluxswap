import 'dart:convert';
import 'package:http/http.dart' as http;

class ExchangeDetailData {
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

  ExchangeDetailData({
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
  });

  factory ExchangeDetailData.fromJson(Map<String, dynamic> json) {
    return ExchangeDetailData(
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
    );
  }
}

class ExchangeDetailResponse {
  final String status;
  final ExchangeDetailData data;

  ExchangeDetailResponse({
    required this.status,
    required this.data,
  });

  factory ExchangeDetailResponse.fromJson(Map<String, dynamic> json) {
    return ExchangeDetailResponse(
      status: json['status'],
      data: ExchangeDetailData.fromJson(json['data']),
    );
  }
}
