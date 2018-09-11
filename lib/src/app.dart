import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker_app/src/screens/home.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'logic/redux_core.dart';

class App extends StatelessWidget {

  final Store<ReduxListState> store = Store(
      stateReducer,
      initialState: ReduxListState(list: List(), firebaseUser: null),
      middleware: [firebaseMiddleware].toList()
  );

  @override
  Widget build(BuildContext context) {

    //FirebaseDatabase.instance.setPersistenceEnabled(true);

    store.dispatch(InitAction());

    return MaterialApp(
      title: "Weight Tracker",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: StoreProvider(
          store: store,
          child: Home()
      ),
    );
  }
}
