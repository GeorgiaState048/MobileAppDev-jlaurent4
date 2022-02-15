import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _randomWordPairs = <WordPair>[];
  final _savedWordPairs = Set<WordPair>();

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('WordPair Generator'),
        ),
        body: _buildList());
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, item) {
        if (item.isOdd) return Divider();

        final index = item ~/ 2; //the number of wordPairs that are in the listview minus the divider widgets

        if (index >= _randomWordPairs.length) { 
          _randomWordPairs.addAll(generateWordPairs().take(10)); //generates ten new wordPairs when scrolled to the bottom
        }

        // when the program first starts, the _randomWordPairs list is empty, but it gets populated
        //  by the previous if statement. The _buildRow function populates each row with 
        //  the already generated wordPair from _randomWordPairs list
        return _buildRow(_randomWordPairs[index]); //pass in what we want each row to have
        // this calls the _buildRow function which populates each row, or tile, of the list with
        // a randomly generated WordPair
      },
    );
  }  

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase, //pair is the paramater that is passed in. 
        style: TextStyle(
          fontSize: 18.0))
    ); 
    // this is just one of the rows of the list
  }
}
