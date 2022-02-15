import 'package:flutter/material.dart';

class ExamplePage extends StatelessWidget {
  const ExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.orange,
        child: ListView.builder(
            //itemCount: 10,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Card(child: Text('$index'));
            }));
  }
}
