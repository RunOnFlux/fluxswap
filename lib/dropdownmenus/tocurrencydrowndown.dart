import 'package:flutter/material.dart';
import 'package:fluxswap/provider/fluxswapprovider.dart';
import 'package:provider/provider.dart';

class ToCurrencyDropdown extends StatefulWidget {
  final TextEditingController toAmountController;
  final GlobalKey<FormState> formKey;

  const ToCurrencyDropdown(
      {super.key, required this.toAmountController, required this.formKey});

  @override
  // ignore: library_private_types_in_public_api
  _CurrencyDropdownState createState() => _CurrencyDropdownState();
}

class _CurrencyDropdownState extends State<ToCurrencyDropdown> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FluxSwapProvider>(context);
    return Expanded(
      flex: 1,
      child: SizedBox(
        width: double.infinity,
        child: DropdownButtonFormField<String>(
          value: provider.selectedToCurrency,
          onChanged: (String? newValue) {
            setState(() {
              provider.selectedToCurrency = newValue ?? "";
              double receivedAmount = provider.updateReceivedAmount();
              widget.toAmountController.text = "\u2248  $receivedAmount";
              widget.formKey.currentState!.validate();
            });
            provider.updateReceivedAmount();
          },
          items: <String?>[
            'FLUX',
            'FLUX-BSC',
            'FLUX-SOL',
            'FLUX-TRX',
            'FLUX-ERG',
            'FLUX-AVAX',
            'FLUX-ALGO',
            'FLUX-MATIC',
            'FLUX-KDA',
            'FLUX-ETH',
          ].map<DropdownMenuItem<String>>((String? value) {
            return DropdownMenuItem<String>(
              value: value ?? '',
              child: Text(
                value ?? '',
                style: const TextStyle(color: Colors.blue),
              ),
            );
          }).toList(),
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.only(
                topLeft: Radius.zero,
                bottomLeft: Radius.zero,
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
          ),
          validator: (value) {
            if (value == null) {
              return 'Please select a currency';
            }
            if (value == provider.selectedFromCurrency) {
              return 'Can\'t be the same';
            }
            return null;
          },
        ),
      ),
    );
  }
}
