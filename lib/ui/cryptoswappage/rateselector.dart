import 'package:flutter/material.dart';
import 'package:fluxswap/providers/crypto_swap_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RateSelector extends StatelessWidget {
  Future<void> _launchURL() async {
    const url =
        'https://example.com/terms-of-use'; // Replace with your terms of use URL
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CryptoSwapProvider>(
      builder: (context, lockStateProvider, child) {
        return Row(
          children: [
            Tooltip(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(
                  10), // Add padding to the tooltip's outer edges
              richMessage: TextSpan(
                children: [
                  WidgetSpan(
                    child: Icon(Icons.lock_open, size: 16, color: Colors.white),
                  ),
                  TextSpan(
                    text: " Floating exchange rate\n",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextSpan(
                    text:
                        "The amount you get may change due to market volatility.\n\n",
                    style: TextStyle(color: Colors.grey),
                  ),
                  WidgetSpan(
                    child: Icon(Icons.lock, size: 16, color: Colors.white),
                  ),
                  TextSpan(
                    text: " Fixed exchange rate\n",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextSpan(
                    text:
                        "The amount you get is fixed and doesn’t depend on market volatility.\n\n",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextSpan(
                    text: "For more information, read the ",
                    style: TextStyle(color: Colors.grey),
                  ),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: _launchURL,
                      child: Text(
                        "Terms of use",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  context.read<CryptoSwapProvider>().toggleIsFixedRateState();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Icon(
                        lockStateProvider.isFixedRate
                            ? Icons.lock
                            : Icons.lock_open,
                      ),
                      SizedBox(width: 8),
                      Text(
                        lockStateProvider.isFixedRate
                            ? "Fixed Rate"
                            : "Floating Rate",
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Spacer(), // Add a Spacer after the Container
          ],
        );
      },
    );
  }
}
