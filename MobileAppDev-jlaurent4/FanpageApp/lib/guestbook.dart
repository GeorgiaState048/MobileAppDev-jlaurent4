import 'dart:async'; 
import 'package:flutter/material.dart';

import 'src/widgets.dart';
import 'splashscreen.dart';

class PostedMessages {
  PostedMessages({required this.time, required this.message});
  final int time;
  final String message;
}

enum Attending { yes, no, unknown }
enum Role { admin, user }

class PostMessage extends StatefulWidget {
  const PostMessage({required this.addMessage, required this.messages});
  final FutureOr<void> Function(String message) addMessage;
  final List<PostedMessages> messages; // new

  @override
  _PostMessageState createState() => _PostMessageState();
}

class _PostMessageState extends State<PostMessage> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_PostMessageState');
  final _controller = TextEditingController();

  void inputMessage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return new Scaffold(
          body: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // to here.
          FloatingActionButton(
            child: Text("X"),
            onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SplashScreen(),
                ));
          }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Leave a message',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your message to continue';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 6),
                  StyledButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await widget.addMessage(_controller.text);
                        _controller.clear();
                      }
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.send),
                        SizedBox(width: 6),
                        Text('POST MESSAGE'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ));
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.all(8.0)),
      FloatingActionButton(
          child: Text('+'),
          onPressed: () {
            inputMessage();
          }),
      const SizedBox(height: 8),
      for (var message in widget.messages)
        Paragraph('${message.message}'),
      const SizedBox(height: 8),
    ]);
  }
}
