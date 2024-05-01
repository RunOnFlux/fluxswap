import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluxswap/api/swapinfo.dart';
import 'package:fluxswap/api/requests.dart';
import 'package:fluxswap/helper/modals.dart';
import 'package:provider/provider.dart';
import 'package:fluxswap/provider/fluxswapprovider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SwapCard extends StatefulWidget {
  const SwapCard({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SwapCardState createState() => _SwapCardState();
}

class _SwapCardState extends State<SwapCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController transactionIDController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FluxSwapProvider>(context);
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: 900,
            height: 900,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Text(
                    'Send the ${provider.submittedFromCurrency}',
                    style: const TextStyle(fontSize: 24, color: Colors.blue),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: const Color.fromRGBO(237, 237, 237, 1),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Send',
                                  style: TextStyle(fontSize: 18),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "${provider.fromAmount.toString()} ${provider.submittedFromCurrency}", // Linked to a controller
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  'to',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(width: 5),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  getSwapAddress(provider.swapInfoResponse,
                                      provider.submittedFromCurrency),
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  onPressed: () => _copyText(
                                    getSwapAddress(provider.swapInfoResponse,
                                        provider.submittedFromCurrency),
                                  ),
                                  icon: const Icon(Icons.content_copy_rounded),
                                ),
                              ],
                            ),
                            const Text(
                              "Scan with Zelcore",
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                            QrImageView(
                              data: provider.getQRData(),
                              version: QrVersions.auto,
                              size: 150.0,
                            ),
                            Consumer<FluxSwapProvider>(
                                builder: (context, provider, child) {
                              bool showWalletButton =
                                  provider.isConnectedChainSendable();
                              if (showWalletButton) {
                                return ElevatedButton(
                                    onPressed: () {
                                      String error =
                                          provider.verifyProviderData();
                                      if (error != "") {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Data error'),
                                              content: Text(error),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text('OK'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        provider
                                            .sendToken(
                                                provider.currentChain,
                                                provider.fromAddress,
                                                getSwapAddress(
                                                    provider.swapInfoResponse,
                                                    provider
                                                        .submittedFromCurrency),
                                                BigInt.from(
                                                    provider.fromAmount))
                                            .then((value) {
                                          if (value.fSuccessful) {
                                            provider.swapTxid = value.hash;
                                            final swapRequest = SwapRequest(
                                                amountFrom: provider.fromAmount,
                                                addressFrom:
                                                    provider.fromAddress,
                                                addressTo: provider.toAddress,
                                                chainFrom: getCurrencyApiName(
                                                    provider
                                                        .submittedFromCurrency),
                                                chainTo: getCurrencyApiName(
                                                    provider
                                                        .submittedToCurrency),
                                                txidFrom: value.hash);
                                            createSwapRequest("", swapRequest)
                                                .then(
                                              (value) {
                                                bool success = value[0];
                                                String message = value[1];
                                                SwapResponse response =
                                                    value[2];
                                                print(success);
                                                print(message);
                                                print(
                                                    "Received: ${response.toJson().toString()}");
                                                provider.swapResponse =
                                                    response;
                                                if (success) {
                                                  provider.isSwapCreated = true;
                                                  provider.isSwapValid = true;
                                                  provider.swapMessage =
                                                      message;
                                                } else {
                                                  provider.isSwapCreated = true;
                                                  provider.isSwapValid = false;
                                                  provider.swapMessage =
                                                      message;
                                                }
                                              },
                                            );
                                          }
                                        });
                                      }
                                    }, // Implement swap submission logic
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset(
                                          "/images/metamask-icon.svg",
                                          width: 24,
                                          height: 24,
                                        ), // Adjust width as needed
                                        SizedBox(
                                            width:
                                                10), // Space between text and image
                                        Text('Send with Metamask'),
                                      ],
                                    ));
                              } else {
                                return const Text("Send the flux manually");
                              }
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Icon(
                        Icons.arrow_downward,
                        size: 50,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: const Color.fromRGBO(237, 237, 237, 1),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Receive',
                                  style: TextStyle(fontSize: 18),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "${provider.toAmount.toString()} ${provider.submittedToCurrency}", // Linked to a controller
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  'to',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(width: 5),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  provider.toAddress,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              controller: transactionIDController,
                              textAlign: TextAlign.left,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                labelText: 'Transaction Id / Hash',
                                labelStyle: TextStyle(color: Colors.blue),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    topRight: Radius.zero,
                                    bottomRight: Radius.zero,
                                  ),
                                ),
                              ),
                              onChanged: (value) => setState(() {}),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Address can`t be blank'
                                      : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (transactionIDController.text.isNotEmpty) {
                            double amount = provider.fromAmount;
                            if (amount != 0) {
                              final swapRequest = SwapRequest(
                                  amountFrom: amount,
                                  addressFrom: provider.fromAddress,
                                  addressTo: provider.toAddress,
                                  chainFrom: getCurrencyApiName(
                                      provider.submittedFromCurrency),
                                  chainTo: getCurrencyApiName(
                                      provider.submittedToCurrency),
                                  txidFrom: transactionIDController.text);
                              createSwapRequest("", swapRequest).then(
                                (value) {
                                  bool success = value[0];
                                  String message = value[1];
                                  SwapResponse response = value[2];
                                  print(success);
                                  print(message);
                                  print(
                                      "Received: ${response.toJson().toString()}");
                                  if (success) {
                                    provider.swapResponse = response;
                                    provider.isSwapCreated = true;
                                    provider.isSwapValid = true;
                                    provider.swapMessage = message;
                                  } else {
                                    provider.swapResponse = response;
                                    provider.isSwapCreated = true;
                                    provider.isSwapValid = false;
                                    provider.swapMessage = message;
                                  }
                                },
                              );
                            }
                          }
                        }, // Implement swap submission logic
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(
                              const Size(double.infinity, 40)),
                        ),
                        child: const Text('Submit Swap'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _copyText(String text) {
    // Implement this method to copy text to clipboard
  }
}
