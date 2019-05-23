import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {  
                      
                   @override            
               Widget build(BuildContext context) {            
                    //   final wordPair = WordPair.random();     
                   return MaterialApp(     
                     title: "RandomWords",  
                     home: RandomWords(),   );
               }
}



class RandomWords extends StatefulWidget{
  Randomwordstate createState()=>Randomwordstate();
}  



class Randomwordstate extends State<RandomWords> {
  final _suggetions=<WordPair>[];
  final Set<WordPair> _saved = Set<WordPair>();   
  String itemsremove='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text('Startup Name Generator'),
      actions: <Widget>[     
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],                      
    ),
    body: _buildSuggestions(),
  );
  }

   Widget _buildSuggestions() {
  return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder:(context, i) {
        if (i.isOdd) return Divider(); 

        final index = i ~/ 2; 
        if (index >= _suggetions.length) {
          _suggetions.addAll(generateWordPairs().take(10)); 
        }
        return _buildRow(_suggetions[index]);
      });
}

Widget _buildRow(WordPair pair) {
  
  final bool alreadySaved = _saved.contains(pair);  
  return ListTile(
    title: Text(
      pair.asPascalCase,
      
    ),
    trailing: Icon(   
      alreadySaved ? Icons.favorite : Icons.favorite_border,
      color: alreadySaved ? Colors.red : null,
    ), 
        onTap: () {     
      setState(() {
        if (alreadySaved) {
          _saved.remove(pair);
        } else { 
          _saved.add(pair); 
        } 
      });
    },                        
    
  );
}

  void _pushSaved() {
  Navigator.of(context).push(
    MaterialPageRoute<void>(   
      builder: (BuildContext context) {
        final Iterable<Dismissible> tiles = _saved.map(
          (WordPair pair) {
            
            return Dismissible(
                   key:Key("$pair") ,
                  onDismissed:(direction){
                    setState(() {
                     _saved.remove("$pair");
                     itemsremove=itemsremove+pair.toString();
                    });
                    
                  },
                  child: ListTile(title: Text("$pair")),

            );
           
          },
        );
        final List<Widget> divided = ListTile
          .divideTiles(
            context: context,
            tiles: tiles,
          )
          .toList();
          return Scaffold(         
          appBar: AppBar(
            title: Text('Saved Suggestions'),
            actions: <Widget>[
              FlatButton(
                child: Text("Back"),
                onPressed: (){
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Text("Items Removed"),
                        content:Text("$itemsremove")
                      
                      );
                    }


                  );
                  
                },
              )
            ],
          ),
          body: new ListView(
            children:divided),
        );                       
      },
    ),                      
  );
}


  



}
                                      