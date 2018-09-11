import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import '../models/weight_save_model.dart';
import 'actions.dart';
export 'actions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

@immutable
class ReduxListState{

  final FirebaseUser firebaseUser;
  final List<WeightSave> list;
  final DatabaseReference databaseReference;

  ReduxListState({this.list, this.firebaseUser, this.databaseReference});

  ReduxListState copyWith({List<WeightSave> entry, FirebaseUser user, DatabaseReference dataRef}){
    return ReduxListState(
      list: entry ?? this.list,
      firebaseUser: user ?? this.firebaseUser,
      databaseReference: dataRef ?? this.databaseReference
    );
  }

}

firebaseMiddleware(Store<ReduxListState> store, action, NextDispatcher next){

  if(action is InitAction){
    if(store.state.firebaseUser == null){
      FirebaseAuth.instance.currentUser().then((user){
        if(user != null){
          store.dispatch(UserLoadedAction(user));
        }
        else
          {
            FirebaseAuth.instance.signInAnonymously().then((userr){
               store.dispatch(UserLoadedAction(userr));
            });
          }
      });
    }
  }
  else if(action is AddEntryAction)
    {
      store.state.databaseReference.push().set(action.weightSave.toJSON());
    }
  next(action);

  if (action is UserLoadedAction) {
    store.dispatch(new AddDatabaseReferenceAction(FirebaseDatabase.instance
        .reference()
        .child(store.state.firebaseUser.uid)
        .child("entries")
      ..onChildAdded
          .listen((event) => store.dispatch(new OnAddedAction(event)))));
  }
}

ReduxListState stateReducer(ReduxListState state, action){

  if (action is AddDatabaseReferenceAction) {
    return state.copyWith(dataRef: action.databaseReference);
  } else if (action is OnAddedAction) {
    return _onEntryAdded(state, action.event);
  }
  else if(action is UserLoadedAction){
    return state.copyWith(user: action.firebaseUser);
  }
  else if(action is AddEntryAction){
    return state.copyWith(
        entry: <WeightSave>[]
                ..addAll(state.list)
                ..add(action.weightSave)
    );
  }

  return state;
}