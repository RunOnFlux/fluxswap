import 'package:flutter/cupertino.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:fluxswap/constants/coin_details.dart';
import 'package:fluxswap/constants/network_details.dart';
import 'package:fluxswap/models/coin_info.dart';
import 'package:fluxswap/models/enums.dart';
import 'package:fluxswap/models/metamask_return.dart';
import 'package:fluxswap/api/models/reserve_model.dart';
import 'package:fluxswap/api/models/swap_model.dart';
import 'package:fluxswap/utils/address_validator.dart';
import 'package:fluxswap/api/models/swapinfo_model.dart';
import 'package:fluxswap/api/services/swap_service.dart';
import 'package:fluxswap/models/fluxamount.dart';
import 'package:fluxswap/utils/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
// import 'package:web3dart/web3dart.dart';

import 'package:intl/intl.dart';

class FluxSwapProvider extends ChangeNotifier {
  // Date format
  final DateFormat dateFormat = DateFormat("EEE MMM d, yyyy, HH:mm");

  // Error Tracking
  final List<String> _errors = [];
  List<String> get errors => _errors;

  void addError(String error) {
    _errors.add(error);
    notifyListeners();
    // Automatically clear the error after 10 seconds
    Future.delayed(const Duration(seconds: 10), () {
      _errors.remove(error);
      notifyListeners();
    });
  }

  // MetaMask and Web3 Configuration
  static const operatingChain = 4;
  String currentAddress = '';
  String account = "";
  int currentChain = -1;
  BigInt gasBalance = BigInt.zero;
  BigInt fluxBalance = BigInt.zero;

  bool get isEnabled => ethereum != null;
  bool get isInOperatingChain => currentChain == operatingChain;
  bool get isConnected => isEnabled && currentAddress.isNotEmpty;

  String selectedChain = Metamask_Network_Info.entries.first.key;
  String previousSelectedChain = Metamask_Network_Info.entries.first.key;

  // App State Variables
  String _selectedFromCurrency = 'FLUX';
  String _selectedToCurrency = 'FLUX-ETH';
  String _fluxID = '';
  String _fromAddress = '';
  String _toAddress = '';
  String swapTxid = '';
  String searchSwapID = '';
  double fromAmount = 100;
  double toAmount = 90;

  String get selectedFromCurrency => _selectedFromCurrency;
  set selectedFromCurrency(String value) {
    _selectedFromCurrency = value;
    notifyListeners();
  }

  String get selectedToCurrency => _selectedToCurrency;
  set selectedToCurrency(String value) {
    _selectedToCurrency = value;
    notifyListeners();
  }

  String get fluxID => _fluxID;
  set fluxID(String value) {
    _fluxID = value;
    notifyListeners();
  }

  String get fromAddress => _fromAddress;
  set fromAddress(String value) {
    _fromAddress = value;
    notifyListeners();
  }

  String get toAddress => _toAddress;
  set toAddress(String value) {
    _toAddress = value;
    notifyListeners();
  }

  // Swap and Reserve Information
  late SwapInfoResponse swapInfoResponse;
  bool hasSwapInfoError = false;
  String errorSwapInfoMessage = "";
  bool _isReservedApproved = false;
  bool _isReservedValid = false;
  String _reservedMessage = '';
  ReserveRequest submittedRequest = ReserveRequest(
      chainFrom: "", chainTo: "", addressFrom: "", addressTo: "");
  String submittedFromCurrency = 'FLUX';
  String submittedToCurrency = 'FLUX-ETH';

  bool get isReservedApproved => _isReservedApproved;
  set isReservedApproved(bool value) {
    _isReservedApproved = value;
    notifyListeners();
  }

  bool get isReservedValid => _isReservedValid;
  set isReservedValid(bool value) {
    _isReservedValid = value;
    notifyListeners();
  }

  String get reservedMessage => _reservedMessage;
  set reservedMessage(String value) {
    _reservedMessage = value;
    notifyListeners();
  }

  bool fShowSwapCard = false;
  SwapResponse _swapToDisplay = SwapResponse(
      id: "66325ae0ffb95a575f0bf4a4",
      chainFrom: "bsc",
      chainTo: "matic",
      addressFrom: "0x9eb494403e8f2dff389fa2e64b63d888bbd97860",
      addressTo: "0x9eb494403e8f2dff389fa2e64b63d888bbd97860",
      expectedAmountFrom: 10000,
      expectedAmountTo: 997,
      txidFrom:
          "0x15179093bf68a23a621a6e1a3f5bc02bf5dfa7a422dbd71c1252aaf298a2b670",
      fee: 3,
      timestamp: 1714498454333,
      status: "hold");

