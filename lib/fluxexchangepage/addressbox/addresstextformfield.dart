import 'package:flutter/material.dart';
import 'package:fluxswap/provider/fluxswapprovider.dart';
import 'package:provider/provider.dart';

class AddressTextFormField extends StatelessWidget {
  final String labelText;
  final GlobalKey<FormState> formKey;

  const AddressTextFormField({
    super.key,
    required this.labelText,
    required this.formKey,
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
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
