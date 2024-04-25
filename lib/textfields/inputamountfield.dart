import 'package:flutter/material.dart';
import 'package:fluxswap/provider/fluxswapprovider.dart';
import 'package:provider/provider.dart';

class InputAmountField extends StatefulWidget {
  final TextEditingController toAmountController;
  final GlobalKey<FormState> formKey;

  const InputAmountField({
    Key? key,
    required this.toAmountController,
    required this.formKey,
  }) : super(key: key);

  @override
  _CurrencyInputFieldState createState() => _CurrencyInputFieldState();
}

class _CurrencyInputFieldState extends State<InputAmountField> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FluxSwapProvider>(context);
    return Expanded(
      flex: 1,
      child: TextFormField(
        initialValue: '0',
        textAlign: TextAlign.right,
        style: const TextStyle(fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          labelText: 'You Send',
          labelStyle: TextStyle(color: Colors.blue),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.zero,
          ),
        ),
        onChanged: (value) {
          setState(() {
            // Assume provider is available in the widget's scope
            double? parsedValue = double.tryParse(value);
            provider.fromAmount = parsedValue ?? 0;
            double receivedAmount = provider.updateReceivedAmount();
            widget.toAmountController.text = "\u2248  $receivedAmount";
            widget.formKey.currentState?.validate();
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter an amount';
          }
          final double? amount = double.tryParse(value);
          if (amount == null) {
            return 'Numbers Only';
          }
          if (amount < 1) {
            return 'Minimum: 1';
          }
          if (amount > 100000) {
            return 'Max: 100000';
          }
          return null;
        },
      ),
    );
  }
}
