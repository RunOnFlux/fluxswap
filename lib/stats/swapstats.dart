import 'dart:convert';
import 'package:http/http.dart' as http;

class SwapStats {
  final String status;
  final SwapData data;

  SwapStats({required this.status, required this.data});

  factory SwapStats.fromJson(Map<String, dynamic> json) {
    return SwapStats(
      status: json['status'],
      data: SwapData.fromJson(json['data']),
    );
  }
}

class SwapData {
  final int totalSwaps,
      swapsFinished,
      swapsNew,
      swapsWaiting,
      swapsExchanging,
      swapsExpired,
      swapsHold,
      swapsConfirming,
      swapsDust,
      swapsToMain,
      swapsToKDA,
      swapsToETH,
      swapsToBSC,
      swapsToTRX,
      swapsToSOL,
      swapsToAVAX,
      swapsToERG,
      swapsToALGO,
      swapsToMATIC,
      swapsToBASE,
      swapsFromMain,
      swapsFromKDA,
      swapsFromETH,
      swapsFromBSC,
      swapsFromTRX,
      swapsFromSOL,
      swapsFromAVAX,
      swapsFromERG,
      swapsFromALGO,
      swapsFromMATIC,
      swapsFromBASE;
  final double feeCaptured,
      mainFeeCaptured,
      kdaFeeCaptured,
      ethFeeCaptured,
      bscFeeCaptured,
      trxFeeCaptured,
      solFeeCaptured,
      avaxFeeCaptured,
      ergFeeCaptured,
      algoFeeCaptured,
      maticFeeCaptured,
      baseFeeCaptured;

  SwapData({
    required this.totalSwaps,
    required this.swapsFinished,
    required this.swapsNew,
    required this.swapsWaiting,
    required this.swapsExchanging,
    required this.swapsExpired,
    required this.swapsHold,
    required this.swapsConfirming,
    required this.swapsDust,
    required this.feeCaptured,
    required this.mainFeeCaptured,
    required this.kdaFeeCaptured,
    required this.ethFeeCaptured,
    required this.bscFeeCaptured,
    required this.trxFeeCaptured,
    required this.solFeeCaptured,
    required this.avaxFeeCaptured,
    required this.ergFeeCaptured,
    required this.algoFeeCaptured,
    required this.maticFeeCaptured,
    required this.baseFeeCaptured,
    required this.swapsToMain,
    required this.swapsToKDA,
    required this.swapsToETH,
    required this.swapsToBSC,
    required this.swapsToTRX,
    required this.swapsToSOL,
    required this.swapsToAVAX,
    required this.swapsToERG,
    required this.swapsToALGO,
    required this.swapsToMATIC,
    required this.swapsToBASE,
    required this.swapsFromMain,
    required this.swapsFromKDA,
    required this.swapsFromETH,
    required this.swapsFromBSC,
    required this.swapsFromTRX,
    required this.swapsFromSOL,
    required this.swapsFromAVAX,
    required this.swapsFromERG,
    required this.swapsFromALGO,
    required this.swapsFromMATIC,
    required this.swapsFromBASE,
  });

  factory SwapData.fromJson(Map<String, dynamic> json) {
    return SwapData(
      totalSwaps: json['totalSwaps'],
      swapsFinished: json['swapsFinished'],
      swapsNew: json['swapsNew'],
      swapsWaiting: json['swapsWaiting'],
      swapsExchanging: json['swapsExchanging'],
      swapsExpired: json['swapsExpired'],
      swapsHold: json['swapsHold'],
      swapsConfirming: json['swapsConfirming'],
      swapsDust: json['swapsDust'],
      feeCaptured: json['feeCaptured'],
      mainFeeCaptured: json['mainFeeCaptured'],
      kdaFeeCaptured: json['kdaFeeCaptured'],
      ethFeeCaptured: json['ethFeeCaptured'],
      bscFeeCaptured: json['bscFeeCaptured'],
      trxFeeCaptured: json['trxFeeCaptured'],
      solFeeCaptured: json['solFeeCaptured'],
      avaxFeeCaptured: json['avaxFeeCaptured'],
      ergFeeCaptured: json['ergFeeCaptured'],
      algoFeeCaptured: json['algoFeeCaptured'],
      maticFeeCaptured: json['maticFeeCaptured'],
      baseFeeCaptured: json['baseFeeCaptured'],
      swapsToMain: json['swapsToMain'],
      swapsToKDA: json['swapsToKda'],
      swapsToETH: json['swapsToEth'],
      swapsToBSC: json['swapsToBsc'],
      swapsToTRX: json['swapsToTrx'],
      swapsToSOL: json['swapsToSol'],
      swapsToAVAX: json['swapsToAvax'],
      swapsToERG: json['swapsToErg'],
      swapsToALGO: json['swapsToAlgo'],
      swapsToMATIC: json['swapsToMatic'],
      swapsToBASE: json['swapsToBase'],
      swapsFromMain: json['swapsFromMain'],
      swapsFromKDA: json['swapsFromKda'],
      swapsFromETH: json['swapsFromEth'],
      swapsFromBSC: json['swapsFromBsc'],
      swapsFromTRX: json['swapsFromTrx'],
      swapsFromSOL: json['swapsFromSol'],
      swapsFromAVAX: json['swapsFromAvax'],
      swapsFromERG: json['swapsFromErg'],
      swapsFromALGO: json['swapsFromAlgo'],
      swapsFromMATIC: json['swapsFromMatic'],
      swapsFromBASE: json['swapsFromBase'],
    );
  }
}

Future<SwapStats> fetchSwapStats() async {
  const url = 'https://fusion.runonflux.io/swap/stats';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return SwapStats.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load swap stats');
  }
}
