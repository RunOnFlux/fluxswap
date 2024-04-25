import 'package:flutter/material.dart';
import 'package:fluxswap/provider/fluxswapprovider.dart';
import 'package:provider/provider.dart';

class AddressTextFormField extends StatelessWidget {
  final String labelText;
  final GlobalKey<FormState> formKey;

  const AddressTextFormField({
    Key? key,
    required this.labelText,
    required this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FluxSwapProvider>(context);
    return Expanded(
        flex: 3,
        child: TextFormField(
          initialValue: '',
          textAlign: TextAlign.left,
          style: const TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(color: Colors.blue),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                topRight: Radius.zero,
                bottomRight: Radius.zero,
              ),
            ),
          ),
          onChanged: (value) {
            if (labelText == "From Address") {
              provider.fromAddress = value;
            } else if (labelText == "To Address") {
              provider.toAddress = value;
            }
            // Trigger the form validation on change if needed
            formKey.currentState?.validate();
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Address can\'t be blank'; // Customize this message based on the field if needed
            }
            return null;
          },
        ));
  }
}
