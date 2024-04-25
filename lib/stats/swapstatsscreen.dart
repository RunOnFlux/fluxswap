import 'package:flutter/material.dart';
import 'swapstats.dart';
import 'swapstatswidget.dart';

class SwapStatsScreen extends StatefulWidget {
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
    return FutureBuilder<SwapStats>(
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
    );
  }
}
