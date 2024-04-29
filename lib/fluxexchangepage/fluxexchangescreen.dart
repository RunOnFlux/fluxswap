import 'package:flutter/material.dart';
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

class FluxExchangeScreen extends StatefulWidget {
  const FluxExchangeScreen({super.key});

  @override
  _FluxExchangeScreenState createState() => _FluxExchangeScreenState();
}

class _FluxExchangeScreenState extends State<FluxExchangeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController toAmountController = TextEditingController();

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
                                chainFrom: convertCurrencyForAPI(
                                    provider.selectedFromCurrency),
                                chainTo: convertCurrencyForAPI(
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
