import 'package:fluxswap/constants/coin_details.dart';
import 'package:fluxswap/models/coin_info.dart';
import 'package:fluxswap/models/enums.dart';

String getNetworkName(int chain) {
  String network = "Unknown Network";

  for (CoinInformation info in Coin_Details.values) {
    if (info.chainId == chain) {
      network = info.chainName;
      break;
    }
  }
  return network;
}

String getCurrencyApiName(String currency) {
  if (Coin_Details.containsKey(currency)) {
    return Coin_Details[currency]!.apiname;
  }

  return '';
}

String getSwapNameFromApiName(String name) {
  for (CoinInformation value in Coin_Details.values) {
    if (value.apiname == name) {
      return value.swapingName;
    }
  }
  return "Unknown Coin";
}

String getQRCodeUriName(String currency) {
  if (Coin_Details.containsKey(currency)) {
    return Coin_Details[currency]!.qrcodeuri;
  }

  return 'flux';
}

NETWORKS getNetworkFromSelectedCoin(String name) {
  if (Coin_Details.containsKey(name)) {
    return Coin_Details[name]!.network;
  }

  return NETWORKS.FLUX;
}
