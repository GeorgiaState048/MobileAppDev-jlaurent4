// import 'package:flutter/material.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Welcome to Flutter',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Welcome to Flutter'),
//         ),
//         body: Center(
//           child: Text('Hello World'),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class ExamplePage extends StatelessWidget {
  const ExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blue,
        child: ListView.builder(
            //itemCount: 10,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Card(child: Text('$index'));
            }));
  }
}
