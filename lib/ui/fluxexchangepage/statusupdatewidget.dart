import 'dart:async'; // Import for Timer
import 'package:flutter/material.dart';
import 'package:fluxswap/api/models/swap_model.dart';

import 'package:fluxswap/api/services/swap_service.dart';

class StatusUpdateWidget extends StatefulWidget {
  final String swapId;
  final String initialStatus;
  const StatusUpdateWidget(
      {super.key, required this.swapId, required this.initialStatus});

  @override
  // ignore: library_private_types_in_public_api
  _StatusUpdateWidgetState createState() => _StatusUpdateWidgetState();
}

class _StatusUpdateWidgetState extends State<StatusUpdateWidget> {
  String _status = 'loading...';
  Color _statusColor = Colors.grey;
  Timer? _timer;
  bool _isLoading = false; // New state variable for loading state

  @override
  void initState() {
    super.initState();
    _status = widget.initialStatus;
    _statusColor = _status == 'hold' ? Colors.red : Colors.green;
    if (_status != 'finished') {
      _startPeriodicUpdate();
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Stop the timer when the widget is disposed
    super.dispose();
  }

  void _startPeriodicUpdate() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _updateStatus();
    });
  }

  void _updateStatus() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true; // Set loading to true
      });
    }

    try {
      SwapResponse swap = await SwapService.fetchSwapStatus(widget.swapId);
      if (swap.status == "finished") {
        _timer?.cancel(); // Stop the timer if the status is "finished"
      }
      await Future.delayed(const Duration(
          seconds: 2)); // Delay for 2 seconds to show loading indicator
      if (mounted) {
        setState(() {
          _status = swap.status;
          _statusColor = swap.status == 'hold' ? Colors.red : Colors.green;
          _isLoading = false; // Set loading to false
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _status = 'Failed to fetch status';
          _statusColor = Colors.red;
          _isLoading = false; // Set loading to false even if there's an error
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "Status: ",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              ) // Show loading indicator when updating
            : Text(
                _status,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _statusColor),
              ),
      ],
    );
  }
}
