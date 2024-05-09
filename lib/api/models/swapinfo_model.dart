class SwapInfoResponse {
  final String status;
  final List<String> chains;
  final List<Coin> coins;
  final List<Confirmation> confirmations;
  final Fees fees;
  final List<SwapAddress> swapAddresses;

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
  final String coin;
  final String chain;

  Coin({required this.coin, required this.chain});

  factory Coin.fromJson(Map<String, dynamic> json) => Coin(
        coin: json['coin'],
        chain: json['chain'],
      );
}

class Confirmation {
  final int confirmations;
  final int amount;

  Confirmation({required this.confirmations, required this.amount});

  factory Confirmation.fromJson(Map<String, dynamic> json) => Confirmation(
        confirmations: json['confirmations'],
        amount: json['amount'],
      );
}

class Fees {
  final FeeTypes snapshot;
  final FeeTypes mining;
  final FeeTypesSwap swap;

  Fees({
    required this.snapshot,
    required this.mining,
    required this.swap,
  });

  factory Fees.fromJson(Map<String, dynamic> json) => Fees(
        snapshot: FeeTypes.fromJson(json['snapshot']),
        mining: FeeTypes.fromJson(json['mining']),
        swap: FeeTypesSwap.fromJson(json['swap']),
      );
}

class FeeTypes {
  final double percentage;
  final Map<String, double> specificFees;

  FeeTypes({required this.percentage, required this.specificFees});

  factory FeeTypes.fromJson(Map<String, dynamic> json) => FeeTypes(
        percentage: (json['percentage'] ?? 0.0).toDouble(),
        specificFees: json
            .map((key, value) => MapEntry(key, double.parse(value.toString()))),
      );
}

class FeeTypesSwap {
  final double percentage;
  final double premiumPercentage;
  final Map<String, double> specificFees;

  FeeTypesSwap({
    required this.percentage,
    required this.premiumPercentage,
    required this.specificFees,
  });

  factory FeeTypesSwap.fromJson(Map<String, dynamic> json) => FeeTypesSwap(
        percentage: (json['percentage'] ?? 0.0).toDouble(),
        premiumPercentage: (json['premiumPercentage'] ?? 0.0).toDouble(),
        specificFees: json
            .map((key, value) => MapEntry(key, double.parse(value.toString()))),
      );
}

class SwapAddress {
  final String chain;
  final String address;

  SwapAddress({required this.chain, required this.address});

  factory SwapAddress.fromJson(Map<String, dynamic> json) => SwapAddress(
        chain: json['chain'],
        address: json['address'],
      );
}
