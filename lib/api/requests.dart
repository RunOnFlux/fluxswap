import 'package:http/http.dart' as http;
import 'dart:convert';

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

  SwapResponse({
    required this.chainFrom,
    required this.chainTo,
    required this.addressFrom,
    required this.addressTo,
    required this.zelid,
    required this.timestamp,
    required this.expectedAmountFrom,
    required this.expectedAmountTo,
    required this.txidFrom,
    required this.fee,
    required this.confsRequired,
  });

  // Converts a TransactionData object to a Map
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
    };
  }

  // Factory method to create a TransactionData object from a Map
  factory SwapResponse.fromJson(Map<String, dynamic> json) {
    return SwapResponse(
      chainFrom: json['chainFrom'],
      chainTo: json['chainTo'],
      addressFrom: json['addressFrom'],
      addressTo: json['addressTo'],
      zelid: json['zelid'],
      timestamp: json['timestamp'],
      expectedAmountFrom: json['expectedAmountFrom'].toDouble(),
      expectedAmountTo: json['expectedAmountTo'].toDouble(),
      txidFrom: json['txidFrom'],
      fee: json['fee'],
      confsRequired: json['confsRequired'],
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