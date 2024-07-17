import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateSwapRequest {
  final String exchangeId;
  final String sellAsset;
  final String buyAsset;
  final String sellAmount;
  final String buyAddress;
  final String refundAddress;
  final String? rateId;

  CreateSwapRequest({
    required this.exchangeId,
    required this.sellAsset,
    required this.buyAsset,
    required this.sellAmount,
    required this.buyAddress,
    required this.refundAddress,
    this.rateId,
  });

  Map<String, dynamic> toJson() {
    return {
      'exchangeId': exchangeId,
      'sellAsset': sellAsset,
      'buyAsset': buyAsset,
      'sellAmount': sellAmount,
      'buyAddress': buyAddress,
      'refundAddress': refundAddress,
      'rateid': rateId
    };
  }
}

class CreateSwapResponse {
  final String exchangeId;
  final String sellAsset;
  final String buyAsset;
  final String swapId;
  final String sellAmount;
  final String buyAmount;
  final String refundAddress;
  final String buyAddress;
  final String? refundAddressExtraId;
  final String? buyAddressExtraId;
  final String depositAddress;
  final String? depositExtraId;
  final String status;
  final int createdAt;
  final bool kycRequired;
  final String? rateId;
  final String rate;
  final int validTill;

  CreateSwapResponse({
    required this.exchangeId,
    required this.sellAsset,
    required this.buyAsset,
    required this.swapId,
    required this.sellAmount,
    required this.buyAmount,
    required this.refundAddress,
    required this.buyAddress,
    this.refundAddressExtraId,
    this.buyAddressExtraId,
    required this.depositAddress,
    this.depositExtraId,
    required this.status,
    required this.createdAt,
    required this.kycRequired,
    this.rateId,
    required this.rate,
    required this.validTill,
  });

  factory CreateSwapResponse.fromJson(Map<String, dynamic> json) {
    return CreateSwapResponse(
      exchangeId: json['exchangeId'],
      sellAsset: json['sellAsset'],
      buyAsset: json['buyAsset'],
      swapId: json['swapId'],
      sellAmount: json['sellAmount'],
      buyAmount: json['buyAmount'],
      refundAddress: json['refundAddress'],
      buyAddress: json['buyAddress'],
      refundAddressExtraId: json['refundAddressExtraId'],
      buyAddressExtraId: json['buyAddressExtraId'],
      depositAddress: json['depositAddress'],
      depositExtraId: json['depositExtraId'],
      status: json['status'],
      createdAt: json['createdAt'],
      kycRequired: json['kycRequired'],
      rateId: json['rateId'],
      rate: json['rate'],
      validTill: json['validTill'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exchangeId': exchangeId,
      'sellAsset': sellAsset,
      'buyAsset': buyAsset,
      'swapId': swapId,
      'sellAmount': sellAmount,
      'buyAmount': buyAmount,
      'refundAddress': refundAddress,
      'buyAddress': buyAddress,
      'refundAddressExtraId': refundAddressExtraId,
      'buyAddressExtraId': buyAddressExtraId,
      'depositAddress': depositAddress,
      'depositExtraId': depositExtraId,
      'status': status,
      'createdAt': createdAt,
      'kycRequired': kycRequired,
      'rateId': rateId,
      'rate': rate,
      'validTill': validTill,
    };
  }
}
