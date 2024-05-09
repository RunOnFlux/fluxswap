import 'package:flutter/material.dart';
import 'package:fluxswap/ui/fluxexchangepage/amountbox/currencyselector.dart';
import 'package:fluxswap/ui/fluxexchangepage/amountbox/inputamountfield.dart'; // Ensure this import is correct and the file exists

class AmountContainer extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController toAmountController;
  final bool isFrom;

  const AmountContainer({
    super.key,
    required this.formKey,
    required this.toAmountController,
    required this.isFrom,
  });

  @override
  _AmountContainerState createState() => _AmountContainerState();
}

class _AmountContainerState extends State<AmountContainer> {
  @override
  Widget build(BuildContext context) {
    if (widget.isFrom) {
      return Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(10),
            height: 125,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: const Color.fromRGBO(237, 237, 237, 1),
            ), // Overall padding around the entire container
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('You pay', style: TextStyle(fontSize: 14)), // Label
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                          child: InputAmountField(
                              toAmountController: widget.toAmountController,
                              formKey: widget.formKey)),
                      FromCurrencyDropdown(
                        formKey: widget.formKey,
                        toAmountController: widget.toAmountController,
                        isFrom: widget.isFrom,
                      ),
                    ],
                  ),
                ),
                const Row(
                  mainAxisAlignment:
                      MainAxisAlignment.end, // Aligns the text to the right
                  children: [
                    Text('Balance: \$100',
                        style:
                            TextStyle(fontSize: 10)), // Placeholder for balance
                  ],
                ),
              ],
            ),
          ));
    } else {
      return Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(10),
            height: 125,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: const Color.fromRGBO(237, 237, 237, 1),
            ), // Overall padding around the entire container
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('You receive',
                    style: TextStyle(fontSize: 14)), // Label
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                          child: OutputAmountField(
                              toAmountController: widget.toAmountController,
                              formKey: widget.formKey)),
                      FromCurrencyDropdown(
                        formKey: widget.formKey,
                        toAmountController: widget.toAmountController,
                        isFrom: widget.isFrom,
                      ),
                    ],
                  ),
                ),
                const Row(
                  mainAxisAlignment:
                      MainAxisAlignment.end, // Aligns the text to the right
                  children: [
                    Text('Balance: \$100',
                        style:
                            TextStyle(fontSize: 10)), // Placeholder for balance
                  ],
                ),
              ],
            ),
          ));
    }
  }
}
