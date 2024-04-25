import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/fluxswapprovider.dart';
import '/helper/modals.dart';

class MetaMaskCard extends StatelessWidget {
  const MetaMaskCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Consumer<FluxSwapProvider>(
        builder: (context, provider, child) {
          late final String text;
          text = provider.account;
          late final int chain;
          chain = provider.currentChain;
          if (provider.isConnected) {
            return _buildConnectedCard(context, provider, text, chain);
          } else if (provider.isEnabled) {
            return _buildConnectWalletButton(context);
          } else {
            return const Text('Please use a Web3 supported browser.');
          }
        },
      ),
    );
  }

  Widget _buildConnectedCard(
      BuildContext context, FluxSwapProvider provider, String text, int chain) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white54, width: 1),
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 15,
      shadowColor: Colors.black,
      color: const Color.fromARGB(255, 10, 17, 32),
      child: Container(
        padding: const EdgeInsets.only(left: 15, bottom: 15),
        height: 270,
        width: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Network - ${getNetworkName(chain)}',
                style: const TextStyle(color: Colors.white60, fontSize: 16)),
            _buildAccountInfo(context, provider, text),
            _buildGasInfo(context, provider, chain),
            _buildFluxInfo(context, provider, chain),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountInfo(
      BuildContext context, FluxSwapProvider provider, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          height: 75,
          width: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.white60,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Connected to MetaMask',
                    style: TextStyle(color: Colors.white60)),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _copytext(text, context),
                      icon: const Icon(Icons.content_copy_rounded),
                      color: Colors.white60,
                    ),
                    Text(
                        '${text.substring(0, 15)}...${text.substring(text.length - 10)}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGasInfo(
      BuildContext context, FluxSwapProvider provider, int chain) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          height: 75,
          width: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.white60,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(provider.getGasCoinAmount().toString(),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                    const SizedBox(width: 20),
                    Text(provider.getGasCoinName(chain),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFluxInfo(
      BuildContext context, FluxSwapProvider provider, int chain) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          height: 75,
          width: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.white60,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(provider.getFluxCoinAmount().toString(),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue)),
                    const SizedBox(width: 20),
                    Text('FLUX-${provider.getGasCoinName(chain)}',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConnectWalletButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.read<FluxSwapProvider>().connect(),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        foregroundColor: const Color.fromARGB(255, 19, 43, 98),
        padding: const EdgeInsets.symmetric(horizontal: 10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Image.asset("assets/images/MetaMask_Fox.png",
                height: 30, width: 40),
          ),
          const Text("Connect Wallet",
              style: TextStyle(color: Colors.white60, fontSize: 18)),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  void _showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Text Copied")));
  }

  void _copytext(String copytext, BuildContext context) {
    FlutterClipboard.copy(copytext).then((value) => _showSnackbar(context));
  }
}
