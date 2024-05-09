import 'package:fluxswap/models/enums.dart';

class CoinInformation {
  final NETWORKS network;
  final String apiname;
  final String swapingName;
  final String contractAddress;
  final String imageName;
  final int chainId;
  final String chainName;
  final String qrcodeuri;

  CoinInformation(
      {required this.network,
      required this.apiname,
      required this.swapingName,
      required this.contractAddress,
      required this.imageName,
      required this.chainId,
      required this.chainName,
      required this.qrcodeuri});
}
