import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluxswap/api/models/cryptoswap/swapasset.dart';
import 'package:fluxswap/api/models/cryptoswap/createswap.dart';
import 'package:fluxswap/api/models/cryptoswap/exchangedetails.dart';
import 'package:fluxswap/api/models/cryptoswap/swaphistory.dart';
import 'package:fluxswap/api/models/cryptoswap/pairdetails.dart';
import 'package:fluxswap/api/models/cryptoswap/swapstatus.dart';
import 'package:fluxswap/api/services/crypto_service.dart';

class CryptoSwapProvider with ChangeNotifier {
  List<Asset> _sellAssets = [];
  List<Asset> _buyAssets = [];
  List<Asset> _filteredBuyAssets = [];
  PairDetails? _pairDetails;
  CreateSwapResponse? _createSwapResponse;
  SwapStatusResponse? _swapStatusResponse;
  ExchangeDetailResponse? _exchangeDetailResponse;
  UserHistoryResponse? _userHistoryResponse;
  Asset? _selectedSellAsset;
  Asset? _selectedBuyAsset;
  String _sellAmount = "0.1";
  String? _buyAmount;
  bool _isFixedRate = false;
  ExchangeDetail? _selectedExchangeDetail;
  bool _isLoading = false;
  Timer? _debounce; // Delay the buyAmount api call while user typing (1 second)

  List<Asset> get sellAssets => _sellAssets;
  List<Asset> get buyAssets => _buyAssets;
  List<Asset> get filteredBuyAssets => _filteredBuyAssets;
  PairDetails? get pairDetails => _pairDetails;
  CreateSwapResponse? get createSwapResponse => _createSwapResponse;
  SwapStatusResponse? get swapStatusResponse => _swapStatusResponse;
  ExchangeDetailResponse? get exchangeDetailResponse => _exchangeDetailResponse;
  UserHistoryResponse? get userHistoryResponse => _userHistoryResponse;
  Asset? get selectedSellAsset => _selectedSellAsset;
  Asset? get selectedBuyAsset => _selectedBuyAsset;
  String get sellAmount => _sellAmount;
  String? get buyAmount => _buyAmount;
  bool get isFixedRate => _isFixedRate;
  ExchangeDetail? get selectedExchangeDetail => _selectedExchangeDetail;
  bool get isLoading => _isLoading;

  set selectedSellAsset(Asset? value) {
    _selectedSellAsset = value;
    _fetchBuyAmount();
    _filterBuyAssets();
    notifyListeners();
  }

  set selectedBuyAsset(Asset? value) {
    _selectedBuyAsset = value;
    _fetchBuyAmount();
    notifyListeners();
  }

  set filteredBuyAssets(List<Asset> value) {
    _filteredBuyAssets = value;
    notifyListeners();
  }

