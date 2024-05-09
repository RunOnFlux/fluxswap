import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluxswap/api/requests.dart';
import 'package:fluxswap/changenotifier.dart';
import 'package:fluxswap/fluxexchangepage/addressbox/addresstextformfield.dart';
import 'package:fluxswap/fluxexchangepage/amountbox/amountcontainerbox.dart';
import 'package:fluxswap/fluxexchangepage/buttons/reseverswapbutton.dart';
import 'package:fluxswap/fluxexchangepage/searchswap.dart';
import 'package:fluxswap/fluxexchangepage/sendflux.dart';
import 'package:fluxswap/fluxexchangepage/statusindicator.dart';
import 'package:fluxswap/fluxexchangepage/swaphistory.dart';
import 'package:fluxswap/fluxexchangepage/swapinfo.dart';
import 'package:fluxswap/fluxexchangepage/zelidbox/zelidfield.dart';
import 'package:fluxswap/fluxswapstats/totalswaps.dart';
import 'package:fluxswap/helper/modals.dart';

class FluxExchangeScreen extends StatefulWidget {
  const FluxExchangeScreen({super.key});

  @override
  _FluxExchangeScreenState createState() => _FluxExchangeScreenState();
}

class _FluxExchangeScreenState extends State<FluxExchangeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController toAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FluxSwapProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Container(
          width: 825,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              const Text('Flux Exchange', style: TextStyle(fontSize: 60)),
              const StatusIndicator(),
              const SizedBox(height: 20),
              const Text('Swap Flux between networks with ease',
                  style: TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              const TotalSwapsDisplay(),
              const SizedBox(height: 10),
              mainContent(provider),
            ],
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 300),
            const SearchSwap(),
            const SizedBox(height: 10),
            Container(
              width: 300,
              height: 550,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(237, 237, 237, 1),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: const SwapHistoryList(),
            ),
          ],
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
      ],
    );
  }

  Widget mainContent(FluxSwapProvider provider) {
    toAmountController.text = "\u2248 ${provider.toAmount.toString()}";
    if (provider.fShowSwapCard) {
      return const SwapInfoCard();
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
      return formUI(provider); // Refactored form UI to a method for clarity
    }
  }

  Widget formUI(FluxSwapProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ZelIDBox(formKey: _formKey),
            // FluxIdTextFormField(
            //     labelText: 'Flux ID / Zel ID', formKey: _formKey),
            const SizedBox(height: 20),
            Row(
              children: [
                // AddressTextFormField(
                //   labelText: "From Address",
                //   formKey: _formKey,
                //   isFrom: true,
                // ),
                const SizedBox(width: 2),
                AmountContainer(
                    formKey: _formKey,
                    toAmountController: toAmountController,
                    isFrom: true),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                AddressTextFormField(
                  labelText: "To Address",
                  formKey: _formKey,
                  isFrom: false,
                ),
                const SizedBox(width: 2),
                AmountContainer(
                    formKey: _formKey,
                    toAmountController: toAmountController,
                    isFrom: false),
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
