import 'package:flutter/material.dart';
import 'package:fluxswap/changenotifier.dart';
import 'package:provider/provider.dart';

class StatusIndicator extends StatelessWidget {
  const StatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    // Access your provider
    final provider = Provider.of<FluxSwapProvider>(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          provider.hasSwapInfoError ? Icons.error : Icons.check_circle,
          color: provider.hasSwapInfoError ? Colors.red : Colors.green,
        ),
        const SizedBox(
            width: 8), // Provide some spacing between the icon and text
        Text(
          provider.hasSwapInfoError ? 'Flux Swap Offline' : 'Flux Swap Online',
          style: TextStyle(
              color: provider.hasSwapInfoError ? Colors.red : Colors.green),
        ),
      ],
    );
  }
}
