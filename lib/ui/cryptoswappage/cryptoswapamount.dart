import 'package:flutter/material.dart';
import 'package:fluxswap/api/models/cryptoswap/swapasset.dart';
import 'package:fluxswap/constants/cryptoswap/coin_logos.dart';
import 'package:fluxswap/providers/crypto_swap_provider.dart';
import 'package:provider/provider.dart';

const Color lightYellow = Color(0xFFFFF9C4);
const Color lightBlue = Color(0xFFB3E5FC);
const Color lightRed = Color(0xFFFFCDD2);
const Color lightGreen = Color(0xFFC8E6C9);
const Color lightPurple = Color(0xFFD1C4E9);

class AssetSelectionWidget extends StatefulWidget {
  final bool isSellAsset;

  const AssetSelectionWidget({Key? key, required this.isSellAsset})
      : super(key: key);

  @override
  _AssetSelectionWidgetState createState() => _AssetSelectionWidgetState();
}

class _AssetSelectionWidgetState extends State<AssetSelectionWidget> {
  TextEditingController _controller = TextEditingController(text: "0.1");
  TextEditingController _searchController = TextEditingController();
  List<Asset> _filteredAssets = [];
  final GlobalKey _assetButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    final cryptoSwapProvider =
        Provider.of<CryptoSwapProvider>(context, listen: false);

    // Initialize the filtered assets with the appropriate list
    _filteredAssets = widget.isSellAsset
        ? cryptoSwapProvider.sellAssets
        : cryptoSwapProvider.filteredBuyAssets;

    // Add listener to update filtered assets as user types
    _searchController.addListener(() {
      _filterAssets(_searchController.text);
    });
  }

  void _filterAssets(String query) {
    final cryptoSwapProvider =
        Provider.of<CryptoSwapProvider>(context, listen: false);
    final assets = widget.isSellAsset
        ? cryptoSwapProvider.sellAssets
        : cryptoSwapProvider.filteredBuyAssets;
    setState(() {
      _filteredAssets = assets
          .where((asset) =>
              asset.ticker.toLowerCase().contains(query.toLowerCase()) ||
              asset.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    final cryptoSwapProvider =
        Provider.of<CryptoSwapProvider>(context, listen: false);
    setState(() {
      _filteredAssets = widget.isSellAsset
          ? cryptoSwapProvider.sellAssets
          : cryptoSwapProvider.filteredBuyAssets;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cryptoSwapProvider = Provider.of<CryptoSwapProvider>(context);

    final Asset? selectedAsset = widget.isSellAsset
        ? cryptoSwapProvider.selectedSellAsset
        : cryptoSwapProvider.selectedBuyAsset;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            height: 65,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Text(
                  widget.isSellAsset ? "You send" : "You get",
                ),
                SizedBox(width: 8),
                Expanded(
                  child: widget.isSellAsset
                      ? TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            if (widget.isSellAsset) {
                              cryptoSwapProvider.sellAmount = value;
                            }
                          },
                        )
                      : cryptoSwapProvider.isLoading
                          ? Container(
                              alignment: Alignment.centerRight,
                              height: 65,
                              child: CircularProgressIndicator(),
                            )
                          : TextField(
                              controller: TextEditingController(
                                text:
                                    "${cryptoSwapProvider.isFixedRate ? "" : "\u2248"}  ${cryptoSwapProvider.buyAmount ?? "NaN"}",
                              ),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              enabled: false,
                            ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8),
        // GestureDetector for asset selection
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () async {
              final cryptoSwapProvider =
                  Provider.of<CryptoSwapProvider>(context, listen: false);

              setState(() {
                _filteredAssets = widget.isSellAsset
                    ? cryptoSwapProvider.sellAssets
                    : cryptoSwapProvider.filteredBuyAssets;
              });

              final selectedAsset = await _showSearchableDialog(context);
              if (selectedAsset != null) {
                if (widget.isSellAsset) {
                  Provider.of<CryptoSwapProvider>(context, listen: false)
                      .selectedSellAsset = selectedAsset;
                } else {
                  Provider.of<CryptoSwapProvider>(context, listen: false)
                      .selectedBuyAsset = selectedAsset;
                }
              }
              _clearSearch();
            },
            child: Container(
              height: 65,
              key: _assetButtonKey,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  CoinLogos().getImageWidget(selectedAsset?.idzelcore ?? ''),
                  SizedBox(width: 8),
                  Text(
                    selectedAsset?.ticker ?? "Select Asset",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (selectedAsset != null &&
                      selectedAsset.chain.toLowerCase() != 'custom') ...[
                    SizedBox(width: 4),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: getChainColor(selectedAsset.chain),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        selectedAsset.chain.toUpperCase(),
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                  Spacer(),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<Asset?> _showSearchableDialog(BuildContext context) {
    final RenderBox renderBox =
        _assetButtonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final double rightEdge = offset.dx + renderBox.size.width;
    final double height = renderBox.size.height;

    return showDialog<Asset>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              insetPadding: EdgeInsets.only(
                left: rightEdge - MediaQuery.of(context).size.width * 0.3,
                right: MediaQuery.of(context).size.width - rightEdge,
                top: offset.dy, // Adjust as needed
                bottom: height, // Adjust as needed
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.search),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Type a cryptocurrency or ticker',
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _filterAssets(value);
                                  });
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _filteredAssets.length,
                        itemBuilder: (BuildContext context, int index) {
                          final asset = _filteredAssets[index];
                          final isCustomNetwork =
                              asset.chain.toLowerCase() == 'custom';
                          return ListTile(
                            leading:
                                CoinLogos().getImageWidget(asset.idzelcore),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          asset.ticker,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (!isCustomNetwork) ...[
                                        SizedBox(width: 4),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: getChainColor(asset.chain),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            asset.chain.toUpperCase(),
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    width: 16), // Adjust the spacing as needed
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 200),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      isCustomNetwork
                                          ? asset.name
                                          : '${asset.name} (${asset.chain})',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).pop(asset);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color getChainColor(String chain) {
    switch (chain.toLowerCase()) {
      case 'bsc':
        return lightYellow;
      case 'eth':
        return lightBlue;
      case 'tron':
        return lightRed;
      case 'base':
        return lightGreen;
      case 'solana':
        return lightPurple;
      case 'arbitium':
        return lightGreen;
      case 'optisium':
        return lightRed;
      default:
        return Colors.grey;
    }
  }
}
