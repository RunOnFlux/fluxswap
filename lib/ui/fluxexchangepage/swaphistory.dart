import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluxswap/constants/coin_details.dart';
import 'package:provider/provider.dart';
import 'package:fluxswap/api/models/swap_model.dart';
import 'package:fluxswap/providers/flux_swap_provider.dart';
import 'package:fluxswap/utils/address_validator.dart';
import 'package:fluxswap/utils/helpers.dart';
import 'package:fluxswap/ui/fluxexchangepage/swapinfo.dart';

class SearchHistory extends StatefulWidget {
  const SearchHistory({super.key});

  @override
  _SearchHistoryState createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistory> {
  Timer? periodicTimer;
  TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    // Set up a periodic fetch every 5 minutes
    periodicTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      final provider = Provider.of<FluxSwapProvider>(context, listen: false);
      final zelid = provider.fluxID;
      if (zelid.isNotEmpty) {
        provider.fetchHistory(zelid);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<FluxSwapProvider>(context);
    final zelid = provider.fluxID;
    if (zelid.isNotEmpty) {
      provider.fetchHistory(zelid);
    }
  }

  @override
  void dispose() {
    periodicTimer?.cancel(); // Cancel the periodic timer
    searchController.dispose();
    super.dispose();
  }

  void handleSearch() {
    if (_formKey.currentState!.validate()) {
      final input = searchController.text.trim();
      final provider = Provider.of<FluxSwapProvider>(context, listen: false);
      if (isValidBitcoinAddress(input) || isValidEthereumAddress(input)) {
        provider.fetchHistory(input);
      } else {
        provider.fetchSwapInfo(input);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FluxSwapProvider>(context);
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.normal),
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: "Enter Swap ID or Flux ID",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: handleSearch,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'ID can\'t be blank'; // Customize this message based on the field if needed
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      handleSearch();
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
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
              if (provider.searchedFluxId.isNotEmpty)
                Text(
                  provider.searchedFluxId,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              const Divider(color: Colors.black),
              if (provider.swapHistory.isNotEmpty)
                Text(
                  'Swaps: ${provider.swapHistory.length}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              if (provider.fluxID.isEmpty && provider.swapHistory.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text("No History Available"),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.swapHistory.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            provider.searchToDisplay =
                                provider.swapHistory[index];
                            provider.fShowSearchedCard = true;
                            setState(() {});
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    provider.dateFormat.format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                                provider.swapHistory[index]
                                                    .timestamp)
                                            .toLocal()),
                                    style: const TextStyle(
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.content_copy,
                                        size: 20),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(
                                          text:
                                              provider.swapHistory[index].id));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('ID copied to clipboard'),
                                        ),
                                      );
                                    },
                                  ),
                                  Text(
                                    provider.swapHistory[index].id,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                      '${provider.swapHistory[index].expectedAmountFrom} ${getSwapNameFromApiName(provider.swapHistory[index].chainFrom)}'),
                                  SvgPicture.asset(
                                      '${Coin_Details[getSwapNameFromApiName(provider.swapHistory[index].chainFrom)]?.imageName}'),
                                  const Icon(Icons.arrow_right_alt,
                                      size: 40, color: Colors.green),
                                  Text(
                                      '${provider.swapHistory[index].expectedAmountTo} ${getSwapNameFromApiName(provider.swapHistory[index].chainTo)}'),
                                  SvgPicture.asset(
                                      '${Coin_Details[getSwapNameFromApiName(provider.swapHistory[index].chainTo)]?.imageName}'),
                                  const Spacer(),
                                  Text(
                                    'Status: ${provider.swapHistory[index].status}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
        if (_isFetching)
          Positioned.fill(
            child: Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        if (provider.fShowSearchedCard)
          Positioned.fill(
            child: Container(
              color: Colors.black54,
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: SwapInfoCard(
                    swapResponse: provider.searchToDisplay,
                    fSearch: true,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
