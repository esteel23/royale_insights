import 'package:flutter/material.dart';
import 'player_details.dart'; // Import the PlayerDetailsPage class
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
                  detailPageBuilder: (row) => PlayerDetailsPage(
                    playerTag: row['id'],
                    displayName: row['display_name'] ?? 'Unknown',
                    row: row,
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
//const CLASH_ROYALE_API_KEY = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6ImI4MTY5ZDJhLWYzNDctNGE0My1iYmVjLWEwZjA5ZmRlNDgwMSIsImlhdCI6MTczMDEzMjgyMSwic3ViIjoiZGV2ZWxvcGVyL2MwNDNlZjY2LTRjNWQtNTA0YS04NGUxLTY3ZWI1MjA1ODQyMSIsInNjb3BlcyI6WyJyb3lhbGUiXSwibGltaXRzIjpbeyJ0aWVyIjoiZGV2ZWxvcGVyL3NpbHZlciIsInR5cGUiOiJ0aHJvdHRsaW5nIn0seyJjaWRycyI6WyIzNC4xNjIuMTIxLjUzIl0sInR5cGUiOiJjbGllbnQifV19.4MEkTRPwv8pw7o_zzhR4wtJHIP5aUxEfJEdcdG8A96dM0srQGSHppRgjTQIwYkLOqEShvlQePyX4XheSg9ef3Q';