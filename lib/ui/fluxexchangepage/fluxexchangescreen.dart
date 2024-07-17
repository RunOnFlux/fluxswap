import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluxswap/api/models/reserve_model.dart';
import 'package:fluxswap/providers/crypto_swap_provider.dart';
import 'package:fluxswap/ui/cryptoswappage/cryptoswapamount.dart';
import 'package:fluxswap/ui/cryptoswappage/exchangebutton.dart';
import 'package:fluxswap/ui/cryptoswappage/rateselector.dart';
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

class FluxExchangeScreen extends StatefulWidget {
  const FluxExchangeScreen({super.key});

  @override
  _FluxExchangeScreenState createState() => _FluxExchangeScreenState();
}

class _FluxExchangeScreenState extends State<FluxExchangeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController toAmountController = TextEditingController();
  PageController _pageController = PageController();
  int selectedIndex = 0;

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
        buildButton('Bridge Flux', 0),
        const SizedBox(width: 10),
        buildButton('Swap Crypto', 1),
        const SizedBox(width: 10),
        buildButton('Search / History', 2),
      ],
    );
  }

  Widget buildButton(String title, int index) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: 40,
      decoration: BoxDecoration(
        color: selectedIndex == index
            ? Colors.white
            : const Color.fromRGBO(151, 151, 151, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextButton(
        onPressed: () {
          setState(() {
            selectedIndex = index;
            int pageDifference = (index - _pageController.page!.toInt()).abs();
            if (pageDifference > 1) {
              _pageController.jumpToPage(index);
            } else {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          });
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 5),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: selectedIndex == index
                ? Colors.black
                : const Color.fromARGB(255, 206, 206, 206),
          ),
        ),
      ),
    );
  }

  Widget mainContent(FluxSwapProvider provider) {
    toAmountController.text = "\u2248 ${provider.toAmount.toString()}";
    return buildFormContainer(provider);
  }

  Widget buildFormContainer(FluxSwapProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black, // Light white border
          width: 1,
        ),
      ),
      child: SizedBox(
        height: 600, // Set a fixed height for the container
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          children: [
            bridgeFluxUI(provider),
            swapCryptoUI(),
            searchhistoryUI(provider),
          ],
        ),
      ),
    );
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
    final cryptoSwapProvider = Provider.of<CryptoSwapProvider>(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;

        return Center(
          child: Padding(
            padding: EdgeInsets.only(
              top: height * 0.025,
              left: width * 0.1,
              right: width * 0.1,
              bottom: height * 0.1,
            ),
            child: Column(
              children: [
                SizedBox(height: 16),
                AssetSelectionWidget(isSellAsset: true),
                SizedBox(height: 16),
                RateSelector(),
                SizedBox(height: 16),
                AssetSelectionWidget(isSellAsset: false),
                SizedBox(height: 16),
                ExchangeButtonWidget(),
              ],
            ),
          ),
        );
      },
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
