import 'package:flutter_web3/flutter_web3.dart';

class CoinInfo {
  final String apiname;
  final String swapingName;
  final String contractAddress;
  final String imageName;
  final int chainId;
  final String chainName;

  CoinInfo(
      {required this.apiname,
      required this.swapingName,
      required this.contractAddress,
      required this.imageName,
      required this.chainId,
      required this.chainName});
}

var coinInfo = {
  "FLUX": CoinInfo(
      apiname: 'main',
      swapingName: "FLUX",
      contractAddress: "",
      imageName: '/images/flux-icon.svg',
      chainId: 0,
      chainName: "Flux"),
  "ETH": CoinInfo(
      apiname: 'eth',
      swapingName: "FLUX-ETH",
      contractAddress: "0x720CD16b011b987Da3518fbf38c3071d4F0D1495",
      imageName: '/images/eth-icon.svg',
      chainId: 1,
      chainName: "Ethereum"),
  "BSC": CoinInfo(
      apiname: 'bsc',
      swapingName: "FLUX-BSC",
      contractAddress: "0xaFF9084f2374585879e8B434C399E29E80ccE635",
      imageName: '/images/bnb-icon.svg',
      chainId: 56,
      chainName: "BNB Chain"),
  "SOL": CoinInfo(
      apiname: 'sol',
      swapingName: "FLUX-SOL",
      contractAddress: "FLUX1wa2GmbtSB6ZGi2pTNbVCw3zEeKnaPCkPtFXxqXe",
      imageName: '/images/flux-icon.svg',
      chainId: 0,
      chainName: "Solona"),
  "TRX": CoinInfo(
      apiname: 'trx',
      swapingName: "FLUX-TRON",
      contractAddress: "TWr6yzukRwZ53HDe3bzcC8RCTbiKa4Zzb6",
      imageName: '/images/flux-icon.svg',
      chainId: 0,
      chainName: "Tron"),
  "AVAX": CoinInfo(
      apiname: 'avax',
      swapingName: "FLUX-AVAX",
      contractAddress: "0xc4B06F17ECcB2215a5DBf042C672101Fc20daF55",
      imageName: '/images/avax-icon.svg',
      chainId: 43114,
      chainName: "Avalanche"),
  "ERGO": CoinInfo(
      apiname: 'erg',
      swapingName: "FLUX-ERGO",
      contractAddress:
          "e8b20745ee9d18817305f32eb21015831a48f02d40980de6e849f886dca7f807",
      imageName: '/images/flux-icon.svg',
      chainId: 0,
      chainName: "Ergo"),
  "ALGO": CoinInfo(
      apiname: 'algo',
      swapingName: "FLUX-ALGO",
      contractAddress: "1029804829",
      imageName: '/images/flux-icon.svg',
      chainId: 0,
      chainName: "Alogrand"),
  "MATIC": CoinInfo(
      apiname: 'matic',
      swapingName: "FLUX-MATIC",
      contractAddress: "102980xA2bb7A68c46b53f6BbF6cC91C865Ae247A82E99B04829",
      imageName: '/images/polygon-icon.svg',
      chainId: 137,
      chainName: "Polygon"),
  "BASE": CoinInfo(
      apiname: 'base',
      swapingName: "FLUX-BASE",
      contractAddress: "0xb008bdcf9cdff9da684a190941dc3dca8c2cdd44",
      imageName: '/images/base-icon.svg',
      chainId: 8453,
      chainName: "Base"),
  "KDA": CoinInfo(
      apiname: 'kda',
      swapingName: "FLUX-KDA",
      contractAddress: "",
      imageName: '/images/flux-icon.svg',
      chainId: 0,
      chainName: "Kda"),
  // "BTC": CoinInfo(
  //     apiname: 'btc',
  //     swapingName: "FLUX-BTC",
  //     contractAddress: "",
  //     imageName: '/images/flux-icon.svg',
  //     chainId: 0,
  //     chainName: "Bitcoin"),
};

class MetaMaskNetworkInfo {
  final String imageName;
  final int chainId;
  final CurrencyParams currencyParams;
  final List<String> rpcurls;
  final List<String> blockexplorerurls;

  MetaMaskNetworkInfo(
      {required this.imageName,
      required this.chainId,
      required this.currencyParams,
      required this.rpcurls,
      required this.blockexplorerurls});
}

var metamaskNetworks = {
  'Ethereum': MetaMaskNetworkInfo(
      imageName: '/images/eth-icon.svg',
      chainId: 1,
      currencyParams: CurrencyParams(name: 'ETH', symbol: 'ETH', decimals: 18),
      rpcurls: ['https://mainnet.infura.io/v3/'],
      blockexplorerurls: ['https://etherscan.io']),
  'BNB Chain': MetaMaskNetworkInfo(
      imageName: '/images/bnb-icon.svg',
      chainId: 56,
      currencyParams: CurrencyParams(name: 'BNB', symbol: 'BNB', decimals: 18),
      rpcurls: ['https://bsc-dataseed.binance.org/'],
      blockexplorerurls: ['https://bscscan.com/']),
  'Polygon': MetaMaskNetworkInfo(
      imageName: '/images/polygon-icon.svg',
      chainId: 137,
      currencyParams:
          CurrencyParams(name: 'MATIC', symbol: 'MATIC', decimals: 18),
      rpcurls: ['https://polygon-mainnet.infura.io'],
      blockexplorerurls: ['https://polygonscan.com/']),
  'Avalanche': MetaMaskNetworkInfo(
      imageName: '/images/avax-icon.svg',
      chainId: 43114,
      currencyParams:
          CurrencyParams(name: 'AVAX', symbol: 'AVAX', decimals: 18),
      rpcurls: ['https://api.avax.network/ext/bc/C/rpc'],
      blockexplorerurls: ['https://snowtrace.io/']),
  'Base': MetaMaskNetworkInfo(
      imageName: '/images/base-icon.svg',
      chainId: 8453,
      currencyParams: CurrencyParams(name: 'ETH', symbol: 'ETH', decimals: 18),
      rpcurls: ['https://mainnet.base.org'],
      blockexplorerurls: ['https://basescan.org']),
};

String getNetworkName(int chain) {
  String network = "Unknown Network";

  for (CoinInfo info in coinInfo.values) {
    if (info.chainId == chain) {
      network = info.chainName;
      break;
    }
  }
  return network;
}

String getSecondPart(String input) {
  List<String> parts = input.split('-');
  return parts.length > 1 ? parts[1] : 'FLUX';
}

String convertCurrencyForAPI(String currency) {
  if (coinInfo.containsKey(currency)) {
    return coinInfo[currency]!.apiname;
  }

  String secondpart = getSecondPart(currency);
  if (coinInfo.containsKey(secondpart)) {
    return coinInfo[secondpart]!.apiname;
  }

  return '';
}
