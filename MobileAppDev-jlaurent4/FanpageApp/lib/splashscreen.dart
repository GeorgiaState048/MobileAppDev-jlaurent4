import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 

import 'src/widgets.dart';
import 'src/authentication.dart';
import 'app_state.dart';
import 'guestbook.dart';
import 'user_guestbook.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fanpage App'),
      ),
      body: ListView(
        children: <Widget>[
          Image.asset('assets/unnamed1.png'),
          // const SizedBox(height: 8),
          // const IconAndDetail(Icons.calendar_today, 'February 22'),
          // const IconAndDetail(Icons.location_city, 'Atlanta, GA'),
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Authentication(
              email: appState.email,
              loginState: appState.loginState,
              startLoginFlow: appState.startLoginFlow,
              verifyEmail: appState.verifyEmail,
              signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
              cancelRegistration: appState.cancelRegistration,
              registerAccount: appState.registerAccount,
              signOut: appState.signOut,
            ),
          ),
          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          const Header("Welcome to the Fanpage App"),
          const Paragraph(
            'Make Sure you Sign in!',
          ),
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (appState.loginState == ApplicationLoginState.Admin) ...[            
                  const Header('Admin Messages'),
                  const Text('Click the + to add a message!'),
                  const Text('Scroll down to see other messages!'),
                  PostMessage(
                    addMessage: (message) =>
                        appState.addMessageToGuestBook(message),
                    messages: appState.theAdminMessages, // new
                  ),
                ],
                if (appState.loginState == ApplicationLoginState.loggedIn) ...[
                  const Header('Admin Messages'),
                  const Text('Scroll down to see other messages!'),
                  PostMessage1(
                    addMessage: (message) =>
                        appState.addMessageToGuestBook(message),
                    messages: appState.theAdminMessages1,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
