import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DejaView',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent, // Set to transparent to see the gradient
          elevation: 0,
        ),
      ),
      home: ImageSearchScreen(),
    );
  }
}

class ImageSearchScreen extends StatefulWidget {
  @override
  _ImageSearchScreenState createState() => _ImageSearchScreenState();
}

class _ImageSearchScreenState extends State<ImageSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> searchResults = []; // This will hold paths or URLs to matched images
  bool isButtonActive = true;

  // Placeholder function for invoking the Python script
  Future<void> runPythonScript() async {
    // Here you would call your Python script to process images
    print("Running Python script for annotation...");
  }

  // Placeholder function for searching images in the vector database
  Future<void> performSearch(String query) async {
    // Implement the vector database search logic here
    // For now, we just print the query
    print("Performing search for: $query");

    // Mockup: assume we have search results
    setState(() {
      searchResults = [
        'https://via.placeholder.com/150', // Replace with actual image URLs
        'https://via.placeholder.com/150', // Replace with actual image URLs
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend the body behind the app bar to apply gradient
      appBar: AppBar(
        title: Text(
          'DejaView',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 85, 168, 235), Color.fromARGB(255, 98, 17, 212)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 195, 225, 250)!, Color.fromARGB(255, 186, 90, 224)!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: kToolbarHeight + 20),
              ElevatedButton(
                onPressed: isButtonActive
                    ? () async {
                        await runPythonScript();
                        setState(() {
                          isButtonActive = true; // Disable the button after clicking
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color.fromARGB(255, 211, 18, 185), Colors.lightBlue],
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      'Upload my images',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Images',
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search, color: Colors.blueAccent),
                    onPressed: () {
                      performSearch(_searchController.text);
                    },
                  ),
                ),
                onSubmitted: (query) {
                  performSearch(query);
                },
              ),
              SizedBox(height: 20),
              Expanded(
                child: searchResults.isEmpty
                    ? Center(
                        child: Text(
                          'No images found. Please search with a different query.',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            clipBehavior: Clip.antiAlias,
                            elevation: 2,
                            child: Image.network(
                              searchResults[index],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

