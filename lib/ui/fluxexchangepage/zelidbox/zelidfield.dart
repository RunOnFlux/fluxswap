import 'package:flutter/material.dart';
import 'package:fluxswap/changenotifier.dart';
import 'package:fluxswap/utils/addressvalidator.dart';
import 'package:provider/provider.dart';

class ZelIDBox extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const ZelIDBox({super.key, required this.formKey});

  @override
  _ZelIDBoxState createState() => _ZelIDBoxState();
}

class _ZelIDBoxState extends State<ZelIDBox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FluxSwapProvider>(context);
    return Container(
      padding: const EdgeInsets.all(10),
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: const Color.fromRGBO(237, 237, 237, 1),
      ), // Overall padding around the entire container
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              return provider.recentUsedZelIds.where((zelId) {
                return zelId
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (String value) {
              setState(() {
                provider.fluxID = value;
              });
            },
            fieldViewBuilder: (BuildContext context,
                TextEditingController textEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted) {
              return TextFormField(
                controller: textEditingController,
                decoration: const InputDecoration(
                  labelText: 'Enter Flux / Zel ID',
                ),
                focusNode: focusNode,
                onChanged: (value) {
                  setState(() {
                    provider.fluxID = value;
                    widget.formKey.currentState?.validate();
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ID can\'t be blank'; // Customize this message based on the field if needed
                  }
                  if (!isValidBitcoinAddress(value) &&
                      !isValidEthereumAddress(value)) {
                    return "Flux ID can be a BTC address or a 0x address";
                  }
                  return null;
                },
              );
            },
            optionsViewBuilder: (BuildContext context,
                AutocompleteOnSelected<String> onSelected,
                Iterable<String> options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4.0,
                  child: Container(
                    height: 200.0,
                    width: 700,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(237, 237, 237, 1),
                    ),
                    child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final option = options.elementAt(index);
                        return ListTile(
                          title: Text(option),
                          onTap: () {
                            onSelected(option);
                            widget.formKey.currentState?.validate();
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
