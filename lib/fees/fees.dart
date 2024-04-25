import 'dart:convert';
import 'package:http/http.dart' as http;
import '/helper/modals.dart';

class SwapInfoResponse {
  String status;
  List<String> chains;
  List<Coin> coins;
  List<Confirmation> confirmations;
  Fees fees;
  List<SwapAddress> swapAddresses;

  SwapInfoResponse({
    required this.status,
    required this.chains,
    required this.coins,
    required this.confirmations,
    required this.fees,
    required this.swapAddresses,
  });

  factory SwapInfoResponse.fromJson(Map<String, dynamic> json) =>
      SwapInfoResponse(
        status: json['status'],
        chains: List<String>.from(json['data']['chains']),
        coins:
            List<Coin>.from(json['data']['coins'].map((x) => Coin.fromJson(x))),
        confirmations: List<Confirmation>.from(
            json['data']['confirmations'].map((x) => Confirmation.fromJson(x))),
        fees: Fees.fromJson(json['data']['fees']),
        swapAddresses: List<SwapAddress>.from(
            json['data']['swapAddresses'].map((x) => SwapAddress.fromJson(x))),
      );
}

class Coin {
  String coin;
  String chain;

  Coin({required this.coin, required this.chain});

  factory Coin.fromJson(Map<String, dynamic> json) => Coin(
        coin: json['coin'],
        chain: json['chain'],
      );
}

class Confirmation {
  int confirmations;
  int amount;

  Confirmation({required this.confirmations, required this.amount});

  factory Confirmation.fromJson(Map<String, dynamic> json) => Confirmation(
        confirmations: json['confirmations'],
        amount: json['amount'],
      );
}

class Fees {
  FeeTypes snapshot;
  FeeTypes mining;
  FeeTypesSwap swap;

  Fees({required this.snapshot, required this.mining, required this.swap});

  factory Fees.fromJson(Map<String, dynamic> json) => Fees(
        snapshot: FeeTypes.fromJson(json['snapshot']),
        mining: FeeTypes.fromJson(json['mining']),
        swap: FeeTypesSwap.fromJson(json['swap']),
      );
}

class FeeTypes {
  double percentage;
  Map<String, double> specificFees;

  FeeTypes({required this.percentage, required this.specificFees});

  factory FeeTypes.fromJson(Map<String, dynamic> json) {
    return FeeTypes(
      percentage: json['percentage'],
      specificFees: json
          .map((key, value) => MapEntry(key, double.parse(value.toString()))),
    );
  }
}

class FeeTypesSwap {
  double percentage;
  double premiumPercentage;
  Map<String, double> specificFees;

  FeeTypesSwap(
      {required this.percentage,
      required this.premiumPercentage,
      required this.specificFees});

  factory FeeTypesSwap.fromJson(Map<String, dynamic> json) {
    return FeeTypesSwap(
      percentage: json['percentage'],
      premiumPercentage: json['premiumPercentage'],
      specificFees: json
          .map((key, value) => MapEntry(key, double.parse(value.toString()))),
    );
  }
}

class SwapAddress {
  String chain;
  String address;

  SwapAddress({required this.chain, required this.address});

  factory SwapAddress.fromJson(Map<String, dynamic> json) => SwapAddress(
        chain: json['chain'],
        address: json['address'],
      );
}

Future<SwapInfoResponse> getSwapInfo() async {
  var url = 'https://fusion.runonflux.io/swap/info';
  var response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return SwapInfoResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load API data');
  }
}

double getEstimatedFee(double startingAmount, String fromChain, String toChain,
    SwapInfoResponse swapInfo) {
  double fee = swapInfo.fees.swap.specificFees[toChain] ?? 0;
  double percentageFee = swapInfo.fees.swap.percentage * startingAmount.abs();
  fee += (percentageFee.ceil()).toDouble();

  return fee;
}

String getSwapAddress(SwapInfoResponse response, String selectedFromCurrency) {
  String fromCurrency = convertCurrencyForAPI(selectedFromCurrency);

  for (SwapAddress info in response.swapAddresses) {
    if (info.chain == fromCurrency) {
      return info.address;
    }
  }

  return '';
}
