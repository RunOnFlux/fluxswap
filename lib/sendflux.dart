import 'package:flutter/material.dart';
import 'package:fluxswap/fees/fees.dart';
import 'package:fluxswap/helper/modals.dart';
import 'package:provider/provider.dart';
import 'provider/fluxswapprovider.dart';
import 'fees/fees.dart';
import 'api/requests.dart';

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
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white54, width: 1),
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 15,
      shadowColor: Colors.black,
      color: const Color.fromARGB(255, 10, 17, 32),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: 900,
            height: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Text(
                    'Send the ${provider.selectedFromCurrency}',
                    style: const TextStyle(fontSize: 24, color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Send'),
                          const SizedBox(width: 5),
                          Text(
                            provider.fromAmount
                                .toString(), // Linked to a controller
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 5),
                          Text('${provider.selectedFromCurrency} to'),
                          const SizedBox(width: 5),
                          Text(
                            getSwapAddress(provider.swapInfoResponse,
                                provider.selectedFromCurrency),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () => _copyText(
                              getSwapAddress(provider.swapInfoResponse,
                                  provider.selectedFromCurrency),
                            ),
                            icon: const Icon(Icons.content_copy_rounded),
                            color: Colors.white60,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Receive'),
                          const SizedBox(width: 5),
                          Text(
                            provider.toAmount
                                .toString(), // Linked to a controller
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 5),
                          Text('${provider.selectedToCurrency} to'),
                          const SizedBox(width: 5),
                          Text(
                            provider
                                .toAddress, // Assuming direct input for receiving address
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () => _copyText(getSwapAddress(
                                provider.swapInfoResponse,
                                provider.selectedFromCurrency)),
                            icon: const Icon(Icons.content_copy_rounded),
                            color: Colors.white60,
                          ),
                        ],
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
                          double amount = provider.fromAmount ?? 0;
                          if (amount != 0) {
                            provider
                                .sendToken(
                                    56,
                                    provider.fromAddress,
                                    getSwapAddress(provider.swapInfoResponse,
                                        provider.selectedFromCurrency),
                                    BigInt.from(amount))
                                .then((value) =>
                                    transactionIDController.text = value);
                          }
                        }, // Implement swap submission logic
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(
                              const Size(double.infinity, 40)),
                        ),
                        child: const Text('Send with Metamask?'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (transactionIDController.text.isNotEmpty) {
                            double amount = provider.fromAmount;
                            if (amount != 0) {
                              final swapRequest = SwapRequest(
                                  amountFrom: amount,
                                  addressFrom: provider.fromAddress,
                                  addressTo: provider.toAddress,
                                  chainFrom: convertCurrencyForAPI(
                                      provider.selectedFromCurrency),
                                  chainTo: convertCurrencyForAPI(
                                      provider.selectedToCurrency),
                                  txidFrom: transactionIDController.text);
                              createSwapRequest("", swapRequest).then(
                                (value) {
                                  bool success = value[0];
                                  String message = value[1];
                                  print(success);
                                  print(message);
                                  if (success) {
                                    provider.isSwapCreated = true;
                                    provider.isSwapValid = true;
                                    provider.swapMessage = message;
                                  } else {
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
