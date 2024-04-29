import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluxswap/helper/modals.dart';
import 'package:fluxswap/provider/fluxswapprovider.dart';
import 'package:provider/provider.dart';

class FromCurrencyDropdown extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController toAmountController;
  final bool isFrom;

  const FromCurrencyDropdown(
      {super.key,
      required this.formKey,
      required this.toAmountController,
      required this.isFrom});

  @override
  // ignore: library_private_types_in_public_api
  _CurrencyDropdownState createState() => _CurrencyDropdownState();
}

class _CurrencyDropdownState extends State<FromCurrencyDropdown> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FluxSwapProvider>(context);
    return Container(
      alignment: Alignment.center,
      width: 175,
      child: PopupMenuButton<String>(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        offset: const Offset(0, 50),
        itemBuilder: (BuildContext context) {
          return coinInfo.values.toList().map((CoinInfo value) {
            bool isSelected = value.swapingName ==
                (widget.isFrom
                    ? provider.selectedFromCurrency
                    : provider.selectedToCurrency);
            bool isSelectable = value.swapingName !=
                (widget.isFrom
                    ? provider.selectedToCurrency
                    : provider.selectedFromCurrency);
            return PopupMenuItem<String>(
              value: value.swapingName,
              enabled: isSelectable,
              child: Row(
                children: [
                  SvgPicture.asset(
                    value.imageName,
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(
                      width: 10), // Add spacing between icon and text
                  Text(value.swapingName),
                  const SizedBox(width: 40),
                  if (isSelected)
                    const Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                ],
              ),
            );
          }).toList();
        },
        onSelected: (String newValue) {
          setState(() {
            if (widget.isFrom) {
              provider.selectedFromCurrency = newValue;
            } else {
              provider.selectedToCurrency = newValue;
              double receivedAmount = provider.updateReceivedAmount();
              widget.toAmountController.text = "\u2248  $receivedAmount";
              widget.formKey.currentState!.validate();
              provider.updateReceivedAmount();
            }
            widget.formKey.currentState?.validate();
          });
        },
        child: Container(
          margin: const EdgeInsets.fromLTRB(2.0, 0, 0, 0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                '${coinInfo[widget.isFrom ? getSecondPart(provider.selectedFromCurrency) : getSecondPart(provider.selectedToCurrency)]?.imageName}',
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 10), // Add spacing between icon and text
              Text(widget.isFrom
                  ? provider.selectedFromCurrency
                  : provider.selectedToCurrency),
              const Icon(Icons.arrow_drop_down), // Dropdown symbol
            ],
          ),
        ),
      ),
    );
  }
}
