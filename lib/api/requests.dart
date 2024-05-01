import 'package:fluxswap/provider/fluxswapprovider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class ReserveRequest {
  String chainFrom;
  String chainTo;
  String addressFrom;
  String addressTo;

  ReserveRequest({
    required this.chainFrom,
    required this.chainTo,
    required this.addressFrom,
    required this.addressTo,
  });

  // Method to convert a TransactionInfo object to a Map (for JSON encoding)
  Map<String, dynamic> toJson() {
    return {
      'chainFrom': chainFrom,
      'chainTo': chainTo,
      'addressFrom': addressFrom,
      'addressTo': addressTo,
    };
  }

  // Factory constructor to create a TransactionInfo object from a Map (for JSON decoding)
  factory ReserveRequest.fromJson(Map<String, dynamic> json) {
    return ReserveRequest(
      chainFrom: json['chainFrom'],
      chainTo: json['chainTo'],
      addressFrom: json['addressFrom'],
      addressTo: json['addressTo'],
    );
  }
}

class ReserveResponse {
  String chainFrom;
  String chainTo;
  String addressFrom;
  String addressTo;
  String zelid;
  DateTime createdAt;

  // Updated constructor with default values
  ReserveResponse({
    this.chainFrom = '',
    this.chainTo = '',
    this.addressFrom = '',
    this.addressTo = '',
    this.zelid = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert a ReserveResponse object to a Map (for JSON encoding)
  Map<String, dynamic> toJson() {
    return {
      'chainFrom': chainFrom,
      'chainTo': chainTo,
      'addressFrom': addressFrom,
      'addressTo': addressTo,
      'zelid': zelid,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Factory constructor to create a ReserveResponse object from a Map (for JSON decoding)
  factory ReserveResponse.fromJson(Map<String, dynamic> json) {
    return ReserveResponse(
      chainFrom: json['chainFrom'],
      chainTo: json['chainTo'],
      addressFrom: json['addressFrom'],
      addressTo: json['addressTo'],
      zelid: json['zelid'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}

class SwapRequest {
  double amountFrom;
  String chainFrom;
  String chainTo;
  String addressFrom;
  String addressTo;
  String txidFrom;

  SwapRequest({
    required this.amountFrom,
    required this.chainFrom,
    required this.chainTo,
    required this.addressFrom,
    required this.addressTo,
    required this.txidFrom,
  });

  // Method to convert a TransactionDetail object to a Map (for JSON encoding)
  Map<String, dynamic> toJson() {
    return {
      'amountFrom': amountFrom,
      'chainFrom': chainFrom,
      'chainTo': chainTo,
      'addressFrom': addressFrom,
      'addressTo': addressTo,
      'txidFrom': txidFrom,
    };
  }

  // Factory constructor to create a TransactionDetail object from a Map (for JSON decoding)
  factory SwapRequest.fromJson(Map<String, dynamic> json) {
    return SwapRequest(
      amountFrom: json['amountFrom'],
      chainFrom: json['chainFrom'],
      chainTo: json['chainTo'],
      addressFrom: json['addressFrom'],
      addressTo: json['addressTo'],
      txidFrom: json['txidFrom'],
    );
  }
}

class SwapResponse {
  String chainFrom;
  String chainTo;
  String addressFrom;
  String addressTo;
  String zelid;
  int timestamp;
  double expectedAmountFrom;
  double expectedAmountTo;
  String txidFrom;
  int fee;
  int confsRequired;
  String id;

  // Constructor with default values for both strings and numbers
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
  });

  // Method to check if any string fields are empty
  bool isNull() {
    return chainFrom.isEmpty ||
        chainTo.isEmpty ||
        addressFrom.isEmpty ||
        addressTo.isEmpty ||
        zelid.isEmpty ||
        txidFrom.isEmpty;
  }

  // Converts the object to a Map
  Map<String, dynamic> toJson() {
    return {
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
    };
  }

  // Factory method to create a SwapResponse object from a Map
  factory SwapResponse.fromJson(Map<String, dynamic> json) {
    return SwapResponse(
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
    );
  }
}

Future<List<dynamic>> createSwapRequest(
    String zelid, SwapRequest request) async {
  try {
    // Define the URL of the API
    String url =
        'https://fusion.runonflux.io/swap/create'; // Replace with your API's URL

    // Define the headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (zelid.isNotEmpty) {
      headers.addAll({'zelid': zelid});
    }

    // Define the body. It could be a Map that will be converted to JSON.
    Map<String, dynamic> body = request.toJson();

    // Convert the Map to a JSON string
    String jsonBody = json.encode(body);

    print(jsonBody);

    // Make the POST request
    http.Response response =
        await http.post(Uri.parse(url), headers: headers, body: jsonBody);

    bool success = true;
    String message = "Swap Created Successfully.";
    SwapResponse swapResponse = SwapResponse();

    // Check the status code for the result
    if (response.statusCode == 200) {
      var obj = json.decode(response.body);

      print(obj);

      if (obj['status'] == 'error') {
        success = false;
        message = obj['data']['message'];
      }

      try {
        swapResponse = SwapResponse.fromJson(obj['data']);
      } catch (e) {
        print("Failed to put object into SwapResponse");
        print(e);
      }
    } else {
      print('Error: ${response.statusCode}');
      success = false;
      message = "Bad Api Call";
    }

    return [success, message, swapResponse];
  } catch (e) {
    throw Exception('Failed to send post request: $e');
  }
}

Future<List<dynamic>> makeReserveRequest(
    String zelid, ReserveRequest request) async {
  // Define the URL of the API
  String url =
      'https://fusion.runonflux.io/swap/reserve'; // Replace with your API's URL

  // Define the headers
  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  if (zelid.isNotEmpty) {
    headers.addAll({'zelid': zelid});
  }

  // Define the body. It could be a Map that will be converted to JSON.
  Map<String, dynamic> body = request.toJson();

  // Convert the Map to a JSON string
  String jsonBody = json.encode(body);

  print(jsonBody);

  // Make the POST request
  http.Response response =
      await http.post(Uri.parse(url), headers: headers, body: jsonBody);

  bool success = true;
  String message = "Reserve request successful.";

  // Check the status code for the result
  if (response.statusCode == 200) {
    var obj = json.decode(response.body);

    print(obj);

    if (obj['status'] == 'error') {
      success = false;
      message = obj['data']['message'];
    }
  } else {
    print('Error: ${response.statusCode}');
    success = false;
    message = "Bad Api Call";
  }

  return [success, message];
}
