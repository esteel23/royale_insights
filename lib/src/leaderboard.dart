import 'package:flutter/material.dart';

/*
PARAMETERS:
Leaderboard(
  data: <JSON File>,
  sqlCategories: <SQL Category Names Array>;
  displayCategories: <Category Names For User>;
  detailPageBuilder: <Widget Builder For Detaials Page>;
);
*/

class Leaderboard extends StatefulWidget {
  final List<Map<String, dynamic>> data; // JSON data for the leaderboard
  final List<String> sqlCategories; // SQL column names/categories
  final List<String> displayCategories; // User-friendly names for display
  final Widget Function(Map<String, dynamic> row)? detailPageBuilder; // Widget builder for the details page

  const Leaderboard({
    required this.data,
    required this.sqlCategories,
    required this.displayCategories,
    this.detailPageBuilder, // Optional widget for custom row detail display
    super.key,
  });

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  late List<Map<String, dynamic>> _filteredData; // Data filtered by search
  late String _defaultSortKey; // Default sorting key (first SQL category)
  String _searchQuery = ''; // Current search query
  String _searchCategory = ''; // Current search category
  String _numberFilterType = 'Equal'; // Filter type for numeric searches

  final List<String> _numberFilterOptions = ['Greater than', 'Equal', 'Less than'];

  @override
  void initState() {
    super.initState();

    // Set the default sort key (first SQL category)
    _defaultSortKey = widget.sqlCategories.first.toLowerCase();

    // Initialize filtered data with sorted input data
    _filteredData = _sortData(widget.data);

    // Default search category is the first SQL category
    _searchCategory = widget.sqlCategories.first;
  }

  // Sort the data by the default sort key
  List<Map<String, dynamic>> _sortData(List<Map<String, dynamic>> data) {
    List<Map<String, dynamic>> sortedData = List.from(data);
    sortedData.sort((a, b) {
      final aValue = int.tryParse(a[_defaultSortKey]?.toString() ?? '0') ?? 0;
      final bValue = int.tryParse(b[_defaultSortKey]?.toString() ?? '0') ?? 0;
      return aValue.compareTo(bValue);
    });
    return sortedData;
  }

  // Update the search query and filter the leaderboard data
  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query.toLowerCase(); // Case-insensitive search
      _filteredData = widget.data.where((row) {
        // Get the value for the current search category
        final value = row[_searchCategory.toLowerCase()];
        if (value == null) return false;

        // Handle numeric searches
        if (value is int || int.tryParse(value.toString()) != null) {
          final intValue = value is int ? value : int.parse(value.toString());
          if (_numberFilterType == 'Greater than') {
            return intValue > (int.tryParse(query) ?? 0);
          } else if (_numberFilterType == 'Less than') {
            return intValue < (int.tryParse(query) ?? 0);
          } else {
            return intValue == (int.tryParse(query) ?? 0);
          }
        }

        // Handle string searches (exact match)
        return value.toString().toLowerCase() == query;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title
        Container(
          color: Colors.blueAccent,
          padding: const EdgeInsets.all(16.0),
          child: const Text(
            'Leaderboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        // Search Bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Dropdown for selecting the search category
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  value: _searchCategory,
                  items: widget.sqlCategories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(
                        widget.displayCategories[
                            widget.sqlCategories.indexOf(category)],
                      ), // Match display name
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _searchCategory = value!;
                      _searchQuery = ''; // Reset search query
                      _filteredData = widget.data; // Reset filtered data
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Search by',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Dropdown for numeric filter type (if applicable)
              if (_isNumericCategory())
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: _numberFilterType,
                    items: _numberFilterOptions.map((option) {
                      return DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _numberFilterType = value!;
                        _updateSearchQuery(_searchQuery); // Update filter type
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Filter Type',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              const SizedBox(width: 8),

              // Search input field
              Expanded(
                flex: 3,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: _updateSearchQuery,
                  keyboardType: _isNumericCategory()
                      ? TextInputType.number
                      : TextInputType.text,
                ),
              ),
            ],
          ),
        ),

        // Header Row
        Container(
          color: Colors.grey[300],
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: widget.displayCategories
                .map((displayName) => Expanded(
                      child: Text(
                        displayName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ))
                .toList(),
          ),
        ),

        // Data Rows
        Expanded(
          child: _filteredData.isEmpty
              ? const Center(child: Text('No results found')) // Display if no data matches
              : ListView.builder(
                  itemCount: _filteredData.length,
                  itemBuilder: (context, index) {
                    final row = _filteredData[index]; // Current row data
                    final backgroundColor =
                        index.isEven ? Colors.white : Colors.grey[200];
                    Color hoverColor = Colors.blue.withOpacity(0.1);

                    return StatefulBuilder(
                      builder: (context, setHoverState) {
                        bool isHovered = false;

                        return MouseRegion(
                          onEnter: (_) {
                            setHoverState(() => isHovered = true);
                          },
                          onExit: (_) {
                            setHoverState(() => isHovered = false);
                          },
                          child: GestureDetector(
                            onTap: () {
                              if (widget.detailPageBuilder != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        widget.detailPageBuilder!(row),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              color: isHovered ? hoverColor : backgroundColor,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: widget.sqlCategories
                                    .map((sqlCategory) => Expanded(
                                          child: Text(
                                            row[sqlCategory.toLowerCase()]
                                                    ?.toString() ??
                                                'N/A', // Handle null values
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  // Helper function to determine if the selected search category is numeric
  bool _isNumericCategory() {
    return widget.sqlCategories.contains(_searchCategory) &&
        _filteredData.isNotEmpty &&
        int.tryParse(
                _filteredData.first[_searchCategory.toLowerCase()]?.toString() ?? '') !=
            null;
  }
}