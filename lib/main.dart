import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'DetailScreen.dart';
import 'FavouritesScreen.dart';
import 'AboutScreen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('favouritesBox'); // ✅ consistent spelling

runApp(const MaterialApp(
  debugShowCheckedModeBanner: false,
  home: SplashScreen(),
));

}

class MainApp extends StatelessWidget {
  const MainApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();




static const List<Widget> _widgetOptions = <Widget>[
Center ( child: Text('Countries')),
Center(child: Text('Favourites')),
Center(child: Text('About'))
];
int _currentindex =0;

void _OnItemTapped(int index){
  setState(() {
    _currentindex = index;
  });
}


  List<dynamic> allCountries = [];
  List<dynamic> filteredCountries = [];
  late Box favouritesBox;

  @override
  void initState() {
    super.initState();
    favouritesBox = Hive.box('favouritesBox');
    fetchCountries();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ✅ Use country name as key instead of full map
  bool isFavourite(dynamic country) {
    final box = Hive.box('favouritesBox');
    return box.containsKey(country['name']['common']);
  }

  void toggleFavourite(dynamic country) {
    setState(() {

      final box = Hive.box('favouritesBox');
final countryName = country['name']['common'];

      if (box.containsKey(countryName)) {
        box.delete(countryName);
        favouritesBox.delete(countryName);
      } else {
        favouritesBox.put(countryName, country);
      }
    });
  }

  Future<void> fetchCountries() async {
    final response = await http.get(
      Uri.parse(
        'https://restcountries.com/v3.1/all?fields=name,capital,flags,population,region',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        allCountries = data;
        filteredCountries = allCountries;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void filterSearch(String query) {
    List<dynamic> results = [];

    if (query.isEmpty) {
      results = allCountries;
    } else {
      results = allCountries.where((country) {
        final name = country['name']['common'].toString().toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
    }

    setState(() {
      filteredCountries = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Country Explorer',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body:Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.white,
              margin: const EdgeInsets.all(8.0),
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: filterSearch,
                decoration: const InputDecoration(
                  hintText: 'Search For a Country...',
                  border: UnderlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredCountries.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredCountries.length,
                    itemBuilder: (context, index) {
                      final country = filteredCountries[index];
                      final name = country['name']['common']; // ✅ Key
                      final flagUrl = country['flags']['png'] ??
                          'https://via.placeholder.com/150';

                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.all(8.0),
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailScreen(country: country),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(flagUrl),
                          ),
                          title: Text(name),
                          subtitle: Text(
                            'Capital: ${(country['capital'] != null && country['capital'].isNotEmpty) ? country['capital'][0] : 'N/A'}\n'
                            'Region: ${country['region']}',
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              isFavourite(country)
                                  ? Icons.star
                                  : Icons.star_border,
                              color:
                                  isFavourite(country) ? Colors.amber : null,
                            ),
                            onPressed: () {
                              toggleFavourite(country);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),


    
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentindex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index){
          setState(() {
            _currentindex = index;
          });
if(index == 1){
  Navigator.push(context,
  MaterialPageRoute(builder:(context) => FavouritesScreen()),
  );
}
else if(index == 2){
  Navigator.push(context, 
  MaterialPageRoute(builder: ((context)=> AboutScreen())));
}
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: 
          Icon(Icons.language ,),
          label: 'Countries'
          ),

          BottomNavigationBarItem(icon: Icon(Icons.favorite_border_outlined
          ),
          label: 'Favourites'),

          BottomNavigationBarItem(icon: Icon(Icons.help_outline),
          label: 'About')
        ],
      ),
      
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.star, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FavouritesScreen()),
          );
        },
      ),
    );
  }
}
