import 'package:flutter/cupertino.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:fluxswap/api/requests.dart';
import 'package:fluxswap/web3/fluxamount.dart';
import 'package:fluxswap/api/swapinfo.dart';
import 'package:fluxswap/helper/modals.dart';
import 'package:intl/intl.dart';

class ContractInfo {
  final int chain;
  final String contractAddress;

  const ContractInfo({
    required this.chain,
    required this.contractAddress,
  });
}

class MetamaskReturn {
  bool fSuccessful = false;
  bool fCancelled = false;
  String message = '';
  String hash = '';

  MetamaskReturn() {
    fSuccessful = false;
    fCancelled = false;
    message = '';
    hash = '';
  }
}

// ignore: constant_identifier_names
enum Coin { FLUX, ETH, BSC, AVAX, MATIC, BASE }

class CoinDetails {
  static const Map<Coin, ContractInfo> details = {
    Coin.FLUX: ContractInfo(
      chain: 0,
      contractAddress: "",
    ),
    Coin.ETH: ContractInfo(
      chain: 1,
      contractAddress: "0x720CD16b011b987Da3518fbf38c3071d4F0D1495",
    ),
    Coin.BSC: ContractInfo(
      chain: 56,
      contractAddress: "0xaFF9084f2374585879e8B434C399E29E80ccE635",
    ),
    Coin.AVAX: ContractInfo(
      chain: 43114,
      contractAddress: "0xc4B06F17ECcB2215a5DBf042C672101Fc20daF55",
    ),
    Coin.MATIC: ContractInfo(
      chain: 137,
      contractAddress: "0xA2bb7A68c46b53f6BbF6cC91C865Ae247A82E99B",
    ),
    Coin.BASE: ContractInfo(
      chain: 8453,
      contractAddress: "0xb008bdcf9cdff9da684a190941dc3dca8c2cdd44",
    ),
  };

  static ContractInfo getInfo(Coin coin) {
    return details[coin]!;
  }
}

class FluxSwapProvider extends ChangeNotifier {
  // Date
  DateFormat dateFormat = DateFormat("MM-dd-yyyy HH:mm");

  // Metamask stuff
  static const operatingChain = 4;
  String currentAddress = '';
  var account = "";
  int currentChain = -1;
  BigInt gasBalance = BigInt.from(0);
  BigInt fluxBalance = BigInt.from(0);
  bool get isEnabled => ethereum != null;
  bool get isInOperatingChain => currentChain == operatingChain;
  bool get isConnected => isEnabled && currentAddress.isNotEmpty;
  String selectedChain = metamaskNetworks.entries.first.key;
  String previousSelectedChain = metamaskNetworks.entries.first.key;

  // App Variables
  String selectedFromCurrency = 'FLUX';
  String selectedToCurrency = 'FLUX-ETH';
  String fluxID = '';
  double fromAmount = 100;
  double toAmount = 90;
  String _fromAddress = '';
  String _toAddress = '';
  String swapTxid = '';

  // Requests / Reponses
  late SwapInfoResponse swapInfoResponse;

  bool _isReservedApproved = false; // Set by the Approved Button
  bool _isReservedValid = false;
  String _reservedMessage = '';
  ReserveRequest submittedRequest = ReserveRequest(
      chainFrom: "", chainTo: "", addressFrom: "", addressTo: "");
  String submittedFromCurrency = '';
  String submittedToCurrency = '';

  bool get isReservedApproved => _isReservedApproved;

  set isReservedApproved(value) {
    _isReservedApproved = value;
    notifyListeners();
  }

  bool get isReservedValid => _isReservedValid;

  set isReservedValid(value) {
    _isReservedValid = value;
    notifyListeners();
  }

  String get reservedMessage => _reservedMessage;

  set reservedMessage(value) {
    _reservedMessage = value;
    notifyListeners();
  }

  String get toAddress => _toAddress;

  set toAddress(value) {
    _toAddress = value;
    notifyListeners();
  }

  String get fromAddress => _fromAddress;

  set fromAddress(value) {
    _fromAddress = value;
    notifyListeners();
  }

