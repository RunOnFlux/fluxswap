import 'package:flutter/material.dart';
import 'package:fluxswap/api/swapinfo.dart';
import 'package:fluxswap/api/requests.dart';
import 'package:fluxswap/helper/modals.dart';
import 'package:provider/provider.dart';
import 'package:fluxswap/provider/fluxswapprovider.dart';

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
                                  "${provider.fromAmount.toString()} ${provider.selectedFromCurrency}", // Linked to a controller
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
                                      provider.selectedFromCurrency),
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  onPressed: () => _copyText(
                                    getSwapAddress(provider.swapInfoResponse,
                                        provider.selectedFromCurrency),
                                  ),
                                  icon: const Icon(Icons.content_copy_rounded),
                                ),
                              ],
                            ),
                          ],
                        ),
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
                                  "${provider.toAmount.toString()} ${provider.selectedToCurrency}", // Linked to a controller
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
