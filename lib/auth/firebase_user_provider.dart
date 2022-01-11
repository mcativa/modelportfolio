import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class ModelPortfolioFirebaseUser {
  ModelPortfolioFirebaseUser(this.user);
  User user;
  bool get loggedIn => user != null;
}

ModelPortfolioFirebaseUser currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<ModelPortfolioFirebaseUser> modelPortfolioFirebaseUserStream() =>
    FirebaseAuth.instance
        .authStateChanges()
        .debounce((user) => user == null && !loggedIn
            ? TimerStream(true, const Duration(seconds: 1))
            : Stream.value(user))
        .map<ModelPortfolioFirebaseUser>(
            (user) => currentUser = ModelPortfolioFirebaseUser(user));
