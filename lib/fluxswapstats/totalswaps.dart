import 'package:flutter/material.dart';
import 'package:fluxswap/fluxswapstats/swapstats.dart';

class TotalSwapsDisplay extends StatefulWidget {
  const TotalSwapsDisplay({super.key});

  @override
  _TotalSwapsDisplayState createState() => _TotalSwapsDisplayState();
}

class _TotalSwapsDisplayState extends State<TotalSwapsDisplay> {
  late Future<int> futureTotalSwaps;

  @override
  void initState() {
    super.initState();
    futureTotalSwaps = fetchTotalSwaps();
  }

  Future<int> fetchTotalSwaps() async {
    SwapStats stats =
        await fetchSwapStats(); // This calls your existing API fetch function
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
                  style: const TextStyle(fontSize: 24)),
            );
          } else if (snapshot.hasError) {
            return const Center(
                child: Text("Error fetching data swap statistics"));
          }
        }
        // By default, show a loading spinner.
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
