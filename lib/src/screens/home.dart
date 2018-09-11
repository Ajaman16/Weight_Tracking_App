import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../widget/weight_list_tile.dart';
import '../models/weight_save_model.dart';
import 'add_entry_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../logic/redux_core.dart';

final mainReference = FirebaseDatabase.instance.reference();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

@immutable
class HomeViewModel{

  final List<WeightSave> list;
  final Function(WeightSave) addEntryCallback;
  final Function(WeightSave) editEntryCallback;

  HomeViewModel({this.list, this.addEntryCallback, this.editEntryCallback});
}

class _HomeState extends State<Home> {

  List<WeightSave> list = List<WeightSave>();

  _HomeState(){
    mainReference.child("users/user_1").onChildAdded.listen(_onDataAdded);
    mainReference.child("users/user_1").onChildChanged.listen(_onDataEdited);
  }

  _onDataAdded(Event event){
    setState(() {
      list.add(WeightSave.fromSnapshot(event.snapshot));
    });
  }

  _onDataEdited(Event event){

    WeightSave wv = list.singleWhere((wv){
      return wv.key == event.snapshot.key;
    });

    setState(() {
      list[list.indexOf(wv)] = WeightSave.fromSnapshot(event.snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {

    return StoreConnector<ReduxListState, HomeViewModel>(
      converter: (store) => HomeViewModel(
        list: store.state.list,
        addEntryCallback: (entry) => store.dispatch(AddEntryAction(entry)),
        editEntryCallback: (entry) => store.dispatch(AddEntryAction(entry)),
      ),
      builder: (context, viewModel){
        return Scaffold(
          appBar: AppBar(
            title: Text("Weight Tracker"),
          ),
          body: buildBody(viewModel),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _openEntryDialog(null, viewModel.addEntryCallback),
            child: Icon(Icons.add),
            tooltip: "Add Weight",
          ),
        );
      },
    );


  }

  Widget buildBody(HomeViewModel viewModel) {

    return ListView.builder(
        itemCount: viewModel.list.length,
        itemBuilder: (context, index){

          double weightDiff = index == 0 ? 0.0 : (viewModel.list[index].weight - viewModel.list[index-1].weight);

          return GestureDetector(
            onTap: () => _openEntryDialog(viewModel.list[index], viewModel.editEntryCallback),
            child: WeightListTile(
              weightSave: viewModel.list[index],
              weightDiff: weightDiff,
            ),
          );

        }
    );

  }

  /*void addWeights(WeightSave weightSave) {
    setState(() {
      list.add(weightSave);
    });
  }*/

  Future _openEntryDialog(WeightSave wv, Function(WeightSave) onSubmittedCallback)async {

    WeightSave weightSave = await Navigator.of(context).push(
        MaterialPageRoute<WeightSave>(
          builder: (BuildContext context){
            return AddEntryDialog(weightSave: wv);
          },
          fullscreenDialog: true
      )
    );

    if(weightSave != null)
      {
        //addWeights(weightSave);
        //print(weightSave.toJSON());

        if(weightSave.key == null){
          onSubmittedCallback(weightSave);
          mainReference.child("users/user_1").push().set(weightSave.toJSON());
        }
        else{
          onSubmittedCallback(weightSave);
          mainReference.child("users/user_1/${weightSave.key}").set(weightSave.toJSON());
        }

      }
  }
}

