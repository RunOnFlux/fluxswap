import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluxswap/api/models/swap_model.dart';
import 'package:fluxswap/constants/coin_details.dart';
import 'package:fluxswap/constants/explorer_url_details.dart';
import 'package:fluxswap/providers/flux_swap_provider.dart';
import 'package:fluxswap/ui/fluxexchangepage/statusupdatewidget.dart';
import 'package:fluxswap/utils/helpers.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SwapInfoCard extends StatefulWidget {
  final SwapResponse swapResponse;
  final bool fSearch;

  const SwapInfoCard(
      {super.key, required this.swapResponse, required this.fSearch});

  @override
  _SwapInfoCardState createState() => _SwapInfoCardState();
}

class _SwapInfoCardState extends State<SwapInfoCard> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FluxSwapProvider>(context);
    return Center(
      child: Card(
        elevation: 10, // Adjust elevation for desired shadow depth
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              color: Color.fromRGBO(237, 237, 237, 1),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'ID: ${widget.swapResponse.id}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            iconSize: 20,
                            icon: const Icon(Icons.content_copy_rounded),
                            onPressed: () => Clipboard.setData(
                                ClipboardData(text: widget.swapResponse.id)),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            if (widget.fSearch) {
                              provider.fShowSearchedCard = false;
                            } else {
                              provider.fShowSwapCard = false;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(),
              _buildTransactionFlow(),
              const Divider(),
              _buildDetailRow(
                  "Date: ${provider.dateFormat.format(DateTime.fromMillisecondsSinceEpoch(widget.swapResponse.timestamp).toLocal())}"),
              StatusUpdateWidget(
                swapId: widget.swapResponse.id,
                initialStatus: widget.swapResponse.status,
              ),
              const SizedBox(height: 40),
              _buildCopyableRow("Deposit TX: ${widget.swapResponse.txidFrom}",
                  widget.swapResponse.txidFrom),
              _buildCopyableRow("To Address: ${widget.swapResponse.addressTo}",
                  widget.swapResponse.addressTo),
              _buildExplorerButton(),
              const SizedBox(height: 15),
              _buildCloseButton(),
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
              overflow: TextOverflow.clip,
            )),
      ],
    );
  }

  Widget _buildCopyableRow(String text, String copyContent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            textAlign: TextAlign.center,
            text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            overflow: TextOverflow
                .clip, // This ensures the text wraps to the next line
          ),
        ),
        IconButton(
          icon: const Icon(Icons.content_copy_rounded),
          onPressed: () => Clipboard.setData(ClipboardData(text: copyContent)),
        ),
      ],
    );
  }

  Widget _buildExplorerButton() {
    return SizedBox(
      width: 200,
      height: 30,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              const MaterialStatePropertyAll(Color.fromARGB(255, 29, 26, 239)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(4),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(4)),
          )),
        ),
        onPressed: () {
          final String url =
              "${Explorer_Urls[widget.swapResponse.chainFrom]}${widget.swapResponse.txidFrom}";
          launchUrl(Uri.parse(url));
        },
        child: const Text("Show in explorer",
            style: TextStyle(color: Colors.white, fontSize: 14)),
      ),
    );
  }

  Widget _buildCloseButton() {
    final provider = Provider.of<FluxSwapProvider>(context);
    return SizedBox(
      width: 200,
      height: 30,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(
              Color.fromARGB(255, 101, 101, 101)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(4),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(4)),
          )),
        ),
        onPressed: () {
          setState(() {
            if (widget.fSearch) {
              provider.fShowSearchedCard = false;
            } else {
              provider.fShowSwapCard = false;
            }
          });
        },
        child: const Text("Close",
            style: TextStyle(color: Colors.white, fontSize: 14)),
      ),
    );
  }

  Widget _buildTransactionFlow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              '${widget.swapResponse.expectedAmountFrom} ${getSwapNameFromApiName(widget.swapResponse.chainFrom)}',
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          SvgPicture.asset(
              '${Coin_Details[getSwapNameFromApiName(widget.swapResponse.chainFrom)]?.imageName}',
              width: 50,
              height: 50),
          const Icon(Icons.arrow_right_alt, size: 40, color: Colors.green),
          Text(
              '${widget.swapResponse.expectedAmountTo} ${getSwapNameFromApiName(widget.swapResponse.chainTo)}',
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          SvgPicture.asset(
              '${Coin_Details[getSwapNameFromApiName(widget.swapResponse.chainTo)]?.imageName}',
              width: 50,
              height: 50),
        ],
      ),
    );
  }
}