  set sellAmount(String value) {
    _sellAmount = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      _fetchBuyAmount();
    });
    notifyListeners();
  }

  set buyAmount(String? value) {
    _buyAmount = value;
    notifyListeners();
  }

  void toggleIsFixedRateState() {
    _isFixedRate = !_isFixedRate;
    _filterBuyAssets();
    _fetchBuyAmount();
    notifyListeners();
  }

  void _filterBuyAssets() {
    if (_selectedSellAsset == null) {
      _filteredBuyAssets = _buyAssets;
      return;
    }

    List<String> relevantIds = [];
    if (_isFixedRate) {
      relevantIds = [
        ...?_selectedSellAsset!.idchangellyfixlimit,
        if (_selectedSellAsset!.idchangellyfix != null)
          _selectedSellAsset!.idchangellyfix!,
        ...?_selectedSellAsset!.idchangenowfixlimit,
        if (_selectedSellAsset!.idchangenowfix != null)
          _selectedSellAsset!.idchangenowfix!,
        ...?_selectedSellAsset!.idsimpleswapfixlimit,
        if (_selectedSellAsset!.idsimpleswapfix != null)
          _selectedSellAsset!.idsimpleswapfix!,
      ];
    } else {
      relevantIds = [
        ...?_selectedSellAsset!.idchangellyfloatlimit,
        if (_selectedSellAsset!.idchangellyfloat != null)
          _selectedSellAsset!.idchangellyfloat!,
        ...?_selectedSellAsset!.idchangenowfloatlimit,
        if (_selectedSellAsset!.idchangenowfloat != null)
          _selectedSellAsset!.idchangenowfloat!,
        ...?_selectedSellAsset!.idsimpleswapfloatlimit,
      ];
    }

    _filteredBuyAssets = _buyAssets
        .where((asset) => relevantIds.contains(asset.idzelcore))
        .toList();
  }

  Future<void> _fetchBuyAmount() async {
    if (_selectedSellAsset == null || _selectedBuyAsset == null) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final pairDetails = await CryptoSwapApiService()
          .fetchPairDetailsSellAmount(_selectedSellAsset!.idzelcore,
              _selectedBuyAsset!.idzelcore, _sellAmount);

      _pairDetails = pairDetails;

      // Filter exchanges based on isFixedRate and select the one with highest rate
      if (_pairDetails != null) {
        if (_pairDetails!.exchanges.isEmpty) {
          _buyAmount = null;
        }
        final filteredExchanges = _pairDetails!.exchanges.where((exchange) {
          final isFixed = exchange.exchangeId.contains('fix');
          return _isFixedRate ? isFixed : !isFixed;
        }).toList();

        if (filteredExchanges.isNotEmpty) {
          _selectedExchangeDetail = filteredExchanges.reduce((a, b) {
            return double.parse(a.rate) > double.parse(b.rate) ? a : b;
          });
          if (double.parse(_selectedExchangeDetail!.rate) > 0) {
            _buyAmount = _selectedExchangeDetail?.buyAmount;
          } else {
            _buyAmount = null;
          }
        } else {
          _buyAmount = null;
        }
      } else {
        _buyAmount = null;
      }
    } catch (error) {
      print('Failed to fetch pair details with sell amount: $error');
      _buyAmount = null;
    } finally {
      await Future.delayed(
          Duration(seconds: 2)); // Ensure minimum 1-second loading
      _isLoading = false;
      notifyListeners();
    }
  }

  void init() async {
    try {
      // await fetchPairDetailsSellAmount("bitcoin", "ethereum", "0.1");
      await fetchSellAssets();
      await fetchBuyAssets();
      final bitcoinAsset = _sellAssets.firstWhere(
        (asset) => asset.idzelcore.toLowerCase() == "bitcoin",
        orElse: () => Asset.nullAsset(),
      );
      if (!bitcoinAsset.isNull) {
        _selectedSellAsset = bitcoinAsset;
        _filterBuyAssets();
      } else {
        print("Bitcoin asset not found in sell assets");
      }

      final ethereumAsset = _buyAssets.firstWhere(
        (asset) => asset.idzelcore.toLowerCase() == "ethereum",
        orElse: () => Asset.nullAsset(),
      );
      if (!ethereumAsset.isNull) {
        _selectedBuyAsset = ethereumAsset;
      } else {
        print("Ethereum asset not found in buy assets");
      }
      await _fetchBuyAmount();
    } catch (error) {
      print("Error during crypto swap init ${error.toString()}");
    } finally {}
  }

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
      // Update buyAmount from the exchange details
      if (_pairDetails != null && _pairDetails!.exchanges.isNotEmpty) {
        _buyAmount = _pairDetails!.exchanges.first.buyAmount;
      } else {
        _buyAmount = null;
      }
    } catch (error) {
      print('Failed to fetch pair details with sell amount: $error');
      _buyAmount = null;
    } finally {
      await Future.delayed(
          Duration(seconds: 2)); // Ensure minimum 2-second loading
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createSwap(String walletAddress, String refundAddress) async {
    if (_selectedSellAsset == null ||
        _selectedBuyAsset == null ||
        _buyAmount == null ||
        _selectedExchangeDetail == null) {
      print(_selectedSellAsset);
      print(_selectedBuyAsset);
      print(_buyAmount);
      print(_selectedExchangeDetail);

      print("something was null");
      return;
    }

    final request = CreateSwapRequest(
      exchangeId: _selectedExchangeDetail!.exchangeId,
      sellAsset: _selectedSellAsset!.idzelcore,
      buyAsset: _selectedBuyAsset!.idzelcore,
      sellAmount: _sellAmount,
      buyAddress: walletAddress,
      refundAddress: refundAddress,
      rateId: _selectedExchangeDetail?.rateId,
    );

    try {
      _isLoading = true;
      notifyListeners();

      _createSwapResponse = await CryptoSwapApiService().createSwap(request);
      // Handle the response as necessary
    } catch (error) {
      print('Failed to create swap: $error');
      // Handle the error as necessary
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createTestSwap() async {
    final Map<String, dynamic> testData = {
      "exchangeId": "idchangellyfloat",
      "sellAsset": "bitcoin",
      "buyAsset": "ethereum",
      "swapId": "losjm7it0uzwdmom",
      "sellAmount": "0.1",
      "buyAmount": "1.86731303",
      "refundAddress": "1Kr6QSydW9bFQG1mXiPNNu6WpJGmUa9i1g",
      "buyAddress": "0x0B4E395Bc9CAfEC089fa164aC8d33f27D62a5Cdd",
      "refundAddressExtraId": null,
      "buyAddressExtraId": null,
      "depositAddress": "bc1qxtar5k7aq4uuq42kmjhw9vzx9cj4rlm8f27cuz",
      "depositExtraId": null,
      "status": "new",
      "createdAt": 1721241904000000,
      "kycRequired": false,
      "rateId": null,
      "rate": "18.67313030",
      "validTill": 1721241990400000
    };

    _createSwapResponse = CreateSwapResponse.fromJson(testData);
    print(_createSwapResponse?.toJson());
    notifyListeners();
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
