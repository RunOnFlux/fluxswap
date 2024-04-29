import 'package:flutter_web3/flutter_web3.dart';

var chainIds = {
  1: "Ethereum",
  3: "Ropsten Test Network",
  4: "Rinkeby Test Network",
  5: "Goerli Test Network",
  42: "Kovan Test Network",
  56: "BNB Chain",
  97: "Binance Smart Chain Test Network",
  137: "Polygon",
  43114: "Avalanche",
  8453: "Base",
};

var fluxContractAddresses = {
  "ETH": '0x720CD16b011b987Da3518fbf38c3071d4F0D1495',
  "BSC": '0xaFF9084f2374585879e8B434C399E29E80ccE635',
  "SOL": 'FLUX1wa2GmbtSB6ZGi2pTNbVCw3zEeKnaPCkPtFXxqXe',
  "TRON": 'TWr6yzukRwZ53HDe3bzcC8RCTbiKa4Zzb6',
  "AVAX": '0xc4B06F17ECcB2215a5DBf042C672101Fc20daF55',
  "ERGO": 'e8b20745ee9d18817305f32eb21015831a48f02d40980de6e849f886dca7f807',
  "ALGO": '1029804829',
  "MATIC": '0xA2bb7A68c46b53f6BbF6cC91C865Ae247A82E99B',
  "BASE": '0xb008bdcf9cdff9da684a190941dc3dca8c2cdd44',
};

var fluxChainNames = {
  "FLUX": 'main',
  "ETH": 'eth',
  "BSC": 'bsc',
  "SOL": 'sol',
  "TRX": 'trx',
  "AVAX": 'avax',
  "ERGO": 'erg',
  "ALGO": 'algo',
  "MATIC": 'matic',
  "BASE": 'base',
  "BTC": 'btc',
  "KDA": 'kda'
};

class SwapingCoin {
  final String name;
  final String imageName;

  SwapingCoin({
    required this.name,
    required this.imageName,
  });
}

var swapingCoins = {
  "FLUX": SwapingCoin(name: 'FLUX', imageName: '/images/flux-icon.svg'),
  'FLUX-BSC': SwapingCoin(name: 'FLUX-BSC', imageName: '/images/bnb-icon.svg'),
  'FLUX-SOL': SwapingCoin(name: 'FLUX-SOL', imageName: '/images/flux-icon.svg'),
  'FLUX-TRX': SwapingCoin(name: 'FLUX-TRX', imageName: '/images/flux-icon.svg'),
  'FLUX-ERGO':
      SwapingCoin(name: 'FLUX-ERGO', imageName: '/images/flux-icon.svg'),
  'FLUX-AVAX':
      SwapingCoin(name: 'FLUX-AVAX', imageName: '/images/avax-icon.svg'),
  'FLUX-ALGO':
      SwapingCoin(name: 'FLUX-ALGO', imageName: '/images/flux-icon.svg'),
  'FLUX-MATIC':
      SwapingCoin(name: 'FLUX-MATIC', imageName: '/images/polygon-icon.svg'),
  'FLUX-KDA': SwapingCoin(name: 'FLUX-KDA', imageName: '/images/flux-icon.svg'),
  'FLUX-ETH': SwapingCoin(name: 'FLUX-ETH', imageName: '/images/eth-icon.svg'),
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
  if (chainIds.containsKey(chain)) {
    network = chainIds[chain]!;
  }
  return network;
}

String getSecondPart(String input) {
  List<String> parts = input.split('-');
  return parts.length > 1 ? parts[1] : '';
}

String convertCurrencyForAPI(String currency) {
  if (fluxChainNames.containsKey(currency)) {
    return fluxChainNames[currency]!;
  }

  String secondpart = getSecondPart(currency);
  if (fluxChainNames.containsKey(secondpart)) {
    return fluxChainNames[secondpart]!;
  }

  return '';
}
