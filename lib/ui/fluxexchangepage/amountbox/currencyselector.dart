import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluxswap/constants/coin_details.dart';
import 'package:fluxswap/models/coin_info.dart';
import 'package:fluxswap/utils/helpers.dart';
import 'package:fluxswap/providers/flux_swap_provider.dart';
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
          return Coin_Details.values.toList().map((CoinInformation value) {
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

              if (provider.isConnected) {
                provider.previousSelectedChain = provider.selectedChain;
                provider.selectedChain = getNetworkName(
                    Coin_Details[provider.selectedFromCurrency]!.chainId);
                provider.requestChangeChainMetamask();
              }
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
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                '${Coin_Details[widget.isFrom ? provider.selectedFromCurrency : provider.selectedToCurrency]?.imageName}',
                width: 30,
                height: 30,
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
