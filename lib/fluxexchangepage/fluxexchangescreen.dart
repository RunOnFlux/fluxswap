import 'dart:html';
import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluxswap/fluxexchangepage/amountbox/amountcontainerbox.dart';
import 'package:fluxswap/api/requests.dart';
import 'package:fluxswap/fluxexchangepage/buttons/reseverswapbutton.dart';
import 'package:fluxswap/helper/modals.dart';
import 'package:fluxswap/provider/fluxswapprovider.dart';
import 'package:fluxswap/fluxexchangepage/sendflux.dart';
import 'package:fluxswap/fluxswapstats/totalswaps.dart';
import 'package:fluxswap/fluxexchangepage/addressbox/addresstextformfield.dart';
import 'package:fluxswap/fluxexchangepage/zelidbox/zelidfield.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FluxExchangeScreen extends StatefulWidget {
  const FluxExchangeScreen({super.key});

  @override
  _FluxExchangeScreenState createState() => _FluxExchangeScreenState();
}

class _FluxExchangeScreenState extends State<FluxExchangeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController toAmountController = TextEditingController();

  void _showSnackbar() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Text Copied")));
  }

  void _copyText(String copytext) {
    FlutterClipboard.copy(copytext).then((value) => _showSnackbar());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 100),
        const Text(
          'Flux Exchange',
          style: TextStyle(
            // color: Colors.white,
            fontSize: 60,
          ),
        ),
        const Text(
          'Swap Flux between networks with ease',
          style: TextStyle(
            // color: Colors.white,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 20),
        const TotalSwapsDisplay(),
        const SizedBox(height: 40),
        Center(
          child: Consumer<FluxSwapProvider>(
            builder: (context, provider, child) {
              toAmountController.text =
                  "\u2248  ${provider.toAmount.toString()}";
              if (provider.isReservedApproved && !provider.isReservedValid) {
                return AlertDialog(
                  title: const Text('Reserve Failed to process'),
                  content: Text(
                      'Please fix the errors and try again: \n\n Error: ${provider.reservedMessage}'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        setState(() {
                          provider.isReservedApproved = false;
                          provider.isReservedValid = false;
                        });
                      },
                      child: const Text('Okay'),
                    ),
                  ],
                );
              } else if (provider.isReservedApproved &&
                  !provider.isSwapCreated) {
                return const SwapCard();
              } else if (provider.isSwapCreated) {
                String message = 'Your swap failed to submit';
                if (provider.isSwapValid) {
                  message = 'Your swap was successful';
                }
                return AlertDialog(
                  alignment: Alignment.center,
                  content: Column(
                    children: [
                      const Text(
                        "Swap Info",
                        style: TextStyle(
                          // color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Date: ${provider.dateFormat.format(DateTime.fromMillisecondsSinceEpoch(provider.swapResponse.timestamp).toLocal())}",
                            style: const TextStyle(
                              // color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Swap ID: ${provider.swapResponse.id}",
                            style: const TextStyle(
                              // color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                _copyText(provider.swapResponse.id),
                            icon: const Icon(Icons.content_copy_rounded),
                          ),
                        ],
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "From: ${provider.swapResponse.addressFrom}",
                            style: const TextStyle(
                              // color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                _copyText(provider.swapResponse.addressFrom),
                            icon: const Icon(Icons.content_copy_rounded),
                          ),
                        ],
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "To: ${provider.swapResponse.addressTo}",
                            style: const TextStyle(
                              // color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                _copyText(provider.swapResponse.addressTo),
                            icon: const Icon(Icons.content_copy_rounded),
                          ),
                        ],
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Fee: ${provider.swapResponse.fee}",
                            style: const TextStyle(
                              // color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${provider.submittedFromCurrency}",
                            style: const TextStyle(
                              // color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Explorer:",
                            style: const TextStyle(
                              // color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4),
                          InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  '${provider.swapResponse.txidFrom}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              onTap: () {
                                String url = explorerInfo[
                                        provider.swapResponse.chainFrom]! +
                                    provider.swapResponse.txidFrom;
                                print(url);
                                launchUrlString(url);
                              }),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${provider.swapResponse.expectedAmountFrom}",
                            style: const TextStyle(
                              // color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${provider.submittedFromCurrency}",
                            style: const TextStyle(
                              // color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SvgPicture.asset(
                            '${coinInfo[provider.submittedFromCurrency]?.imageName}',
                            width: 80,
                            height: 80,
                          ),
                          const Icon(
                            Icons.arrow_right_alt,
                            size: 80,
                            color: Colors.green,
                          ),
                          Text(
                            "${provider.swapResponse.expectedAmountTo}",
                            style: const TextStyle(
                              // color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${provider.submittedToCurrency}",
                            style: const TextStyle(
                              // color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SvgPicture.asset(
                            '${coinInfo[provider.submittedToCurrency]?.imageName}',
                            width: 80,
                            height: 80,
                          ),
                        ],
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        setState(() {
                          provider.resetForNewSwap();
                        });
                      },
                      child: const Text('Close'),
                    ),
                  ],
                );
              }
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: SizedBox(
                    width: 825,
                    height: 600,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FluxIdTextFormField(
                            labelText: 'Flux ID / Zel ID', formKey: _formKey),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            AddressTextFormField(
                                labelText: "From Address", formKey: _formKey),
                            const SizedBox(width: 2),
                            AmountContainer(
                              formKey: _formKey,
                              toAmountController: toAmountController,
                              isFrom: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            AddressTextFormField(
                                labelText: "To Address", formKey: _formKey),
                            const SizedBox(width: 2),
                            AmountContainer(
                                formKey: _formKey,
                                toAmountController: toAmountController,
                                isFrom: false),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 40,
                          child: ReserveSwapButton(
                            zelid: provider.fluxID,
                            reserveRequest: ReserveRequest(
                                addressFrom: provider.fromAddress,
                                addressTo: provider.toAddress,
                                chainFrom: getCurrencyApiName(
                                    provider.selectedFromCurrency),
                                chainTo: getCurrencyApiName(
                                    provider.selectedToCurrency)),
                            formKey: _formKey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
