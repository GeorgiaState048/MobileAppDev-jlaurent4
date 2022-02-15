import 'package:flutter/material.dart';
import './random_words.dart';

void main() => runApp(MyApp()); //MyApp is the root widget

//43:45
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //Material App is a widget that contains a lot of the
        // basic lower level widgets for applicaiton building
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch:
                Colors.purple //use primarySwatch instead of primaryColor
            ),
        home: RandomWords()
        // Scaffold(
        //     appBar: AppBar(title: Text('WordPair Generator')),
        //     body: Center(child: Text(wordPair.asPascalCase))
        );
  }
}
