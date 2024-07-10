import 'dart:async'; // Import for using Timer
import 'package:flutter/material.dart';
import 'package:fluxswap/api/models/swap_stats.dart';
import 'package:fluxswap/api/services/swap_service.dart';

class TotalSwapsDisplay extends StatefulWidget {
  const TotalSwapsDisplay({super.key});

  @override
  _TotalSwapsDisplayState createState() => _TotalSwapsDisplayState();
}

class _TotalSwapsDisplayState extends State<TotalSwapsDisplay> {
  late Future<int> futureTotalSwaps;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    futureTotalSwaps = fetchTotalSwaps();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _timer
        ?.cancel(); // Cancel the timer when the widget is disposed to prevent memory leaks
    super.dispose();
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(
        const Duration(minutes: 10), (Timer t) => _refreshData());
  }

  void _refreshData() {
    setState(() {
      futureTotalSwaps = fetchTotalSwaps(); // Refresh the data and UI
    });
  }

  Future<int> fetchTotalSwaps() async {
    SwapStats stats = await SwapService
        .fetchSwapStats(); // Assuming fetchSwapStats is an asynchronous API call
    return stats.data.totalSwaps;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: futureTotalSwaps,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Center(
              child: Text('Total Swaps Performed: ${snapshot.data}',
                  style: const TextStyle(fontSize: 24, color: Colors.white)),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error fetching data swap statistics"),
            );
          }
        }
        // By default, show a loading spinner.
        return const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Total Swaps Performed:   ',
                style: TextStyle(fontSize: 24, color: Colors.white)),
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(),
            )
            // CircularProgressIndicator()
          ],
        );
      },
    );
  }
}
