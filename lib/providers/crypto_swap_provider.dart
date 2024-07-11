import 'package:flutter/material.dart';
import 'package:fluxswap/api/models/cryptoswap/asset.dart';
import 'package:fluxswap/api/models/cryptoswap/createswap.dart';
import 'package:fluxswap/api/models/cryptoswap/exchangedetails.dart';
import 'package:fluxswap/api/models/cryptoswap/history.dart';
import 'package:fluxswap/api/models/cryptoswap/pairdetails.dart';
import 'package:fluxswap/api/models/cryptoswap/swapstatus.dart';
import 'package:fluxswap/api/services/crypto_service.dart';

class AssetProvider with ChangeNotifier {
  List<Asset> _sellAssets = [];
  List<Asset> _buyAssets = [];
  PairDetails? _pairDetails;
  CreateSwapResponse? _createSwapResponse;
  SwapStatusResponse? _swapStatusResponse;
  ExchangeDetailResponse? _exchangeDetailResponse;
  UserHistoryResponse? _userHistoryResponse;
  bool _isLoading = false;

  List<Asset> get sellAssets => _sellAssets;
  List<Asset> get buyAssets => _buyAssets;
  PairDetails? get pairDetails => _pairDetails;
  CreateSwapResponse? get createSwapResponse => _createSwapResponse;
  SwapStatusResponse? get swapStatusResponse => _swapStatusResponse;
  ExchangeDetailResponse? get exchangeDetailResponse => _exchangeDetailResponse;
  UserHistoryResponse? get userHistoryResponse => _userHistoryResponse;
  bool get isLoading => _isLoading;

  Future<void> fetchSellAssets() async {
    _isLoading = true;
    notifyListeners();

    try {
      _sellAssets = await CryptoSwapApiService().fetchSellAssets();
    } catch (error) {
      print('Failed to fetch sell assets: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBuyAssets() async {
    _isLoading = true;
    notifyListeners();

    try {
      _buyAssets = await CryptoSwapApiService().fetchBuyAssets();
    } catch (error) {
      print('Failed to fetch buy assets: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPairDetails(String sellAsset, String buyAsset) async {
    _isLoading = true;
    notifyListeners();

    try {
      _pairDetails =
          await CryptoSwapApiService().fetchPairDetails(sellAsset, buyAsset);
    } catch (error) {
      print('Failed to fetch pair details: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPairDetailsSellAmount(
      String sellAsset, String buyAsset, String sellAmount) async {
    _isLoading = true;
    notifyListeners();

    try {
      _pairDetails = await CryptoSwapApiService()
          .fetchPairDetailsSellAmount(sellAsset, buyAsset, sellAmount);
    } catch (error) {
      print('Failed to fetch pair details with sell amount: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createSwap(CreateSwapRequest request) async {
    _isLoading = true;
    notifyListeners();

    try {
      _createSwapResponse = await CryptoSwapApiService().createSwap(request);
    } catch (error) {
      print('Failed to create swap: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSwapStatus(SwapStatusRequest request) async {
    _isLoading = true;
    notifyListeners();

    try {
      _swapStatusResponse =
          await CryptoSwapApiService().fetchSwapStatus(request);
    } catch (error) {
      print('Failed to fetch swap status: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchExchangeDetail(String swapId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _exchangeDetailResponse =
          await CryptoSwapApiService().fetchExchangeDetail(swapId);
    } catch (error) {
      print('Failed to fetch exchange detail: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserHistory(String zelid) async {
    _isLoading = true;
    notifyListeners();

    try {
      _userHistoryResponse =
          await CryptoSwapApiService().fetchUserHistory(zelid);
    } catch (error) {
      print('Failed to fetch user history: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
