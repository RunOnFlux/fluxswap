import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluxswap/api/models/swap_model.dart';
import 'package:fluxswap/api/services/swap_service.dart';
import 'package:fluxswap/utils/helpers.dart';
import 'package:provider/provider.dart';
import 'package:fluxswap/providers/flux_swap_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SwapCard extends StatefulWidget {
  const SwapCard({super.key});

  @override
  _SwapCardState createState() => _SwapCardState();
}

class _SwapCardState extends State<SwapCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController transactionIDController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FluxSwapProvider>(context);
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: SizedBox(
          width: 900,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildSwapInfo(provider),
              const SizedBox(height: 10),
              _buildTransactionInput(),
              const SizedBox(height: 20),
              _buildSubmitButton(provider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwapInfo(FluxSwapProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: const Color.fromRGBO(237, 237, 237, 1),
        ),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning,
                  color: Colors.orange,
                  size: 24,
                ),
                SizedBox(width: 8), // Space between the icon and the text
                Expanded(
                  child: Text(
                    'Reminder: If sending manually, you must submit the transaction hash',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Send', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 5),
                Text(
                  "${provider.fromAmount} ${provider.submittedFromCurrency}",
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 5),
                const Text('to', style: TextStyle(fontSize: 22)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  SwapService.getSwapAddress(provider.swapInfoResponse,
                      provider.submittedFromCurrency),
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => _copyText(SwapService.getSwapAddress(
                      provider.swapInfoResponse,
                      provider.submittedFromCurrency)),
                  icon: const Icon(Icons.content_copy_rounded),
                ),
              ],
            ),
            _buildWalletButtons(provider),
            const SizedBox(height: 10),
            const Icon(Icons.arrow_downward, size: 35, color: Colors.green),
            _buildReceiveInfo(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiveInfo(FluxSwapProvider provider) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: const Color.fromRGBO(237, 237, 237, 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Receive', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 5),
              Text(
                "${provider.toAmount} ${provider.submittedToCurrency}",
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 5),
              const Text('to', style: TextStyle(fontSize: 22)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                provider.toAddress,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWalletButtons(FluxSwapProvider provider) {
    bool showWalletButton = provider.isConnectedChainSendable();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showWalletButton)
          ElevatedButton(
            onPressed: () => _handleSendToken(provider),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset("assets/images/metamask-icon.svg",
                    width: 24, height: 24),
                const SizedBox(width: 10),
                const Text('Send with Metamask'),
              ],
            ),
          ),
        ElevatedButton(
          onPressed: () => _showQRPopup(provider),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                IconData(0xe4f7, fontFamily: 'MaterialIcons'),
                size: 24,
              ),
              SizedBox(width: 10),
              Text('View QR Code(s)'),
            ],
          ),
        ),
      ],
    );
  }

  void _showQRPopup(FluxSwapProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Scan with Zelcore", style: TextStyle(fontSize: 10)),
              SizedBox(
                width: 150,
                height: 150,
                child: QrImageView(
                  data: provider.getQRData(),
                  version: QrVersions.auto,
                  size: 150.0,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTransactionInput() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: const Color.fromRGBO(237, 237, 237, 1),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: transactionIDController,
              textAlign: TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                labelText: 'Provide the transaction hash',
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Transaction can’t be blank'
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(FluxSwapProvider provider) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: () => _handleSubmit(provider),
        style: ButtonStyle(
          minimumSize:
              MaterialStateProperty.all(const Size(double.infinity, 40)),
          backgroundColor:
              MaterialStateProperty.all(const Color.fromARGB(255, 29, 26, 239)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(4),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(4),
              ),
            ),
          ),
        ),
        child: const Text('Submit Swap',
            style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }

  void _handleSendToken(FluxSwapProvider provider) {
    String error = provider.verifyProviderData();
    if (error.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Data error'),
            content: Text(error),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    } else {
      provider
          .sendToken(
              provider.currentChain,
              SwapService.getSwapAddress(
                  provider.swapInfoResponse, provider.submittedFromCurrency),
              BigInt.from(provider.fromAmount))
          .then((value) {
        if (value.fSuccessful) {
          provider.swapTxid = value.hash;
          final swapRequest = SwapRequest(
            amountFrom: provider.fromAmount,
            addressFrom: provider.currentAddress,
            addressTo: provider.toAddress,
            chainFrom: getCurrencyApiName(provider.submittedFromCurrency),
            chainTo: getCurrencyApiName(provider.submittedToCurrency),
            txidFrom: value.hash,
          );
          SwapService.createSwapRequest(provider.fluxID, swapRequest)
              .then((result) {
            bool success = result[0];
            String message = result[1];
            SwapResponse response = result[2];
            print(success);
            print(message);
            print("Received: ${response.toJson()}");
            provider.swapResponse = response;
            if (success) {
              provider.swapToDisplay = response;
              provider.fShowSwapCard = true;
              provider.clearData();
            } else {
              provider.isSwapCreated = true;
              provider.isSwapValid = false;
              provider.swapMessage = message;
            }
          });
        }
      });
    }
  }

  void _handleSubmit(FluxSwapProvider provider) {
    if (transactionIDController.text.isNotEmpty) {
      double amount = provider.fromAmount;
      if (amount != 0) {
        final swapRequest = SwapRequest(
          amountFrom: amount,
          addressFrom: provider.currentAddress,
          addressTo: provider.toAddress,
          chainFrom: getCurrencyApiName(provider.submittedFromCurrency),
          chainTo: getCurrencyApiName(provider.submittedToCurrency),
          txidFrom: transactionIDController.text,
        );
        SwapService.createSwapRequest("", swapRequest).then((result) {
          bool success = result[0];
          String message = result[1];
          SwapResponse response = result[2];
          print(success);
          print(message);
          print("Received: ${response.toJson()}");
          if (success) {
            provider.swapToDisplay = response;
            provider.fShowSwapCard = true;
            provider.clearData();
          } else {
            provider.swapResponse = response;
            provider.isSwapCreated = true;
            provider.isSwapValid = false;
            provider.swapMessage = message;
          }
        });
      }
    }
  }

  void _showSnackbar() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Text Copied")));
  }

  void _copyText(String text) {
    FlutterClipboard.copy(text).then((value) => _showSnackbar());
  }
}
