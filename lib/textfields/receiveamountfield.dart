import 'package:flutter/material.dart';
import 'package:fluxswap/provider/fluxswapprovider.dart';
import 'package:provider/provider.dart';

class ReceiveAmountField extends StatelessWidget {
  final TextEditingController toAmountController;

  const ReceiveAmountField({super.key, required this.toAmountController});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FluxSwapProvider>(context);
    return Expanded(
      flex: 1,
      child: TextFormField(
        readOnly: true,
        controller: toAmountController,
        textAlign: TextAlign.right,
        style: const TextStyle(fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          labelText: 'You Receive',
          labelStyle: TextStyle(color: Colors.blue),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.zero,
          ),
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
      ),
    );
  }
}
