import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluxswap/api/models/reserve_model.dart';
import 'package:fluxswap/ui/fluxexchangepage/swaphistory.dart';
import 'package:provider/provider.dart';
import 'package:fluxswap/providers/flux_swap_provider.dart';
import 'package:fluxswap/ui/fluxexchangepage/addressbox/addresstextformfield.dart';
import 'package:fluxswap/ui/fluxexchangepage/amountbox/amountcontainerbox.dart';
import 'package:fluxswap/ui/fluxexchangepage/buttons/reseverswapbutton.dart';
import 'package:fluxswap/ui/fluxexchangepage/sendflux.dart';
import 'package:fluxswap/ui/fluxexchangepage/statusindicator.dart';
import 'package:fluxswap/ui/fluxexchangepage/swapinfo.dart';
import 'package:fluxswap/ui/fluxexchangepage/zelidbox/zelidfield.dart';
import 'package:fluxswap/ui/fluxswapstats/totalswaps.dart';
import 'package:fluxswap/utils/helpers.dart';

import 'searchswap.dart';

enum SelectedButton { bridgeFlux, swapCrypto, search }

class FluxExchangeScreen extends StatefulWidget {
  const FluxExchangeScreen({super.key});

  @override
  _FluxExchangeScreenState createState() => _FluxExchangeScreenState();
}

class _FluxExchangeScreenState extends State<FluxExchangeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController toAmountController = TextEditingController();
  SelectedButton selectedButton = SelectedButton.bridgeFlux;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FluxSwapProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: screenWidth < 600 ? 10 : 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                const Text('Flux Exchange (Internal Only)',
                    style: TextStyle(fontSize: 60, color: Colors.white)),
                const StatusIndicator(),
                const SizedBox(height: 20),
                const Text('Swap Flux between networks with ease',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
                const SizedBox(height: 20),
                const TotalSwapsDisplay(),
                const SizedBox(height: 10),
                buildButtons(),
                const SizedBox(height: 10),
                mainContent(provider),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          height: 40,
          decoration: BoxDecoration(
            color: selectedButton == SelectedButton.bridgeFlux
                ? Colors.white
                : Color.fromRGBO(151, 151, 151, 1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextButton(
            onPressed: () {
              setState(() {
                selectedButton = SelectedButton.bridgeFlux;
              });
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            child: Text(
              'Bridge Flux',
              style: TextStyle(
                fontSize: 18,
                color: selectedButton == SelectedButton.bridgeFlux
                    ? Colors.black
                    : Color.fromARGB(255, 206, 206, 206),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.all(5),
          height: 40,
          decoration: BoxDecoration(
            color: selectedButton == SelectedButton.swapCrypto
                ? Colors.white
                : Color.fromRGBO(151, 151, 151, 1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextButton(
            onPressed: () {
              setState(() {
                selectedButton = SelectedButton.swapCrypto;
              });
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            child: Text(
              'Swap Crypto',
              style: TextStyle(
                fontSize: 18,
                color: selectedButton == SelectedButton.swapCrypto
                    ? Colors.black
                    : Color.fromARGB(255, 206, 206, 206),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.all(5),
          height: 40,
          decoration: BoxDecoration(
            color: selectedButton == SelectedButton.search
                ? Colors.white
                : Color.fromRGBO(151, 151, 151, 1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextButton(
            onPressed: () {
              setState(() {
                selectedButton = SelectedButton.search;
              });
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            child: Text(
              'Search / History',
              style: TextStyle(
                fontSize: 18,
                color: selectedButton == SelectedButton.search
                    ? Colors.black
                    : Color.fromARGB(255, 206, 206, 206),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget mainContent(FluxSwapProvider provider) {
    toAmountController.text = "\u2248 ${provider.toAmount.toString()}";
    return buildFormContainer(provider);
  }

  Widget buildFormContainer(FluxSwapProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black, // Light white border
          width: 1,
        ),
      ),
      child: Column(
        children: [
          getSelectedUI(provider),
        ],
      ),
    );
  }

  Widget getSelectedUI(FluxSwapProvider provider) {
    switch (selectedButton) {
      case SelectedButton.bridgeFlux:
        return bridgeFluxUI(provider);
      case SelectedButton.swapCrypto:
        return swapCryptoUI();
      case SelectedButton.search:
        return searchhistoryUI(provider);
      default:
        return bridgeFluxUI(provider);
    }
  }

  Widget bridgeFluxUI(FluxSwapProvider provider) {
    if (provider.fShowSwapCard) {
      return SwapInfoCard(
        swapResponse: provider.swapToDisplay,
        fSearch: false,
      );
    } else if (provider.isReservedApproved && !provider.isReservedValid) {
      return AlertDialog(
        title: const Text('Reserve Failed to process'),
        content: Text(
            'Please fix the errors and try again: \n\n Error: ${provider.reservedMessage}'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              setState(() {
                provider.isReservedApproved = false;
                provider.isReservedValid = false;
              });
            },
            child: const Text('Okay'),
          ),
        ],
      );
    } else if (provider.isReservedApproved && !provider.isSwapCreated) {
      return const SwapCard();
    } else {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              ZelIDBox(formKey: _formKey),
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(width: 2),
                  AmountContainer(
                      formKey: _formKey,
                      toAmountController: toAmountController,
                      isFrom: true),
                  const SizedBox(width: 10),
                  AmountContainer(
                      formKey: _formKey,
                      toAmountController: toAmountController,
                      isFrom: false)
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  AddressTextFormField(
                    selectedCurrency: provider.selectedToCurrency,
                    labelText: "Receiving Address",
                    formKey: _formKey,
                    isFrom: false,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 40,
                child: ReserveSwapButton(
                  zelid: provider.fluxID,
                  reserveRequest: ReserveRequest(
                      addressFrom: provider.currentAddress,
                      addressTo: provider.toAddress,
                      chainFrom:
                          getCurrencyApiName(provider.selectedFromCurrency),
                      chainTo: getCurrencyApiName(provider.selectedToCurrency)),
                  formKey: _formKey,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget swapCryptoUI() {
    // Placeholder for Swap Crypto UI
    return Center(
      child: Text(
        'Swap Crypto UI will be implemented later.',
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget searchhistoryUI(FluxSwapProvider provider) {
    return Container(
      height: 550,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(237, 237, 237, 1),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: const SearchHistory(),
    );
  }
}
