import 'package:flutter/cupertino.dart';
import 'package:flutter_web3/flutter_web3.dart';
import '/metamask/fluxamount.dart';
import '/fees/fees.dart';
import '/helper/modals.dart';

class ContractInfo {
  final int chain;
  final String contractAddress;

  const ContractInfo({
    required this.chain,
    required this.contractAddress,
  });
}

// ignore: constant_identifier_names
enum Coin { FLUX, ETH, BSC, AVAX, MATIC }

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
  };

  static ContractInfo getInfo(Coin coin) {
    return details[coin]!;
  }
}

class FluxSwapProvider extends ChangeNotifier {
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

  // App Variables
  String selectedFromCurrency = 'FLUX';
  String selectedToCurrency = 'FLUX-ETH';
  String fluxID = '';
  double fromAmount = 100;
  double toAmount = 0;
  String _fromAddress = '';
  String _toAddress = '';

  // Requests / Reponses
  late SwapInfoResponse swapInfoResponse;

  bool _isReservedApproved = false; // Set by the Approved Button
  bool _isReservedValid = false;
  String _reservedMessage = '';

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

  bool isSwapCreated = false; // Set by the Approved Button
  bool isSwapValid = false; // Set by the Approved Button
  String swapMessage = '';

  bool isSwapInfoLoading = true;
  bool hasSwapInfoError = false;
  String errorSwapInfoMessage = "";

  // Controllers
  double updateReceivedAmount() {
    double fee = getEstimatedFee(
        fromAmount,
        convertCurrencyForAPI(selectedFromCurrency),
        convertCurrencyForAPI(selectedToCurrency),
        swapInfoResponse);

    toAmount = fromAmount - fee;
    return toAmount;
  }

  Future<void> connect() async {
    if (isEnabled) {
      final accs = await ethereum!.requestAccount();
      account = accs[0];

      if (accs.isNotEmpty) currentAddress = accs.first;

      currentChain = await ethereum!.getChainId();

      getBalance();
      getFluxTokenBalance(currentChain);

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

  Future<void> getFluxTokenBalance(chain) async {
    if (isConnected) {
      final contract = ContractERC20(getContract(chain), provider);

      final balance = await contract.balanceOf(account);
      fluxBalance = balance;

      notifyListeners();
    }
  }

  Future<String> sendToken(
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
        final receipt = await transaction.wait();
        print('Transfer successful: $receipt');

        notifyListeners();

        return receipt.transactionHash;
      } else {
        return "";
      }
    } catch (e) {
      print('Failed to transfer tokens: $e');
      return "";
    }
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

  String getSecondPart(String input) {
    List<String> parts = input.split('-');
    return parts.length > 1 ? parts[1] : '';
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
      });
    }
  }
}
