import 'package:flutter/material.dart';
import 'swapstats.dart';

class TotalSwapsDisplay extends StatefulWidget {
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
              child: Text('Swaps so far: ${snapshot.data}',
                  style: TextStyle(fontSize: 24)),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error fetching data swap statistics"));
          }
        }
        // By default, show a loading spinner.
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
