import 'package:flutter/material.dart';
import 'package:fluxswap/changenotifier.dart';
import 'package:fluxswap/api/models/reserve_model.dart';
import 'package:fluxswap/api/services/swap_service.dart';
import 'package:provider/provider.dart';

class ApprovalDialog extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String zelid;
  final ReserveRequest reserveRequest;

  const ApprovalDialog(
      {super.key,
      required this.formKey,
      required this.zelid,
      required this.reserveRequest});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FluxSwapProvider>(context);
    return AlertDialog(
      title: const Text('Reserving Swap'),
      content: const Text('''
          By clicking Accept you are reserving your swap.\n
          The next step will be to send your Flux to the deposit address.\n
          If you are ready to send your flux, click Accept.
          '''),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            provider.isReservedApproved = false;
            provider.isReservedValid = false;
            provider.reservedMessage = 'User cancelled';
            Navigator.of(context).pop();
          },
          child: const Text('Decline'),
        ),
        TextButton(
          onPressed: () {
            SwapService.makeReserveRequest(zelid, reserveRequest).then(
              (value) {
                bool success = value[0];
                String message = value[1];
                if (success) {
                  provider.submittedRequest = reserveRequest;
                  provider.submittedFromCurrency =
                      provider.selectedFromCurrency;
                  provider.submittedToCurrency = provider.selectedToCurrency;
                  provider.isReservedApproved = true;
                  provider.isReservedValid = true;
                  provider.reservedMessage = message;
                  Navigator.of(context).pop();
                } else {
                  provider.isReservedApproved = true;
                  provider.isReservedValid = false;
                  provider.reservedMessage = message;
                  Navigator.of(context).pop();
                }
              },
            );
          },
          child: const Text('Accept'),
        ),
      ],
    );
  }
}
