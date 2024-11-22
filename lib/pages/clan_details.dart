// clan_details_page.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ClanDetailsPage extends StatefulWidget {
  final String clanId;
  final String clanLabel;

  const ClanDetailsPage({super.key, required this.clanId, required this.clanLabel});

  @override
  _ClanDetailsPageState createState() => _ClanDetailsPageState();
}

class _ClanDetailsPageState extends State<ClanDetailsPage> {
  List<dynamic> _clanMembers = [];

  @override
  void initState() {
    super.initState();
    _fetchClanMembers();
  }

  Future<void> _fetchClanMembers() async {
    final data = await fetchClanMembers(widget.clanId);
    setState(() {
      _clanMembers = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.clanLabel} Members'),
      ),
      body: _clanMembers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _clanMembers.length,
              itemBuilder: (context, index) {
                final player = _clanMembers[index];
                return ListTile(
                  title: Text(player['username']),
                subtitle: Text('Trophies: ${player['score'] ?? 'N/A'}'),
trailing: Text('ID: ${player['id'] ?? 'N/A'}'),
                );
              },
            ),
    );
  }
}