  SwapResponse swapResponse = SwapResponse();
// For testing final dialog box
  // SwapResponse swapResponse = SwapResponse(
  //     id: "66325ae0ffb95a575f0bf4a4",
  //     chainFrom: "bsc",
  //     chainTo: "matic",
  //     addressFrom: "0x9eb494403e8f2dff389fa2e64b63d888bbd97860",
  //     addressTo: "0x9eb494403e8f2dff389fa2e64b63d888bbd97860",
  //     expectedAmountFrom: 4,
  //     expectedAmountTo: 1,
  //     txidFrom:
  //         "0x15179093bf68a23a621a6e1a3f5bc02bf5dfa7a422dbd71c1252aaf298a2b670",
  //     fee: 3,
  //     timestamp: 1714498454333);

  bool _isSwapCreated = false; // Set by the Approved Button
  bool _isSwapValid = false; // Set by the Approved Button
  String swapMessage = '';

  set isSwapValid(value) {
    _isSwapValid = value;
    notifyListeners();
  }

  set isSwapCreated(value) {
    _isSwapCreated = value;
    notifyListeners();
  }

  bool get isSwapValid => _isSwapValid;
  bool get isSwapCreated => _isSwapCreated;

  bool isSwapInfoLoading = true;
  bool hasSwapInfoError = false;
  String errorSwapInfoMessage = "";

