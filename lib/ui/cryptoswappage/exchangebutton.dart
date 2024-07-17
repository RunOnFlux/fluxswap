import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluxswap/providers/crypto_swap_provider.dart';

class ExchangeButtonWidget extends StatefulWidget {
  @override
  _ExchangeButtonWidgetState createState() => _ExchangeButtonWidgetState();
}

class _ExchangeButtonWidgetState extends State<ExchangeButtonWidget> {
  bool _showExchangeDetails = false;
  TextEditingController _walletAddressController = TextEditingController();
  TextEditingController _refundAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cryptoSwapProvider = Provider.of<CryptoSwapProvider>(context);
    final buyAssetName = cryptoSwapProvider.selectedBuyAsset?.name ?? "Asset";
    final sellAssetName = cryptoSwapProvider.selectedSellAsset?.name ?? "Asset";

    final bool isCreateExchangeEnabled = cryptoSwapProvider.buyAmount != null &&
        cryptoSwapProvider.selectedBuyAsset != null &&
        cryptoSwapProvider.selectedSellAsset != null &&
        _walletAddressController.text.isNotEmpty &&
        _refundAddressController.text.isNotEmpty;

    return _showExchangeDetails
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter the wallet address',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _walletAddressController,
                decoration: InputDecoration(
                  hintText: "The Recipient's $buyAssetName address",
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) {
                  setState(() {});
                },
              ),
              SizedBox(height: 16),
              Text(
                'Enter your refund address',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _refundAddressController,
                decoration: InputDecoration(
                  hintText: "Your $sellAssetName refund address",
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) {
                  setState(() {});
                },
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 65,
                width: double.infinity,
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: isCreateExchangeEnabled
                          ? () {
                              cryptoSwapProvider.createSwap(
                                _walletAddressController.text,
                                _refundAddressController.text,
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCreateExchangeEnabled
                            ? Colors.blue
                            : Colors.grey, // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Rounded radius
                        ),
                      ),
                      child: Text(
                        'Create an exchange',
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontSize: 18, // Larger text size
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        cryptoSwapProvider.createTestSwap();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Rounded radius
                        ),
                      ),
                      child: Text(
                        'Use Test Swap Data',
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontSize: 18, // Larger text size
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'By clicking Create an exchange, I agree to the ',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(color: Colors.blue, fontSize: 12),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Handle Privacy Policy link
                          },
                      ),
                      TextSpan(
                        text: ' and ',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                      TextSpan(
                        text: 'Terms of Service.',
                        style: TextStyle(color: Colors.blue, fontSize: 12),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Handle Terms of Service link
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        : SizedBox(
            height: 65,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _showExchangeDetails = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded radius
                ),
              ),
              child: Text(
                'Exchange',
                style: TextStyle(
                  color: Colors.white, // Text color
                  fontSize: 18, // Larger text size
                ),
              ),
            ),
          );
  }

  @override
  void dispose() {
    _walletAddressController.dispose();
    _refundAddressController.dispose();
    super.dispose();
  }
}
