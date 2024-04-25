var chainIds = {
  1: "Ethereum",
  3: "Ropsten Test Network",
  4: "Rinkeby Test Network",
  5: "Goerli Test Network",
  42: "Kovan Test Network",
  56: "Binance Smart Chain",
  97: "Binance Smart Chain Test Network",
  137: "Polygon Main Network",
  43114: "AVAX-C-Chain",
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
