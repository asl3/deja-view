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
              color: Colors.black87), // Updated text color for better contrast
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
              Colors.transparent, // Transparent to show the gradient
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

  // Function to run the Python script via the Flask backend
  Future<void> runPythonScript() async {
    print("Running Python script for search...");
    final response = await http.post(
      Uri.parse('http://localhost:8001/get-strings'),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      print('Script Output: ${result['output']}');
    } else {
      print('Failed to run script');
    }
  }

  // Function to simulate a search operation
  Future<void> performSearch(String query) async {
    print("Performing search for: $query");
    await runPythonScript();
    setState(() {
      searchResults = [
        'assets/cat1.jpeg',
        'assets/cat2.jpeg',
      ];
    });
  }

  // Function to handle button click, including loading spinner logic
  void handleButtonClick() async {
    setState(() {
      isLoading = true; // Show loading spinner
    });

    // Simulate a 3-second delay
    await Future.delayed(Duration(seconds: 3));

    setState(() {
      isLoading = false; // Hide loading spinner
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
              Color(0xFFE4F1FE), // Very light blue
              Color(0xFFD3CCE3), // Light lavender/gray
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
                        Color(0xFF6A82FB), // Light purple
                        Color(0xFFFC5C7D), // Light pink
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
                              color: Colors.black87), // Better readability
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

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'DejaView',
//       theme: ThemeData(
//         brightness: Brightness.light,
//         scaffoldBackgroundColor: Colors.white,
//         textTheme: TextTheme(
//           bodyMedium: TextStyle(
//               color: Colors.black87), // Updated text color for better contrast
//         ),
//         inputDecorationTheme: InputDecorationTheme(
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10.0),
//             borderSide: BorderSide(color: Colors.blueAccent),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10.0),
//             borderSide: BorderSide(color: Colors.blue, width: 2.0),
//           ),
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             minimumSize: Size(double.infinity, 50),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             textStyle: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         appBarTheme: AppBarTheme(
//           backgroundColor:
//               Colors.transparent, // Transparent to show the gradient
//           elevation: 0,
//         ),
//       ),
//       home: ImageSearchScreen(),
//     );
//   }
// }

// class ImageSearchScreen extends StatefulWidget {
//   @override
//   _ImageSearchScreenState createState() => _ImageSearchScreenState();
// }

// class _ImageSearchScreenState extends State<ImageSearchScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   List<String> searchResults = [];
//   bool isButtonActive = true;

//   Future<void> runPythonScript() async {
//     print("Running Python script for search...");
//     final response = await http.post(
//       Uri.parse('http://localhost:8001/get-strings'),
//     );

//     if (response.statusCode == 200) {
//       final result = jsonDecode(response.body);
//       print('Script Output: ${result['output']}');
//     } else {
//       print('Failed to run script');
//     }
//   }

//   Future<void> performSearch(String query) async {
//     print("Performing search for: $query");
//     await runPythonScript();
//     setState(() {
//       searchResults = [
//         'assets/cat1.jpeg',
//         'assets/cat2.jpeg',
//       ];
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         title: Text(
//           'DejaView',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         centerTitle: true,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color(0xFF74B9FF), // Light blue
//                 Color(0xFFA29BFE), // Soft lavender
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color(0xFFE4F1FE), // Very light blue
//               Color(0xFFD3CCE3), // Light lavender/gray
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: kToolbarHeight + 20),
//               ElevatedButton(
//                 onPressed: isButtonActive
//                     ? () async {
//                         // await runPythonScript();
//                         setState(() {
//                           isButtonActive =
//                               false; // Disable the button after clicking
//                         });
//                       }
//                     : null,
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.all(0),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                 ),
//                 child: Ink(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Color(0xFF6A82FB), // Light purple
//                         Color(0xFFFC5C7D), // Light pink
//                       ],
//                     ),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: Container(
//                     height: 50,
//                     alignment: Alignment.center,
//                     child: Text(
//                       'Upload my images',
//                       style: TextStyle(
//                           color: Colors.white, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               TextField(
//                 controller: _searchController,
//                 decoration: InputDecoration(
//                   labelText: 'Search Images',
//                   labelStyle: TextStyle(color: Colors.blueGrey),
//                   suffixIcon: IconButton(
//                     icon: Icon(Icons.search, color: Colors.blueAccent),
//                     onPressed: () {
//                       performSearch(_searchController.text);
//                     },
//                   ),
//                 ),
//                 onSubmitted: (query) {
//                   print("Upload images");
//                 },
//               ),
//               SizedBox(height: 20),
//               Expanded(
//                 child: searchResults.isEmpty
//                     ? Center(
//                         child: Text(
//                           'No images found. Please search with a different query.',
//                           style: TextStyle(
//                               color: Colors.black87), // Better readability
//                         ),
//                       )
//                     : GridView.builder(
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 3,
//                           crossAxisSpacing: 8.0,
//                           mainAxisSpacing: 8.0,
//                         ),
//                         itemCount: searchResults.length,
//                         itemBuilder: (context, index) {
//                           return Card(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                             ),
//                             clipBehavior: Clip.antiAlias,
//                             elevation: 2,
//                             child: Image.asset(
//                               searchResults[index],
//                               fit: BoxFit.cover,
//                             ),
//                           );
//                         },
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
