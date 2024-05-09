import 'package:flutter/material.dart';
import 'package:fluxswap/changenotifier.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WalletDrawer extends StatelessWidget {
  const WalletDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FluxSwapProvider>(context);
    return Drawer(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Connect a wallet',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.only(left: 15, top: 15, bottom: 15),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(
                  6), // Same or slightly less than Container border radius
              child: SvgPicture.asset(
                "/images/metamask-icon.svg",
                width: 40, // Set your desired width for the SVG image
                height: 40, // Set your desired height for the SVG image
              ),
            ),
            title: const Text('MetaMask'),
            onTap: () => context.read<FluxSwapProvider>().connectMetamask(),
          ),
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(
                  6), // Same or slightly less than Container border radius
              child: SvgPicture.asset(
                "/images/walletconnect-icon.svg",
                width: 40, // Set your desired width for the SVG image
                height: 40, // Set your desired height for the SVG image
              ),
            ),
            title: const Text('WalletConnect'),
            enabled:
                (provider.walletstatuses[WALLETS.WALLETCONNECT] ?? false) ==
                    true,
            subtitle:
                (provider.walletstatuses[WALLETS.WALLETCONNECT] ?? false) ==
                        false
                    ? const Text('Coming soon')
                    : null,
            onTap: () => connectWallet('WalletConnect', context),
          ),
        ],
      ),
    ));
  }

  void connectWallet(String walletName, BuildContext context) {
    Navigator.of(context).pop(); // Close the drawer
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Wallet Connected'),
          content: Text('You have connected $walletName.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
