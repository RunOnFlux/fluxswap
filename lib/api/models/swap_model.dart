class SwapRequest {
  final double amountFrom;
  final String chainFrom;
  final String chainTo;
  final String addressFrom;
  final String addressTo;
  final String txidFrom;

  SwapRequest({
    required this.amountFrom,
    required this.chainFrom,
    required this.chainTo,
    required this.addressFrom,
    required this.addressTo,
    required this.txidFrom,
  });

  Map<String, dynamic> toJson() => {
        'amountFrom': amountFrom,
        'chainFrom': chainFrom,
        'chainTo': chainTo,
        'addressFrom': addressFrom,
        'addressTo': addressTo,
        'txidFrom': txidFrom,
      };

  factory SwapRequest.fromJson(Map<String, dynamic> json) => SwapRequest(
        amountFrom: (json['amountFrom'] ?? 0.0).toDouble(),
        chainFrom: json['chainFrom'],
        chainTo: json['chainTo'],
        addressFrom: json['addressFrom'],
        addressTo: json['addressTo'],
        txidFrom: json['txidFrom'],
      );
}

class SwapResponse {
  final String chainFrom;
  final String chainTo;
  final String addressFrom;
  final String addressTo;
  final String zelid;
  final int timestamp;
  final double expectedAmountFrom;
  final double expectedAmountTo;
  final String txidFrom;
  final int fee;
  final int confsRequired;
  final String id;
  final String status;

  SwapResponse({
    this.chainFrom = '',
    this.chainTo = '',
    this.addressFrom = '',
    this.addressTo = '',
    this.zelid = '',
    this.timestamp = 0,
    this.expectedAmountFrom = 0.0,
    this.expectedAmountTo = 0.0,
    this.txidFrom = '',
    this.fee = 0,
    this.confsRequired = 0,
    this.id = '',
    this.status = '',
  });

  Map<String, dynamic> toJson() => {
        'chainFrom': chainFrom,
        'chainTo': chainTo,
        'addressFrom': addressFrom,
        'addressTo': addressTo,
        'zelid': zelid,
        'timestamp': timestamp,
        'expectedAmountFrom': expectedAmountFrom,
        'expectedAmountTo': expectedAmountTo,
        'txidFrom': txidFrom,
        'fee': fee,
        'confsRequired': confsRequired,
        '_id': id,
        'status': status,
      };

  factory SwapResponse.fromJson(Map<String, dynamic> json) => SwapResponse(
        chainFrom: json['chainFrom'] ?? '',
        chainTo: json['chainTo'] ?? '',
        addressFrom: json['addressFrom'] ?? '',
        addressTo: json['addressTo'] ?? '',
        zelid: json['zelid'] ?? '',
        timestamp: json['timestamp'] ?? 0,
        expectedAmountFrom: (json['expectedAmountFrom'] ?? 0.0).toDouble(),
        expectedAmountTo: (json['expectedAmountTo'] ?? 0.0).toDouble(),
        txidFrom: json['txidFrom'] ?? '',
        fee: json['fee'] ?? 0,
        confsRequired: json['confsRequired'] ?? 0,
        id: json['_id'] ?? '',
        status: json['status'] ?? '',
      );
}
