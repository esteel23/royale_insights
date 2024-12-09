import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProfilePage extends StatelessWidget {
  final String playerTag;
  final List<Map<String, dynamic>> playerRowData;

  const ProfilePage({
    required this.playerTag,
    required this.playerRowData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: playerRowData.isEmpty
          ? const Center(child: Text('No battle logs found.'))
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Player details
                ListTile(
                  title: Text(
                    'Player Tag: $playerTag',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                // Battle logs
                const Text(
                  'Battle Logs',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: playerRowData.length,
                  itemBuilder: (context, index) {
                    final log = playerRowData[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text('Date: ${log['rec_date']?.toString() ?? 'N/A'}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Trophies: ${log['trophies']?.toString() ?? 'N/A'}'),
                            Text('Battles Won: ${log['battles_won']?.toString() ?? 'N/A'}'),
                            Text('Crowns Won: ${log['crowns_won']?.toString() ?? 'N/A'}'),
                            Text(
                              'Three Crown Wins: ${log['three_crown_wins']?.toString() ?? 'N/A'}',
                            ),
                            Text('Elixir Leaked: ${log['elixir_leaked']?.toString() ?? 'N/A'}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Trophies Chart
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Trophies Over Time',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 300,
                          child: SfCartesianChart(
                            legend: Legend(isVisible: true),
                            primaryXAxis: CategoryAxis(),
                            primaryYAxis: NumericAxis(),
                            series: <ChartSeries>[
                              LineSeries<Map<String, dynamic>, String>(
                                name: 'Trophies',
                                dataSource: playerRowData,
                                xValueMapper: (log, _) => log['rec_date']?.toString() ?? '',
                                yValueMapper: (log, _) =>
                                    int.tryParse(log['trophies']?.toString() ?? '0'),
                                markerSettings: const MarkerSettings(isVisible: true),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Elixir Leaked and Crowns Chart
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Elixir Leaked and Crowns Won Over Time',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 300,
                          child: SfCartesianChart(
                            legend: Legend(isVisible: true),
                            primaryXAxis: CategoryAxis(),
                            primaryYAxis: NumericAxis(
                              minimum: 0,
                              maximum: playerRowData
                                  .map((log) =>
                                      int.tryParse(log['elixir_leaked']?.toString() ?? '0') ?? 0)
                                  .reduce((a, b) => a > b ? a : b)
                                  .toDouble(),
                            ),
                            series: <ChartSeries>[
                              LineSeries<Map<String, dynamic>, String>(
                                name: 'Elixir Leaked',
                                dataSource: playerRowData,
                                xValueMapper: (log, _) => log['rec_date']?.toString() ?? '',
                                yValueMapper: (log, _) =>
                                    int.tryParse(log['elixir_leaked']?.toString() ?? '0'),
                                markerSettings: const MarkerSettings(isVisible: true),
                              ),
                              LineSeries<Map<String, dynamic>, String>(
                                name: 'Crowns Won',
                                dataSource: playerRowData,
                                xValueMapper: (log, _) => log['rec_date']?.toString() ?? '',
                                yValueMapper: (log, _) =>
                                    int.tryParse(log['crowns_won']?.toString() ?? '0'),
                                markerSettings: const MarkerSettings(isVisible: true),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
