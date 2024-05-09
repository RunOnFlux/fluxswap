class ReserveRequest {
  final String chainFrom;
  final String chainTo;
  final String addressFrom;
  final String addressTo;

  ReserveRequest({
    required this.chainFrom,
    required this.chainTo,
    required this.addressFrom,
    required this.addressTo,
  });

  Map<String, dynamic> toJson() => {
        'chainFrom': chainFrom,
        'chainTo': chainTo,
        'addressFrom': addressFrom,
        'addressTo': addressTo,
      };

  factory ReserveRequest.fromJson(Map<String, dynamic> json) => ReserveRequest(
        chainFrom: json['chainFrom'],
        chainTo: json['chainTo'],
        addressFrom: json['addressFrom'],
        addressTo: json['addressTo'],
      );
}

class ReserveResponse {
  final String chainFrom;
  final String chainTo;
  final String addressFrom;
  final String addressTo;
  final String zelid;
  final DateTime createdAt;

  ReserveResponse({
    this.chainFrom = '',
    this.chainTo = '',
    this.addressFrom = '',
    this.addressTo = '',
    this.zelid = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'chainFrom': chainFrom,
        'chainTo': chainTo,
        'addressFrom': addressFrom,
        'addressTo': addressTo,
        'zelid': zelid,
        'createdAt': createdAt.toIso8601String(),
      };

  factory ReserveResponse.fromJson(Map<String, dynamic> json) =>
      ReserveResponse(
        chainFrom: json['chainFrom'] ?? '',
        chainTo: json['chainTo'] ?? '',
        addressFrom: json['addressFrom'] ?? '',
        addressTo: json['addressTo'] ?? '',
        zelid: json['zelid'] ?? '',
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
      );
}
