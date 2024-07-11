import 'dart:convert';
import 'package:http/http.dart' as http;

class SwapStatusRequest {
  final String exchangeId;
  final String swapId;

  SwapStatusRequest({
    required this.exchangeId,
    required this.swapId,
  });

  Map<String, dynamic> toJson() {
    return {
      'exchangeId': exchangeId,
      'swapId': swapId,
    };
  }
}

class SwapStatusResponse {
  final String status;
  final String data;

  SwapStatusResponse({
    required this.status,
    required this.data,
  });

  factory SwapStatusResponse.fromJson(Map<String, dynamic> json) {
    return SwapStatusResponse(
      status: json['status'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data,
    };
  }
}
