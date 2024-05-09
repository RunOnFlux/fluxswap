import 'package:fluxswap/utils/modals.dart';
import 'package:fluxswap/api/models/reserve_model.dart';
import 'package:fluxswap/api/models/swap_model.dart';
import 'package:fluxswap/api/models/swapinfo_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SwapService {
  static const _baseUrl = 'https://fusion.runonflux.io/swap';

  static Future<List<SwapResponse>> fetchHistory(String zelid) async {
    if (zelid.isEmpty) {
      throw Exception('No Flux/Zelid provided');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/userhistory'),
      headers: {'Content-Type': 'application/json', 'zelid': zelid},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['data'];
      return jsonList
          .map((jsonItem) => SwapResponse.fromJson(jsonItem))
          .toList();
    } else {
      throw Exception('Failed to load swap history');
    }
  }

  static Future<SwapResponse> fetchSwapStatus(String swapId) async {
    final response = await http.get(Uri.parse('$_baseUrl/detail/$swapId'));

    if (response.statusCode == 200) {
      return SwapResponse.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to load swap status');
    }
  }

  static Future<List<dynamic>> createSwapRequest(
      String zelid, SwapRequest request) async {
    final headers = {
      'Content-Type': 'application/json',
      if (zelid.isNotEmpty) 'zelid': zelid,
    };

    final response = await http.post(
      Uri.parse('$_baseUrl/create'),
      headers: headers,
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final obj = json.decode(response.body);
      if (obj['status'] == 'error') {
        return [false, obj['data']['message'], SwapResponse()];
      }

      try {
        final swapResponse = SwapResponse.fromJson(obj['data']);
        return [true, 'Swap Created Successfully.', swapResponse];
      } catch (e) {
        print("Failed to parse SwapResponse: $e");
        return [false, "Error parsing response data.", SwapResponse()];
      }
    } else {
      print('Error: ${response.statusCode}');
      return [false, "Bad API Call", SwapResponse()];
    }
  }

  static Future<List<dynamic>> makeReserveRequest(
      String zelid, ReserveRequest request) async {
    final headers = {
      'Content-Type': 'application/json',
      if (zelid.isNotEmpty) 'zelid': zelid,
    };

    final response = await http.post(
      Uri.parse('$_baseUrl/reserve'),
      headers: headers,
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final obj = json.decode(response.body);
      if (obj['status'] == 'error') {
        return [false, obj['data']['message']];
      }
      return [true, "Reserve request successful."];
    } else {
      print('Error: ${response.statusCode}');
      return [false, "Bad API Call"];
    }
  }

  static Future<SwapInfoResponse> getSwapInfo() async {
    final response = await http.get(Uri.parse('$_baseUrl/info'));
    if (response.statusCode == 200) {
      return SwapInfoResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load swap info');
    }
  }

  static double getEstimatedFee(double startingAmount, String fromChain,
      String toChain, SwapInfoResponse swapInfo) {
    final double fee = swapInfo.fees.swap.specificFees[toChain] ?? 0.0;
    final double percentageFee =
        swapInfo.fees.swap.percentage * startingAmount.abs();
    return fee + percentageFee.ceilToDouble();
  }

  static String getSwapAddress(
      SwapInfoResponse response, String selectedFromCurrency) {
    final String fromCurrency = getCurrencyApiName(selectedFromCurrency);

    for (SwapAddress info in response.swapAddresses) {
      if (info.chain == fromCurrency) {
        return info.address;
      }
    }

    return '';
  }
}