  SwapResponse get swapToDisplay => _swapToDisplay;
  set swapToDisplay(SwapResponse value) {
    _swapToDisplay = value;
    notifyListeners();
  }

  SwapResponse swapResponse = SwapResponse();
  bool _isSwapCreated = false;
  bool _isSwapValid = false;
  String swapMessage = '';

  bool get isSwapCreated => _isSwapCreated;
  set isSwapCreated(bool value) {
    _isSwapCreated = value;
    notifyListeners();
  }

  bool get isSwapValid => _isSwapValid;
  set isSwapValid(bool value) {
    _isSwapValid = value;
    notifyListeners();
  }

  // Recent Used Zel IDs
  List<String> _recentUsedZelIds = [];
  List<String> get recentUsedZelIds => _recentUsedZelIds;

  void addRecentlyUsedZelid(String item) async {
    _recentUsedZelIds.insert(0, item);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('recentUsedZelIds', _recentUsedZelIds);
    notifyListeners();
  }

  Future<void> loadRecentlyUsedZelid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _recentUsedZelIds = prefs.getStringList('recentUsedZelIds') ?? [];
    _recentUsedZelIds = _recentUsedZelIds.toSet().toList();
    notifyListeners();
  }

  // Swap and Reserve Utilities
  double updateReceivedAmount() {
    double fee = SwapService.getEstimatedFee(
        fromAmount,
        getCurrencyApiName(selectedFromCurrency),
        getCurrencyApiName(selectedToCurrency),
        swapInfoResponse);
    toAmount = fromAmount - fee;
    return toAmount;
  }

  String verifyProviderData() {
    if (toAmount <= 0) return "Received Amount <= 0";
    if (fromAmount <= 0) return "From Amount <= 0";
    if (submittedFromCurrency == submittedToCurrency) {
      return "Same Currencies selected";
    }
    if (toAddress.isEmpty) return "Destination Address Empty";
    return "";
  }

  bool isConnectedChainSendable() {
    if (isConnected) {
      for (CoinInformation info in Coin_Details.values) {
        if (info.chainId == currentChain) {
          if (info.chainName == selectedChain) {
            if (info.swapingName == submittedFromCurrency) {
              return true;
            }
          }
        }
      }
      print("Connected Chain doesn't match From Currency");
      return false;
    }
    print("Wallet not connected");
    return false;
  }

  String getQRData() {
    return '${getQRCodeUriName(submittedFromCurrency)}:${SwapService.getSwapAddress(swapInfoResponse, submittedFromCurrency)}?amount=$fromAmount';
  }

  // MetaMask Interaction Methods
  Future<void> connectMetamask() async {
    try {
      if (isEnabled) {
        final accs = await ethereum!.requestAccount();
        account = accs[0];

        if (accs.isNotEmpty) currentAddress = toChecksumAddress(accs.first);

        currentChain = await ethereum!.getChainId();

        Coin_Details.forEach((key, value) {
          if (value.chainId == currentChain) {
            selectedChain = value.chainName;
            previousSelectedChain = selectedChain;
            selectedFromCurrency = value.swapingName;
            if (selectedToCurrency == selectedFromCurrency) {
              selectedToCurrency = 'FLUX';
            }
          }
        });

        await getBalance();
        await getFluxTokenBalance(currentChain);

        notifyListeners();
      } else {
        addError("Metamask plugin not found");
      }
    } on EthereumException catch (error) {
      addError(error.message);
    } catch (error) {
      addError(error.toString());
    }
  }

  Future<void> requestChangeChainMetamask() async {
    if (isEnabled) {
      try {
        await ethereum!
            .walletSwitchChain(Metamask_Network_Info[selectedChain]!.chainId);
      } on EthereumUnrecognizedChainException {
        await _addChain();
      } on EthereumException {
        await _addChain();
      } on EthereumUserRejected {
        selectedChain = previousSelectedChain;
        notifyListeners();
      }
    }
  }

  Future<void> _addChain() async {
    try {
      await ethereum!.walletAddChain(
          chainId: Metamask_Network_Info[selectedChain]!.chainId,
          chainName: selectedChain,
          nativeCurrency: Metamask_Network_Info[selectedChain]!.currencyParams,
          rpcUrls: Metamask_Network_Info[selectedChain]!.rpcurls,
          blockExplorerUrls:
              Metamask_Network_Info[selectedChain]!.blockexplorerurls);
    } on EthereumUserRejected {
      selectedChain = previousSelectedChain;
      notifyListeners();
    }
  }

  Future<void> getBalance() async {
    if (isConnected) {
      final balance = await provider!.getBalance(account);
      gasBalance = balance;
      notifyListeners();
    }
  }

  Future<void> getFluxTokenBalance(int chain) async {
    if (isConnected) {
      final contract = ContractERC20(getContract(chain), provider);
      final balance = await contract.balanceOf(account);
      fluxBalance = balance;
      notifyListeners();
    }
  }

  Future<MetamaskReturn> sendToken(
      int chain, String recipient, BigInt amount) async {
    try {
      if (isConnected) {
        final newAmount = FluxAmount.fromBigInt(FluxUnit.flux, amount);
        final signer = provider!.getSigner();
        final contract = ContractERC20(getContract(chain), signer);

        final currentAllowance =
            await contract.allowance(currentAddress, currentAddress);

        print(await contract.name);
        print(await contract.symbol);
        print(await contract.decimals);
        print("Current allowance $currentAllowance");
        print("Trying to send  ${newAmount.getInWei}");

        if (currentAllowance < amount) {
          final approveTx =
              await contract.approve(currentAddress, newAmount.getInWei);
          await approveTx.wait();
        }

        final transaction = await contract.transferFrom(
            currentAddress, recipient, newAmount.getInWei);
        notifyListeners();

        return MetamaskReturn(fSuccessful: true, hash: transaction.hash);
      } else {
        return MetamaskReturn(
            fSuccessful: false, message: "Metamask not connected");
      }
    } on EthereumUserRejected {
      return MetamaskReturn(fSuccessful: false, fCancelled: true);
    } catch (e) {
      return MetamaskReturn(
          fSuccessful: false, fCancelled: false, message: e.toString());
    }
  }

  // Gas and Token Information
  double getGasCoinAmount() {
    FluxAmount amount = FluxAmount.fromBigInt(FluxUnit.wei, gasBalance);
    return amount.getValueInUnit(FluxUnit.ether);
  }

  double getFluxCoinAmount() {
    FluxAmount amount = FluxAmount.fromBigInt(FluxUnit.wei, fluxBalance);
    return amount.getValueInUnit(FluxUnit.flux);
  }

  String getGasCoinName(int chain) {
    for (var value in Network_Details.entries) {
      if (value.value.chain == chain) {
        return value.key.name;
      }
    }
    return "Unknown";
  }

  String getContract(int chain) {
    for (var value in Network_Details.entries) {
      if (value.value.chain == chain) {
        return value.value.contractAddress;
      }
    }
    return "";
  }

  // Miscellaneous
  void clearData() {
    isReservedApproved = false;
    isReservedValid = false;
    isSwapCreated = false;
    isSwapValid = false;
    toAddress = '';
    fromAddress = '';
    toAddress = '';
    fromAmount = 100;
    toAmount = 90;
    fluxID = '';
    swapTxid = '';
    submittedFromCurrency = 'FLUX';
    submittedToCurrency = 'FLUX-ETH';
    submittedRequest = ReserveRequest(
        chainFrom: '', chainTo: '', addressFrom: '', addressTo: '');
    swapResponse = SwapResponse();
    notifyListeners();
  }

  void clear() {
    currentAddress = '';
    currentChain = -1;
    notifyListeners();
  }

  // Initialization and Event Handlers
  void init() async {
    try {
      swapInfoResponse = await SwapService.getSwapInfo();
      updateReceivedAmount();
    } catch (error) {
      addError(error.toString());
      hasSwapInfoError = true;
      errorSwapInfoMessage = error.toString();
    }

    loadRecentlyUsedZelid();

    if (isEnabled) {
      ethereum!.onAccountsChanged((_) => clear());
      ethereum!.onChainChanged((_) {
        clear();
        connectMetamask();
      });
    }
  }
}
