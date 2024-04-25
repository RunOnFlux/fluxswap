import 'package:flutter/material.dart';
import 'package:fluxswap/dialogs/approveswapdialog.dart';
import 'package:fluxswap/provider/fluxswapprovider.dart';
import 'package:provider/provider.dart';
import '../api/requests.dart';

class ReserveSwapButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String zelid;
  final ReserveRequest reserveRequest;

  ReserveSwapButton(
      {required this.formKey,
      required this.zelid,
      required this.reserveRequest});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FluxSwapProvider>(context);
    return ElevatedButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
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