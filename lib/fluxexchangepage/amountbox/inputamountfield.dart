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

class OutputAmountField extends StatefulWidget {
  final TextEditingController toAmountController;
  final GlobalKey<FormState> formKey;

  const OutputAmountField({
    super.key,
    required this.toAmountController,
    required this.formKey,
  });

  @override
  _CurrencyOutputFieldState createState() => _CurrencyOutputFieldState();
}

class _CurrencyInputFieldState extends State<InputAmountField> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FluxSwapProvider>(context);
    return TextFormField(
      initialValue: '100',
      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      keyboardType: TextInputType.number, // Keyboard type for numbers
      decoration: const InputDecoration(
        hintText: '0',
        border: InputBorder.none,
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
    );
  }
}

class _CurrencyOutputFieldState extends State<OutputAmountField> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FluxSwapProvider>(context);
    return TextFormField(
      readOnly: true,
      controller: widget.toAmountController,
      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      keyboardType: TextInputType.number, // Keyboard type for numbers
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Error';
        }
        if (provider.toAmount <= 0) {
          return 'Increase Send Amount';
        }
        return null;
      },
    );
  }
}
