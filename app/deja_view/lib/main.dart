import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
          bodyMedium: TextStyle(
              color: Colors.black87),
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
          backgroundColor:
              Colors.transparent,
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
  List<String> searchResults = [];
  bool isLoading = false;

  Future<List<String>> runPythonScript(String query) async {
    print("Running Python script for search...");
    final response = await http.get(
      Uri.parse('http://127.0.0.1:5000/search?prompt=$query'),
    );
    print(response);
    if (response.statusCode == 200) {
      // final result = jsonDecode(response.body);
      // print(result);
      // print(result);
      // // Convert List<dynamic> to List<String>
      // // List<String> updatedResult = result.map((item) => item.toString()).toList();

      // // Prepend "assets/" to each element
      // updatedResult = result.map((item) => 'assets/$item').toList();
      // print(updatedResult.runtimeType);
      // Parse the response body as a List<dynamic>
      final List<dynamic> data = jsonDecode(response.body);

      // Convert List<dynamic> to List<String>
      List<String> result = data.map((item) => item.toString()).toList();

      // Print the extracted list of strings
      print(result);
      return result;
      // return updatedResult;
    } else {
      print('Failed to run script');
      return [];
    }
  }

  Future<void> performSearch(String query) async {
    print("Performing search for: $query");
    final images = await runPythonScript(query);
    print(images);
    setState(() {
      // searchResults = [
      //   'assets/cat1.jpeg',
      //   'assets/cat2.jpeg',
      //   'assets/cat3.jpeg',
      //   'assets/dog1.jpeg',
      //   'assets/dog2.jpeg',
      //   'assets/hotdog1.jpeg',
      //   'assets/hotdog2.jpeg',
      //   'assets/hotdog3.jpeg',
      //   'assets/hotdog4.jpeg',
      //   'assets/justin1.jpeg',
      //   'assets/justin2.jpeg',
      //   'assets/justin3.jpeg',
      //   'assets/justin4.jpeg',
      //   'assets/justin5.jpeg',
      //   'assets/justin6.jpeg',
      //   'assets/justin7.jpeg',
      // ];
      searchResults = images;
    });
    
  }

  void handleButtonClick() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(Duration(seconds: 3));

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'DejaView',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF74B9FF), // Light blue
                Color(0xFFA29BFE), // Soft lavender
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE4F1FE),
              Color(0xFFD3CCE3),
            ],
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
                onPressed: handleButtonClick,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF6A82FB),
                        Color(0xFFFC5C7D),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: isLoading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(
                            'Upload my images',
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
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
                          style: TextStyle(
                              color: Colors.black87),
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
                            child: Image.asset(
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
