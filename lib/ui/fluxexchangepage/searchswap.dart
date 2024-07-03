import 'package:flutter/material.dart';
import 'package:fluxswap/api/models/swap_model.dart';
import 'package:fluxswap/providers/flux_swap_provider.dart';
import 'package:fluxswap/api/services/swap_service.dart';
import 'package:provider/provider.dart';

class SearchSwap extends StatefulWidget {
  const SearchSwap({super.key});

  @override
  _SearchSwapState createState() => _SearchSwapState();
}

class _SearchSwapState extends State<SearchSwap> {
  bool _isFetching = false; // Local state to manage fetching status

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FluxSwapProvider>(context);
    return Container(
        padding: const EdgeInsets.all(10),
        width: 250,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: const Color.fromARGB(255, 214, 214, 214),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Swap ID",
                      ),
                      onChanged: (value) {
                        provider.searchSwapID = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Flux ID / Zel ID can\'t be blank';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  _isFetching
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: const MaterialStatePropertyAll(
                                Color.fromARGB(255, 152, 149, 252)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(4),
                                  bottomRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(4)),
                            )),
                          ),
                          onPressed: () => _getSwapInfo(provider),
                          child: const Text(
                            "Search",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ));
  }

  void _getSwapInfo(FluxSwapProvider provider) async {
    if (provider.searchSwapID.isNotEmpty) {
      setState(() {
        _isFetching = true; // Start fetching and show loader
      });
      try {
        SwapResponse swap =
            await SwapService.fetchSwapStatus(provider.searchSwapID);
        await Future.delayed(const Duration(seconds: 1)); // Simulate delay
        if (mounted) {
          provider.swapToDisplay = swap;
          provider.fShowSwapCard = true;
        }
      } catch (e) {
        provider.addError(e.toString());
      } finally {
        if (mounted) {
          setState(() {
            _isFetching = false; // Stop fetching and show button again
          });
        }
      }
    }
  }
}
