import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> searchResults = []; // This will hold paths or URLs to matched images

  // Placeholder function for searching images in the vector database
  Future<void> performSearch(String query) async {
    // Implement the vector database search logic here
    // For now, we just print the query
    print("Performing search for: $query");

    // Mockup: assume we have search results
    setState(() {
      searchResults = [
        'path_to_image_1.jpg',
        'path_to_image_2.jpg',
        // Add more image paths or URLs as necessary
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Images',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    performSearch(_searchController.text);
                  },
                ),
              ),
              onSubmitted: (query) {
                performSearch(query);
              },
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    searchResults[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
