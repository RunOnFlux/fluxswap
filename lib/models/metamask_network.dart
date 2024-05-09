import 'package:flutter_web3/flutter_web3.dart';

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
