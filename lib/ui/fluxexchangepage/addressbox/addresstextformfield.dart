import 'package:flutter/material.dart';
import 'package:fluxswap/changenotifier.dart';
import 'package:fluxswap/utils/addressvalidator.dart';
import 'package:fluxswap/utils/modals.dart';
import 'package:provider/provider.dart';

class AddressTextFormField extends StatelessWidget {
  final String labelText;
  final GlobalKey<FormState> formKey;
  final bool isFrom;

  const AddressTextFormField({
    super.key,
    required this.labelText,
    required this.formKey,
    required this.isFrom,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FluxSwapProvider>(context);
    return Expanded(
        flex: 1,
        child: Container(
            padding: const EdgeInsets.all(10),
            height: 125,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: const Color.fromRGBO(237, 237, 237, 1),
            ), // Overall padding around the entire container
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(labelText, style: const TextStyle(fontSize: 14)), // Label
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          keyboardType:
                              TextInputType.text, // Keyboard type for numbers
                          decoration: const InputDecoration(
                            hintText: '0x',
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            if (isFrom) {
                              provider.fromAddress = value;
                            } else {
                              provider.toAddress = value;
                            }
                            // Trigger the form validation on change if needed
                            formKey.currentState?.validate();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Address can\'t be blank'; // Customize this message based on the field if needed
                            }
                            String currency = isFrom
                                ? provider.selectedFromCurrency
                                : provider.selectedToCurrency;
                            NETWORKS network =
                                getNetworkFromSelectedCoin(currency);
                            if (!isValidAddress(value, network)) {
                              return "Not Valid ${currency} address";
                            }

                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
