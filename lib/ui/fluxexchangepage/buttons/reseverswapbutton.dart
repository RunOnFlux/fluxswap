import 'package:flutter/material.dart';
import 'package:fluxswap/ui/fluxexchangepage/dialogs/approveswapdialog.dart';
import 'package:fluxswap/changenotifier.dart';
import 'package:fluxswap/api/models/reserve_model.dart';
import 'package:provider/provider.dart';

class ReserveSwapButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String zelid;
  final ReserveRequest reserveRequest;

  const ReserveSwapButton(
      {super.key,
      required this.formKey,
      required this.zelid,
      required this.reserveRequest});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FluxSwapProvider>(context);
    return ElevatedButton(
      onPressed: provider.hasSwapInfoError
          ? null
          : () {
              if (formKey.currentState!.validate()) {
                provider.addRecentlyUsedZelid(zelid);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ChangeNotifierProvider.value(
                          value: provider,
                          child: ApprovalDialog(
                            formKey: formKey,
                            zelid: zelid,
                            reserveRequest: reserveRequest,
                          ));
                    });
              } else {
                return;
              }
            },
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(
          const Size(double.infinity, 40),
        ),
      ),
      child: const Text('Reserve Swap'),
    );
  }
}
