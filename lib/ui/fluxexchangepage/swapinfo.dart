import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluxswap/constants/coin_details.dart';
import 'package:fluxswap/constants/explorer_url_details.dart';
import 'package:fluxswap/providers/flux_swap_provider.dart';
import 'package:fluxswap/ui/fluxexchangepage/statusupdatewidget.dart';
import 'package:fluxswap/utils/helpers.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SwapInfoCard extends StatelessWidget {
  const SwapInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FluxSwapProvider>(context);
    return Center(
      child: Card(
        elevation: 10, // Adjust elevation for desired shadow depth
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(10),
          width: 775, // Adapt to screen size
          decoration: const BoxDecoration(
              color: Color.fromRGBO(237, 237, 237, 1),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Swap ID: ${provider.swapToDisplay.id}',
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            iconSize: 15,
                            icon: const Icon(Icons.content_copy_rounded),
                            onPressed: () => Clipboard.setData(
                                ClipboardData(text: provider.swapToDisplay.id)),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          provider.fShowSwapCard = false;
                        },
                      ),
                    ],
                  ),
                  const Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Fusion Swap Information",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              _buildTransactionFlow(context),
              const Divider(),
              _buildDetailRow(
                  "Date: ${provider.dateFormat.format(DateTime.fromMillisecondsSinceEpoch(provider.swapToDisplay.timestamp).toLocal())}"),
              StatusUpdateWidget(
                swapId: provider.swapToDisplay.id,
                initialStatus: provider.swapToDisplay.status,
              ),
              const SizedBox(height: 40),
              _buildCopyableRow(
                  "Deposit TX ID: ${provider.swapToDisplay.txidFrom}",
                  provider.swapToDisplay.txidFrom),
              _buildCopyableRow(
                  "To Address: ${provider.swapToDisplay.addressTo}",
                  provider.swapToDisplay.addressTo),
              _buildExplorerButton(context),
              SizedBox(height: 15),
              _buildCloseButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String text, [Color? color]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildCopyableRow(String text, String copyContent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        IconButton(
          icon: const Icon(Icons.content_copy_rounded),
          onPressed: () => Clipboard.setData(ClipboardData(text: copyContent)),
        ),
      ],
    );
  }

  Widget _buildExplorerButton(BuildContext context) {
    final provider = Provider.of<FluxSwapProvider>(context);
    return SizedBox(
      width: 200,
      height: 30,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStatePropertyAll(Color.fromARGB(255, 238, 141, 255)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(4),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(4)),
          )),
        ),
        onPressed: () {
          final String url =
              "${Explorer_Urls[provider.swapToDisplay.chainFrom]}${provider.swapToDisplay.txidFrom}";
          launchUrl(Uri.parse(url));
        },
        child: const Text("Show in explorer",
            style: TextStyle(color: Colors.white, fontSize: 14)),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    final provider = Provider.of<FluxSwapProvider>(context);
    return SizedBox(
      width: 200,
      height: 30,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStatePropertyAll(Color.fromARGB(255, 101, 101, 101)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(4),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(4)),
          )),
        ),
        onPressed: () {
          provider.fShowSwapCard = false;
        },
        child: const Text("Close",
            style: TextStyle(color: Colors.white, fontSize: 14)),
      ),
    );
  }

  Widget _buildTransactionFlow(BuildContext context) {
    final provider = Provider.of<FluxSwapProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            '${provider.swapToDisplay.expectedAmountFrom} ${getSwapNameFromApiName(provider.swapToDisplay.chainFrom)}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SvgPicture.asset(
            '${Coin_Details[getSwapNameFromApiName(provider.swapToDisplay.chainFrom)]?.imageName}',
            width: 80,
            height: 80),
        const Icon(Icons.arrow_right_alt, size: 40, color: Colors.green),
        Text(
            '${provider.swapToDisplay.expectedAmountTo} ${getSwapNameFromApiName(provider.swapToDisplay.chainTo)}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SvgPicture.asset(
            '${Coin_Details[getSwapNameFromApiName(provider.swapToDisplay.chainTo)]?.imageName}',
            width: 80,
            height: 80),
      ],
    );
  }
}
