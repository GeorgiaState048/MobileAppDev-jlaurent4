import 'dart:async'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'src/authentication.dart';
import 'guestbook.dart';
import 'user_guestbook.dart';
import 'dart:math';

class ApplicationState extends ChangeNotifier {
  //change notifier notifies the application when the user login state has changed
  ApplicationState() {
    init();
  }

  Future<void> init() async {
    //initializes Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseAuth.instance.userChanges().listen((user) {
      //listener to check login state
      if (user != null) {
        //_loginState = ApplicationLoginState.loggedIn;
        FirebaseFirestore
            .instance //queries all the documents in the 'attendees' collection where the 'attending' value is true
            .collection('users')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots()
            .listen((snapshot) {
          for (final document in snapshot.docs) {
            _roles = document.data()['role'] as String;
          }
          if (_roles == 'admin') {
            _loginState = ApplicationLoginState.Admin;
          } else if (_roles == 'customer') {
            _loginState = ApplicationLoginState.loggedIn;
          }
          //returns length of documents that were queried.
          notifyListeners();
        });
        _administrationMessage = FirebaseFirestore
            .instance //addds listenere when logged in
            .collection('Messages')
            .orderBy('timestamp', descending: true)
            .limit(100) //shows the two most recent documents in the Firebase
            .snapshots()
            .listen((snapshot) {
          //listens to any updates to snapshot, which is 'guestbook' contents
          _adminMessages = [];
          _adminMessages1 = [];
          for (final document in snapshot.docs) {
            //snapshot.docs() is a list of maps where each map contains a document in 'guestbook' along with the other key value pairs that were added to it.
            print("I have data");
            _adminMessages.add(
              PostedMessages(
                time: document.data()['timestamp']
                    as int, //each map (in this example) has the following keys: 'text' 'timestamp' 'name' 'userId'
                message: document.data()['text'] as String, //231 - 234
              ),
            );
            _adminMessages1.add(
              PostedMessages1(
                time: document.data()['timestamp']
                    as int, //each map (in this example) has the following keys: 'text' 'timestamp' 'name' 'userId'
                message: document.data()['text'] as String,
              ),
            );
          }
          notifyListeners();
        });
      } else {
        _loginState = ApplicationLoginState.loggedOut;
        _adminMessages = [];
        _administrationMessage?.cancel(); // removes listener when logged out
      }
      notifyListeners(); //notifies to let user know information about login state so the app can change accordingly
    });
  }

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  StreamSubscription<QuerySnapshot>?
      _administrationMessage; //reference to real time listenere so messages can be displayed on app without reload
  List<PostedMessages> _adminMessages = [];
  List<PostedMessages> get theAdminMessages => _adminMessages;

  StreamSubscription<QuerySnapshot>? _administrationMessage1;
  List<PostedMessages1> _adminMessages1 = [];
  List<PostedMessages1> get theAdminMessages1 => _adminMessages1;

  String _roles = "";
  String get role => _roles;
  StreamSubscription<DocumentSnapshot>? _theRole;

  String? _email;
  String? get email => _email;

  void startLoginFlow() {
    _loginState = ApplicationLoginState
        .emailAddress; //change users login state and notify listeners
    notifyListeners();
  }

  Future<void> verifyEmail(
    //takes in an email and check to see if there are already any authenticated emails associated with
    String email,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      var methods = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(email); //checks if the email can sign in
      if (methods.contains('password')) {
        //password method is required for sign in. if it is not present then a new account is being created and the user must be told to register
        _loginState = ApplicationLoginState.password;
      } else {
        _loginState = ApplicationLoginState.register;
      }
      _email = email;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  Future<void> signInWithEmailAndPassword(
    //login with email and password
    String email,
    String password,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        // Firebase function
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void cancelRegistration() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  Future<DocumentReference> registerAccount(
      String email,
      String displayName,
      String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email,
              password: password); //Firebase function to create an account
      await credential.user!.updateDisplayName(displayName);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
    return FirebaseFirestore
        .instance //creates new document in collection called 'guestbook'
        .collection('users')
        .add(<String, dynamic>{
      // the added document will consist of the following key value pairs:
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'email': email,
      'password': password,
      'role': 'customer',
      'First and Last Name': displayName,
    });
  }

  Future<DocumentReference> addMessageToGuestBook(String message) {
    //logic to write a documnet
    if (_loginState != ApplicationLoginState.Admin) {
      throw Exception('Only Admins can write messages!');
    }
    var rng = Random();

    return FirebaseFirestore
        .instance //creates new document in collection called 'guestbook'
        .collection('Messages')
        .add(<String, dynamic>{
      // the added document will consist of the following key value pairs:
      'text': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'uniqueId': rng.nextInt(100000),
    });
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
