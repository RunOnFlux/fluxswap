import 'dart:convert';
import 'package:http/http.dart' as http;

class ExchangeDetail {
  final String exchangeId;
  final String minSellAmount;
  final String maxSellAmount;
  final String rate;
  final String precision;
  final String? sellAmount;
  final String? buyAmount;
  final String? rateId;

  ExchangeDetail({
    required this.exchangeId,
    required this.minSellAmount,
    required this.maxSellAmount,
    required this.rate,
    required this.precision,
    this.sellAmount,
    this.buyAmount,
    this.rateId,
  });

  factory ExchangeDetail.fromJson(Map<String, dynamic> json) {
    return ExchangeDetail(
      exchangeId: json['exchangeId'] ?? '',
      minSellAmount: json['minSellAmount'] ?? '',
      maxSellAmount: json['maxSellAmount'] ?? '',
      rate: json['rate'] ?? '',
      precision: json['precision'] ?? '',
      sellAmount: json['sellAmount'] as String?,
      buyAmount: json['buyAmount'] as String?,
      rateId: json['rateId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exchangeId': exchangeId,
      'minSellAmount': minSellAmount,
      'maxSellAmount': maxSellAmount,
      'rate': rate,
      'precision': precision,
      'sellAmount': sellAmount,
      'buyAmount': buyAmount,
      'rateId': rateId,
    };
  }
}

class PairDetails {
  final String sellAsset;
  final String buyAsset;
  final List<ExchangeDetail> exchanges;

  PairDetails({
    required this.sellAsset,
    required this.buyAsset,
    required this.exchanges,
  });

  factory PairDetails.fromJson(Map<String, dynamic> json) {
    return PairDetails(
      sellAsset: json['sellAsset'],
      buyAsset: json['buyAsset'],
      exchanges: (json['exchanges'] as List)
          .map((e) => ExchangeDetail.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sellAsset': sellAsset,
      'buyAsset': buyAsset,
      'exchanges': exchanges.map((e) => e.toJson()).toList(),
    };
  }
}
