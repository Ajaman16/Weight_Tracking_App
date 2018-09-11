import 'package:firebase_database/firebase_database.dart';

import '../models/weight_save_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InitAction{}

class UserLoadedAction{
  final FirebaseUser firebaseUser;
  UserLoadedAction(this.firebaseUser);
}

class AddEntryAction{
  final WeightSave weightSave;
  AddEntryAction(this.weightSave);
}

class AddDatabaseReferenceAction {
  final DatabaseReference databaseReference;

  AddDatabaseReferenceAction(this.databaseReference);
}

class OnAddedAction {
  final Event event;

  OnAddedAction(this.event);
}