import 'package:flutter/material.dart';

import '../src/leaderboard.dart';
import '../services/api_service.dart';

class ClansLeaderboardPage extends StatelessWidget {
  const ClansLeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: const Text(
            'Global Clans Leaderboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded( // Moved inside the children list of Column
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchLeaderboard('clansleaderboard'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No data available.'));
              } else {
                return Leaderboard(
                  data: snapshot.data!,
                  sqlCategories: const [
                    'rank',
                    'clanid',
                    'clan_name',
                    'trophies',
                    'location',
                    'members',
                  ],
                  displayCategories: const [
                    'Rank',
                    'Clan Tag',
                    'Clan Name',
                    'Trophies',
                    'Location',
                    'Members',
                  ],
                  detailPageBuilder: (row) => Scaffold(
                    appBar: AppBar(
                      title: Text('${row['clan_name']} Details'),
                    ),
                    body: const Center(
                      child: Text('Test Value'),
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
