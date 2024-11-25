import 'package:flutter/material.dart';
import '../src/leaderboard.dart';
import '../services/api_service.dart';

class GlobalLeaderboardPage extends StatelessWidget {
  const GlobalLeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title above the leaderboard
        Container(
          padding: const EdgeInsets.all(16.0),
          child: const Text(
            'Current Season Global Leaderboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Global Leaderboard
        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchLeaderboard('playerleaderboard'), // Fetch leaderboard data
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No data available.'));
              } else {
                return Leaderboard(
                  data: snapshot.data!, // Pass the fetched data
                  sqlCategories: const [
                    'rank',
                    'display_name',
                    'id',
                    'trophies',
                    'exp',
                    'clan_name',
                    'clanid',
                  ],
                  displayCategories: const [
                    'Rank',
                    'Display Name',
                    'Player Tag',
                    'Trophies',
                    'Exp Level',
                    'Clan Name',
                    'Clan Tag',
                  ],
                  detailPageBuilder: (row) => Scaffold(
                    appBar: AppBar(
                      title: Text('${row['display_name']} Details'),
                    ),
                    body: Center(
                      child: Text(
                        row.entries
                            .map((entry) =>
                                '${entry.key}: ${entry.value ?? 'N/A'}')
                            .join('\n'),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
