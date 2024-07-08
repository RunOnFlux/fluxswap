import 'package:flutter/material.dart';
import 'package:fluxswap/api/models/reserve_model.dart';
import 'package:provider/provider.dart';
import 'package:fluxswap/providers/flux_swap_provider.dart';
import 'package:fluxswap/ui/fluxexchangepage/addressbox/addresstextformfield.dart';
import 'package:fluxswap/ui/fluxexchangepage/amountbox/amountcontainerbox.dart';
import 'package:fluxswap/ui/fluxexchangepage/buttons/reseverswapbutton.dart';
import 'package:fluxswap/ui/fluxexchangepage/sendflux.dart';
import 'package:fluxswap/ui/fluxexchangepage/statusindicator.dart';
import 'package:fluxswap/ui/fluxexchangepage/swapinfo.dart';
import 'package:fluxswap/ui/fluxexchangepage/zelidbox/zelidfield.dart';
import 'package:fluxswap/ui/fluxswapstats/totalswaps.dart';
import 'package:fluxswap/utils/helpers.dart';

import 'searchswap.dart';

class FluxExchangeScreen extends StatefulWidget {
  const FluxExchangeScreen({super.key});

  @override
  _FluxExchangeScreenState createState() => _FluxExchangeScreenState();
}

class _FluxExchangeScreenState extends State<FluxExchangeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController toAmountController = TextEditingController();
  bool isBridgeFlux = true;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FluxSwapProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Container(),
        ),
        SizedBox(
          width: 825,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              const Text('Flux Exchange (Internal Only)',
                  style: TextStyle(fontSize: 60, color: Colors.white)),
              const StatusIndicator(),
              const SizedBox(height: 20),
              const Text('Swap Flux between networks with ease',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              const SizedBox(height: 20),
              const TotalSwapsDisplay(),
              const SizedBox(height: 10),
              mainContent(provider),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
      ],
    );
  }

  Widget mainContent(FluxSwapProvider provider) {
    toAmountController.text = "\u2248 ${provider.toAmount.toString()}";
    return buildFormContainer(provider);
  }

  Widget buildFormContainer(FluxSwapProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black, // Light white border
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 60, // Increase height here
                  decoration: BoxDecoration(
                    color: isBridgeFlux
                        ? Colors.transparent
                        : Color.fromRGBO(151, 151, 151, 1),
                    borderRadius: const BorderRadius.only(
                      topLeft:
                          Radius.circular(10), // Radius for the top left corner
                    ),
                    border: isBridgeFlux
                        ? null
                        : const Border(
                            bottom: BorderSide(
                              color:
                                  Colors.black, // Black border if not selected
                              width: 1,
                            ),
                          ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        isBridgeFlux = true;
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors
                          .transparent, // Background already handled by Container
                      padding: EdgeInsets.symmetric(
                          vertical: 20), // Increase padding for larger button
                    ),
                    child: Text(
                      'Bridge Flux',
                      style: TextStyle(
                        fontSize: 18, // Increase font size
                        color: isBridgeFlux
                            ? Colors.black
                            : Color.fromARGB(255, 206, 206, 206),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 60, // Increase height here
                  decoration: BoxDecoration(
                    color: !isBridgeFlux
                        ? Colors.transparent
                        : Color.fromRGBO(151, 151, 151, 1),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(
                          10), // Radius for the top right corner
                    ),
                    border: !isBridgeFlux
                        ? null
                        : const Border(
                            bottom: BorderSide(
                              color:
                                  Colors.black, // Black border if not selected
                              width: 1,
                            ),
                          ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        isBridgeFlux = false;
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors
                          .transparent, // Background already handled by Container
                      padding: EdgeInsets.symmetric(
                          vertical: 20), // Increase padding for larger button
                    ),
                    child: Text(
                      'Swap Crypto',
                      style: TextStyle(
                        fontSize: 18, // Increase font size
                        color: !isBridgeFlux
                            ? Colors.black
                            : Color.fromARGB(255, 206, 206, 206),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          isBridgeFlux ? bridgeFluxUI(provider) : swapCryptoUI(),
        ],
      ),
    );
  }

  Widget bridgeFluxUI(FluxSwapProvider provider) {
    if (provider.fShowSwapCard) {
      return const SwapInfoCard();
    } else if (provider.isReservedApproved && !provider.isReservedValid) {
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
    } else if (provider.isReservedApproved && !provider.isSwapCreated) {
      return const SwapCard();
    } else {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              ZelIDBox(formKey: _formKey),
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(width: 2),
                  AmountContainer(
                      formKey: _formKey,
                      toAmountController: toAmountController,
                      isFrom: true),
                  const SizedBox(width: 10),
                  AmountContainer(
                      formKey: _formKey,
                      toAmountController: toAmountController,
                      isFrom: false)
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  AddressTextFormField(
                    selectedCurrency: provider.selectedToCurrency,
                    labelText: "Receiving Address",
                    formKey: _formKey,
                    isFrom: false,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 40,
                child: ReserveSwapButton(
                  zelid: provider.fluxID,
                  reserveRequest: ReserveRequest(
                      addressFrom: provider.currentAddress,
                      addressTo: provider.toAddress,
                      chainFrom:
                          getCurrencyApiName(provider.selectedFromCurrency),
                      chainTo: getCurrencyApiName(provider.selectedToCurrency)),
                  formKey: _formKey,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget swapCryptoUI() {
    // Placeholder for Swap Crypto UI
    return Center(
      child: Text(
        'Swap Crypto UI will be implemented later.',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
