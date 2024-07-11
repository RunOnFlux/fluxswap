import 'dart:convert';
import 'package:fluxswap/api/models/cryptoswap/asset.dart';
import 'package:fluxswap/api/models/cryptoswap/createswap.dart';
import 'package:fluxswap/api/models/cryptoswap/exchangedetails.dart';
import 'package:fluxswap/api/models/cryptoswap/history.dart';
import 'package:fluxswap/api/models/cryptoswap/pairdetails.dart';
import 'package:fluxswap/api/models/cryptoswap/swapstatus.dart';
import 'package:http/http.dart' as http;

class CryptoSwapApiService {
  static const String sellApiUrl =
      'https://abe.zelcore.io/v1/exchange/sellassets';
  static const String buyApiUrl =
      'https://abe.zelcore.io/v1/exchange/buyassets';
  static const String pairDetailsUrl =
      'https://abe.zelcore.io/v1/exchange/pairdetails';
  static const String pairDetailsSellAmountUrl =
      'https://abe.zelcore.io/v1/exchange/pairdetailssellamount';
  static const String createSwapUrl =
      'https://abe.zelcore.io/v1/exchange/createswap';
  static const String statusUrl = 'https://abe.zelcore.io/v1/exchange/status';
  static const String detailUrl = 'https://abe.zelcore.io/v1/exchange/detail';
  static const String userHistoryUrl =
      'https://abe.zelcore.io/v1/exchange/user/history';

  Future<List<Asset>> fetchSellAssets() async {
    return _fetchAssets(sellApiUrl);
  }

  Future<List<Asset>> fetchBuyAssets() async {
    return _fetchAssets(buyApiUrl);
  }

  Future<List<Asset>> _fetchAssets(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body)['data'];
      return jsonResponse.map((json) => Asset.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load assets');
    }
  }

  Future<PairDetails> fetchPairDetails(
      String sellAsset, String buyAsset) async {
    final response = await http.post(
      Uri.parse(pairDetailsUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'sellAsset': sellAsset,
        'buyAsset': buyAsset,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        return PairDetails.fromJson(jsonResponse['data']);
      } else {
        throw Exception('Failed to load pair details');
      }
    } else {
      throw Exception('Failed to load pair details');
    }
  }

  Future<PairDetails> fetchPairDetailsSellAmount(
      String sellAsset, String buyAsset, String sellAmount) async {
    final response = await http.post(
      Uri.parse(pairDetailsSellAmountUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'sellAsset': sellAsset,
        'buyAsset': buyAsset,
        'sellAmount': sellAmount,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        return PairDetails.fromJson(jsonResponse['data']);
      } else {
        throw Exception('Failed to load pair details with sell amount');
      }
    } else {
      throw Exception('Failed to load pair details with sell amount');
    }
  }

  Future<CreateSwapResponse> createSwap(CreateSwapRequest request) async {
    final response = await http.post(
      Uri.parse(createSwapUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        return CreateSwapResponse.fromJson(jsonResponse['data']);
      } else {
        throw Exception('Failed to create swap');
      }
    } else {
      throw Exception('Failed to create swap');
    }
  }

  Future<SwapStatusResponse> fetchSwapStatus(SwapStatusRequest request) async {
    final response = await http.post(
      Uri.parse(statusUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        return SwapStatusResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to fetch swap status');
      }
    } else {
      throw Exception('Failed to fetch swap status');
    }
  }

  Future<ExchangeDetailResponse> fetchExchangeDetail(String swapId) async {
    final Uri uri = Uri.parse('$detailUrl?swapId=$swapId');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        return ExchangeDetailResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to fetch exchange detail');
      }
    } else {
      throw Exception('Failed to fetch exchange detail');
    }
  }

  Future<UserHistoryResponse> fetchUserHistory(String zelid) async {
    final response = await http.get(
      Uri.parse(userHistoryUrl),
      headers: {
        'Content-Type': 'application/json',
        'zelid': zelid,
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        return UserHistoryResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to fetch user history');
      }
    } else {
      throw Exception('Failed to fetch user history');
    }
  }
}
