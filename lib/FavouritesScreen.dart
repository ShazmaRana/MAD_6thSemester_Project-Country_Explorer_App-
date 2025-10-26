import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'DetailScreen.dart';



class FavouritesScreen extends StatelessWidget{


const FavouritesScreen({super.key});


@override
  Widget build(BuildContext context) {

final box = Hive.box('favouritesBox');


 return Scaffold(appBar: AppBar(
  leading: const BackButton(
    color: Colors.white,
  ),
  title: Text('Favourites'
 ,style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),
 ),backgroundColor: Colors.blue,

 ),
 

 body: ValueListenableBuilder(
  valueListenable: box.listenable(), 
  builder: (context ,Box box , _){
if(box.isEmpty){
  return const Center(child: Text('No Favourites added Yet!!'));
}



final favourites = box.values.toList();

return ListView.builder(
  
  itemCount: favourites.length,
  itemBuilder:(context , index) {



    final country = favourites[index];








return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(country['flags']['png']),
                    radius: 25,
                  ),
                  title: Text(country['name']['common']),
                  subtitle: Text(
                    'Capital: ${(country['capital'] != null && country['capital'].isNotEmpty) ? country['capital'][0] : 'N/A'}',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(country: country),
                      ),
                    );
                  },
                ),
);

  }

  );

  }


 ),
 );




  }


}