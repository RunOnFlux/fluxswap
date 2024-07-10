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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FluxSwapProvider>(context);
    return Container(
        padding: const EdgeInsets.all(10),
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: const Color.fromARGB(255, 214, 214, 214),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                          controller: searchController,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.normal),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Swap ID",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  final swapID = searchController.text.trim();
                                  if (swapID.isNotEmpty) {
                                    _getSwapInfo(provider, true);
                                  }
                                }
                              },
                            ),
                          ),
                          onChanged: (value) {
                            provider.searchSwapID = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Swap ID can\'t be blank';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            if (_formKey.currentState!.validate()) {
                              final swapID = searchController.text.trim();
                              if (swapID.isNotEmpty) {
                                _getSwapInfo(provider, true);
                              }
                            }
                          }),
                    ),
                    const SizedBox(width: 10),
                    if (_isFetching) const CircularProgressIndicator()
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void _getSwapInfo(FluxSwapProvider provider, bool fForSearch) async {
    if (provider.searchSwapID.isNotEmpty) {
      setState(() {
        _isFetching = true; // Start fetching and show loader
      });
      try {
        SwapResponse swap =
            await SwapService.fetchSwapStatus(provider.searchSwapID);
        await Future.delayed(const Duration(seconds: 1)); // Simulate delay
        if (mounted) {
          if (fForSearch) {
            provider.searchToDisplay = swap;
            provider.fShowSearchedCard = true;
          } else {
            provider.swapToDisplay = swap;
            provider.fShowSwapCard = true;
          }
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