  void resetForNewSwap() {
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

  // Controllers
  double updateReceivedAmount() {
    double fee = getEstimatedFee(
        fromAmount,
        getCurrencyApiName(selectedFromCurrency),
        getCurrencyApiName(selectedToCurrency),
        swapInfoResponse);

    toAmount = fromAmount - fee;
    return toAmount;
  }

  Future<void> connectMetamask() async {
    if (isEnabled) {
      final accs = await ethereum!.requestAccount();
      account = accs[0];

      if (accs.isNotEmpty) currentAddress = accs.first;

      currentChain = await ethereum!.getChainId();

      coinInfo.forEach((key, value) {
        if (value.chainId == currentChain) {
          selectedChain = value.chainName;
          previousSelectedChain = selectedChain;
          selectedFromCurrency = value.swapingName;
          if (selectedToCurrency == selectedFromCurrency) {
            selectedToCurrency = 'FLUX';
          }
        }
      });

      getBalance();
      getFluxTokenBalance(currentChain);

      notifyListeners();
    }
  }

  Future<void> requestChangeChainMetamask() async {
    if (isEnabled) {
      try {
        await ethereum!
            .walletSwitchChain(metamaskNetworks[selectedChain]!.chainId);
      } on EthereumUnrecognizedChainException {
        try {
          await ethereum!.walletAddChain(
              chainId: metamaskNetworks[selectedChain]!.chainId,
              chainName: selectedChain,
              nativeCurrency: metamaskNetworks[selectedChain]!.currencyParams,
              rpcUrls: metamaskNetworks[selectedChain]!.rpcurls,
              blockExplorerUrls:
                  metamaskNetworks[selectedChain]!.blockexplorerurls);
        } on EthereumUserRejected {
          selectedChain = previousSelectedChain;
          notifyListeners();
        }
      } on EthereumException {
        try {
          await ethereum!.walletAddChain(
              chainId: metamaskNetworks[selectedChain]!.chainId,
              chainName: selectedChain,
              nativeCurrency: metamaskNetworks[selectedChain]!.currencyParams,
              rpcUrls: metamaskNetworks[selectedChain]!.rpcurls,
              blockExplorerUrls:
                  metamaskNetworks[selectedChain]!.blockexplorerurls);
        } on EthereumUserRejected {
          selectedChain = previousSelectedChain;
          notifyListeners();
        }
      } on EthereumUserRejected {
        selectedChain = previousSelectedChain;
        notifyListeners();
      }
    }
  }

  Future<void> getBalance() async {
    if (isConnected) {
      final balance = await provider!.getBalance(account);

      gasBalance = balance;
      notifyListeners();
    }
  }

  Future<void> getFluxTokenBalance(chain) async {
    if (isConnected) {
      final contract = ContractERC20(getContract(chain), provider);

      final balance = await contract.balanceOf(account);
      fluxBalance = balance;

      notifyListeners();
    }
  }

  Future<MetamaskReturn> sendToken(
      int chain, String spenderAddress, String recepient, BigInt amount) async {
    try {
      if (isConnected) {
        final newAmount = FluxAmount.fromBigInt(FluxUnit.flux, amount);

        print(amount);
        print(newAmount);
        // Get the contract
        final signer = provider!.getSigner();
        final contract = ContractERC20(getContract(chain), signer);

        // Get the current allow amount to spend
        final currentAllowance =
            await contract.allowance(spenderAddress, spenderAddress);

        print('Current Allowance: $currentAllowance');
        print('Spending Amount Allowance: $amount');

        if (currentAllowance < amount) {
          // If not sufficient, increase the allowance
          print('Increasing allowance for $spenderAddress...');
          final approveTx =
              await contract.approve(spenderAddress, newAmount.getInWei);
          await approveTx.wait();
          print('Allowance increased.');
        }
        // Now transfer the tokens
        final transaction = await contract.transferFrom(
            spenderAddress, recepient, newAmount.getInWei);

        // If you want to wait until the transaction is mined into a block
        // final receipt = await transaction.wait();
        // print('Transfer successful: $receipt');

        notifyListeners();
        MetamaskReturn metamaskReturn = MetamaskReturn();
        metamaskReturn.fSuccessful = true;
        metamaskReturn.hash = transaction.hash;

        return metamaskReturn;
      } else {
        MetamaskReturn metamaskReturn = MetamaskReturn();
        metamaskReturn.fSuccessful = false;
        metamaskReturn.message = "Metamask not connected";
        return metamaskReturn;
      }
    } on EthereumUserRejected {
      MetamaskReturn metamaskReturn = MetamaskReturn();
      metamaskReturn.fSuccessful = false;
      metamaskReturn.fCancelled = true;
      return metamaskReturn;
    } catch (e) {
      print('Failed to transfer tokens: $e');
      MetamaskReturn metamaskReturn = MetamaskReturn();
      metamaskReturn.fSuccessful = false;
      metamaskReturn.fCancelled = false;
      metamaskReturn.message = e.toString();
      return metamaskReturn;
    }
  }

  bool isConnectedChainSendable() {
    if (isConnected) {
      for (CoinInfo info in coinInfo.values) {
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
    return '${getQRCodeUriName(submittedFromCurrency)}:${getSwapAddress(swapInfoResponse, submittedFromCurrency)}?amount=$fromAmount';
  }

  String verifyProviderData() {
    if (toAmount <= 0) {
      return "Received Amount <= 0";
    }

    if (fromAmount <= 0) {
      return "From Amount <= 0";
    }

    if (submittedFromCurrency == submittedToCurrency) {
      return "Same Currencies selected";
    }

    if (toAddress.isEmpty) {
      return "Destination Address Empty";
    }

    if (fromAddress.isEmpty) {
      return "From Address Empty";
    }

    return "";
  }

  double getGasCoinAmount() {
    FluxAmount amount = FluxAmount.fromBigInt(FluxUnit.wei, gasBalance);
    return amount.getValueInUnit(FluxUnit.ether);
  }

  double getFluxCoinAmount() {
    FluxAmount amount = FluxAmount.fromBigInt(FluxUnit.wei, fluxBalance);
    return amount.getValueInUnit(FluxUnit.flux);
  }

  String getGasCoinName(int chain) {
    String coinname = "Unknown";

    for (var value in CoinDetails.details.entries) {
      if (value.value.chain == chain) {
        coinname = value.key.name;
        break;
      }
    }

    return coinname;
  }

  String getContract(int chain) {
    String contract = "";

    for (var value in CoinDetails.details.entries) {
      if (value.value.chain == chain) {
        contract = value.value.contractAddress;
        break;
      }
    }

    return contract;
  }

  clear() {
    currentAddress = '';
    currentChain = -1;
    notifyListeners();
  }

  init() {
    getSwapInfo().then((response) {
      swapInfoResponse = response;
      isSwapInfoLoading = false;
      updateReceivedAmount();
    }).catchError((error) {
      hasSwapInfoError = true;
      errorSwapInfoMessage = error.toString();
      isSwapInfoLoading = false;
    });

    if (isEnabled) {
      ethereum!.onAccountsChanged((accounts) {
        clear();
      });
      ethereum!.onChainChanged((accounts) {
        clear();
        connectMetamask();
      });
    }
  }
}
