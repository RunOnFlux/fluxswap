import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluxswap/constants/coin_details.dart';
import 'package:fluxswap/utils/helpers.dart';
import 'package:fluxswap/api/models/swap_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:fluxswap/providers/flux_swap_provider.dart';

class SwapHistoryList extends StatefulWidget {
  const SwapHistoryList({super.key});

  @override
  _SwapHistoryListState createState() => _SwapHistoryListState();
}

class _SwapHistoryListState extends State<SwapHistoryList> {
  List<SwapResponse> swapHistory = [];
  bool isLoading = false;
  String lastFetchedZelid = '';
  Timer? periodicTimer;

  @override
  void initState() {
    super.initState();
    // Set up a periodic fetch every 5 minutes
    periodicTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      final zelid =
          Provider.of<FluxSwapProvider>(context, listen: false).fluxID;
      if (zelid.isNotEmpty && zelid != lastFetchedZelid) {
        fetchHistory(zelid);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final zelid = Provider.of<FluxSwapProvider>(context).fluxID;
    if (zelid.isNotEmpty && zelid != lastFetchedZelid) {
      fetchHistory(zelid);
    }
  }

  @override
  void dispose() {
    periodicTimer?.cancel(); // Cancel the periodic timer
    super.dispose();
  }

  Future<void> fetchHistory(String zelid) async {
    setState(() {
      isLoading = true;
      lastFetchedZelid = zelid; // Update the last fetched zelid
    });

    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'zelid': zelid,
      };

      const url = 'https://fusion.runonflux.io/swap/userhistory';
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body)['data'];
        setState(() {
          swapHistory = jsonList
              .map((jsonItem) => SwapResponse.fromJson(jsonItem))
              .toList()
              .reversed
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load swap history');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Failed to fetch swap history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final fluxID = Provider.of<FluxSwapProvider>(context).fluxID;
    final provider = Provider.of<FluxSwapProvider>(context);

    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            width: double.infinity,
            alignment: Alignment.center,
            child: const Text(
              "History",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (fluxID.isEmpty || swapHistory.isEmpty)
            const Expanded(
              child: Center(
                child: Text("No History Available"),
              ),
            )
          else if (isLoading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: swapHistory.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                        onTap: () {
                          provider.swapToDisplay = swapHistory[index];
                          provider.fShowSwapCard = true;
                        },
                        title: Column(
                          children: [
                            Text(
                              provider.dateFormat.format(DateTime.fromMillisecondsSinceEpoch(swapHistory[index].timestamp).toLocal()),
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                    '${Coin_Details[getSwapNameFromApiName(swapHistory[index].chainFrom)]?.imageName}'),
                                const Icon(Icons.arrow_right_alt,
                                    size: 40, color: Colors.green),
                                SvgPicture.asset(
                                    '${Coin_Details[getSwapNameFromApiName(swapHistory[index].chainTo)]?.imageName}'),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Sending: ${swapHistory[index].expectedAmountFrom}'),
                            Text(
                                'Receiving: ${swapHistory[index].expectedAmountTo}'),
                          ],
                        ),
                        trailing: Column(
                          children: [
                            Text(
                              'ID: ${swapHistory[index].id.substring(0, 6)}...${swapHistory[index].id.substring(swapHistory[index].id.length - 4)}',
                            ),
                            const SizedBox(height: 10),
                            Text('Status: ${swapHistory[index].status}'),
                          ],
                        )),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
