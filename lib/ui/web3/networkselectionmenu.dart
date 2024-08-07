import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluxswap/constants/network_details.dart';
import 'package:fluxswap/providers/flux_swap_provider.dart';
import 'package:provider/provider.dart';

class NetworkSelectionMenu extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const NetworkSelectionMenu({super.key, required this.scaffoldKey});

  @override
  // ignore: library_private_types_in_public_api
  _NetworkSelectionMenuState createState() => _NetworkSelectionMenuState();
}

class _NetworkSelectionMenuState extends State<NetworkSelectionMenu> {
  void _openEndDrawer() {
    widget.scaffoldKey.currentState?.openEndDrawer();
  }

  void _closeEndDrawer() {
    widget.scaffoldKey.currentState?.closeEndDrawer();
  }

  void _showSnackbar() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Text Copied")));
  }

  void _copyText(String copytext) {
    FlutterClipboard.copy(copytext).then((value) => _showSnackbar());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Consumer<FluxSwapProvider>(
        builder: (context, provider, child) {
          if (provider.isConnected) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PopupMenuButton<String>(
                  offset: const Offset(0, 40),
                  itemBuilder: (BuildContext context) {
                    return Metamask_Network_Info.keys.map((String value) {
                      bool isSelected = value == provider.selectedChain;
                      return PopupMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              Metamask_Network_Info[value]!.imageName,
                              width: 30,
                              height: 30,
                            ),
                            const SizedBox(
                                width: 10), // Add spacing between icon and text
                            Text(value),
                            const SizedBox(width: 40),
                            if (isSelected)
                              const Icon(Icons.check, color: Colors.green),
                          ],
                        ),
                      );
                    }).toList();
                  },
                  onSelected: (String newValue) {
                    setState(() {
                      provider.previousSelectedChain = provider.selectedChain;
                      provider.selectedChain = newValue;
                      provider.requestChangeChainMetamask();
                    });
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        Metamask_Network_Info[provider.selectedChain]!
                            .imageName,
                        width: 30,
                        height: 30,
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ), // Dropdown symbol
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Row(
                  children: [
                    const Icon(IconData(0xf635, fontFamily: 'MaterialIcons'),
                        color: Colors.green),
                    TextButton(
                      onPressed: () => _copyText(provider.currentAddress),
                      child: Text(
                        '${provider.currentAddress.substring(0, 7)}...${provider.currentAddress.substring(provider.currentAddress.length - 4)}',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _copyText(provider.currentAddress),
                      icon: const Icon(
                        Icons.content_copy_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              ],
            );
          } else {
            return ElevatedButton(
              onPressed: _openEndDrawer,
              child: const Text('Connect Wallet'),
            );
          }
        },
      ),
    );
  }
}
