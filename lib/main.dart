import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:fluxswap/dropdownmenus/fromcurrencydropdown.dart';
import 'package:fluxswap/dropdownmenus/tocurrencydrowndown.dart';
import 'package:fluxswap/textfields/addresstextformfield.dart';
import 'package:fluxswap/textfields/inputamountfield.dart';
import 'package:fluxswap/textfields/receiveamountfield.dart';
import 'package:fluxswap/api/requests.dart';
import 'package:fluxswap/sendflux.dart';

import 'provider/fluxswapprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clipboard/clipboard.dart';
import 'buttons/reseverswapbutton.dart';
import 'stats/swapstatsscreen.dart';
import 'stats/totalswaps.dart';
import 'helper/modals.dart';
import 'metamask/metamaskcard.dart';
import 'fees/fees.dart';

void main() {
  runApp(const CryptoSwapApp());
}

class CryptoSwapApp extends StatelessWidget {
  const CryptoSwapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Swap Demo',
      theme: ThemeData.dark(),
      home: const CryptoSwapPage(),
    );
  }
}

class CryptoSwapPage extends StatefulWidget {
  const CryptoSwapPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CryptoSwapPageState createState() => _CryptoSwapPageState();
}

class _CryptoSwapPageState extends State<CryptoSwapPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController toAmountController = TextEditingController(text: "0");

  TextEditingController transactionIDController =
      TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FluxSwapProvider()..init(),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF1b202b),
          body: Stack(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Image.asset(
                  'assets/images/zel-flux-logo.png',
                  width: 100,
                  height: 75,
                ),
              ),
              const MetaMaskCard(),
              Column(
                children: [
                  const SizedBox(height: 100),
                  const Text(
                    'Flux Exchange',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                    ),
                  ),
                  const Text(
                    'Swap Flux between networks with ease',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TotalSwapsDisplay(),
                  const SizedBox(height: 40),
                  Center(
                    child: Consumer<FluxSwapProvider>(
                      builder: (context, provider, child) {
                        if (provider.isReservedApproved &&
                            !provider.isReservedValid) {
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
                            message = 'You swap was successful';
                          }
                          return AlertDialog(
                            title: const Text('Swap Information'),
                            content: Text(message),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    provider.isReservedApproved = false;
                                    provider.isReservedValid = false;
                                    provider.isSwapCreated = false;
                                    provider.isSwapValid = false;
                                    provider.toAddress = '';
                                    provider.fromAddress = '';
                                  });
                                },
                                child: const Text('Okay'),
                              ),
                            ],
                          );
                        }
                        return Card(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Colors.white54,
                              width: 1,
                            ),
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.all(50.0),
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            decoration: InputDecoration(
                                              labelText:
                                                  'Flux ID / Zel ID (Optional)',
                                              labelStyle: const TextStyle(
                                                  color: Colors.blue),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              suffixIcon: const Tooltip(
                                                message:
                                                    'This is used to track swap history. If you want to be able to view the history of swap, you must input your Flux / Zel ID',
                                                child: Icon(Icons.info_outline),
                                              ),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                provider.fluxID = value;
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            children: [
                                              AddressTextFormField(
                                                  labelText: "From Address",
                                                  formKey: _formKey),
                                              const SizedBox(width: 2),
                                              InputAmountField(
                                                  toAmountController:
                                                      toAmountController,
                                                  formKey: _formKey),
                                              const SizedBox(width: 2),
                                              FromCurrencyDropdown(
                                                  formKey: _formKey),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            children: [
                                              AddressTextFormField(
                                                  labelText: "To Address",
                                                  formKey: _formKey),
                                              const SizedBox(width: 2),
                                              ReceiveAmountField(
                                                  toAmountController:
                                                      toAmountController),
                                              const SizedBox(width: 2),
                                              ToCurrencyDropdown(
                                                  toAmountController:
                                                      toAmountController,
                                                  formKey: _formKey),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          SizedBox(
                                            height: 40,
                                            child: ReserveSwapButton(
                                              zelid: provider.fluxID,
                                              reserveRequest: ReserveRequest(
                                                  addressFrom:
                                                      provider.fromAddress,
                                                  addressTo: provider.toAddress,
                                                  chainFrom: convertCurrencyForAPI(
                                                      provider
                                                          .selectedFromCurrency),
                                                  chainTo: convertCurrencyForAPI(
                                                      provider
                                                          .selectedToCurrency)),
                                              formKey: _formKey,
                                            ),
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
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void _showSnackbar() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Text Copied")));
  }

  void _copytext(String copytext) {
    FlutterClipboard.copy(copytext).then((value) => _showSnackbar());
  }
}
