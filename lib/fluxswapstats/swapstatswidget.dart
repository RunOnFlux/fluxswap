import 'package:flutter/material.dart';
import 'package:fluxswap/fluxswapstats/swapstats.dart';

class SwapStatsWidget extends StatelessWidget {
  final SwapStats stats;

  const SwapStatsWidget({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5, // Number of columns
        crossAxisSpacing: 10, // Horizontal space between cards
        mainAxisSpacing: 10, // Vertical space between cards
        childAspectRatio: 3, // Aspect ratio of the cards
      ),
      itemCount: 50, // Total number of cards
      itemBuilder: (context, index) {
        // This maps the index to a specific piece of data
        List<String> titles = [
          'Total Swaps: ${stats.data.totalSwaps}',
          'Finished Swaps: ${stats.data.swapsFinished}',
          'New Swaps: ${stats.data.swapsNew}',
          'Waiting Swaps: ${stats.data.swapsWaiting}',
          'Exchanging Swaps: ${stats.data.swapsExchanging}',
          'Expired Swaps: ${stats.data.swapsExpired}',
          'Swaps on Hold: ${stats.data.swapsHold}',
          'Confirming Swaps: ${stats.data.swapsConfirming}',
          'Dust Swaps: ${stats.data.swapsDust}',
          'Main Fee Captured: ${stats.data.mainFeeCaptured}',
          'KDA Fee Captured: ${stats.data.kdaFeeCaptured}',
          'ETH Fee Captured: ${stats.data.ethFeeCaptured}',
          'BSC Fee Captured: ${stats.data.bscFeeCaptured}',
          'Swaps to Main: ${stats.data.swapsToMain}',
          'Swaps to KDA: ${stats.data.swapsToKDA}',
          'Swaps to ETH: ${stats.data.swapsToETH}',
          'Swaps to BSC: ${stats.data.swapsToBSC}',
          'Swaps from Main: ${stats.data.swapsFromMain}',
          'Swaps from KDA: ${stats.data.swapsFromKDA}',
          'Swaps from ETH: ${stats.data.swapsFromETH}',
          'Swaps from BSC: ${stats.data.swapsFromBSC}',
        ];

        if (index >= titles.length) {
          return Container(); // Guard for out-of-bounds
        }

        return Card(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(titles[index]),
            ),
          ),
        );
      },
    );
  }
}

class SwapStatsScreen extends StatefulWidget {
  const SwapStatsScreen({super.key});

  @override
  _SwapStatsScreenState createState() => _SwapStatsScreenState();
}

class _SwapStatsScreenState extends State<SwapStatsScreen> {
  late Future<SwapStats> futureSwapStats;

  @override
  void initState() {
    super.initState();
    futureSwapStats = fetchSwapStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Swap Statistics"),
      ),
      body: FutureBuilder<SwapStats>(
        future: futureSwapStats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return SwapStatsWidget(stats: snapshot.data!);
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
          }
          // By default, show a loading spinner.
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
