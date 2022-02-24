import 'dart:async'; // new
import 'package:flutter/material.dart';

import 'src/widgets.dart';
import 'splashscreen.dart';

class PostedMessages1 {
  PostedMessages1({required this.time, required this.message});
  final int time;
  final String message;
}

enum Attending { yes, no, unknown }
enum Role { admin, user }

class PostMessage1 extends StatefulWidget {
  const PostMessage1({required this.addMessage, required this.messages});
  final FutureOr<void> Function(String message) addMessage;
  final List<PostedMessages1> messages; // new

  @override
  _PostMessageState1 createState() => _PostMessageState1();
}

class _PostMessageState1 extends State<PostMessage1> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_PostMessageState');
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.all(8.0)),
      const SizedBox(height: 8),
      for (var message in widget.messages) Paragraph('${message.message}'),
      const SizedBox(height: 8),
    ]);
  }
}
