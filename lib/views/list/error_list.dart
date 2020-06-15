
import 'package:flutter/material.dart';
import 'package:resttutiral/models/api_response.dart';
import 'package:resttutiral/models/error_model.dart';
import 'package:resttutiral/models/user_model.dart';
import 'package:resttutiral/services/notes_service.dart';
import 'package:resttutiral/views/note_delete.dart';

import 'package:get_it/get_it.dart';

import '../create/error_create.dart';
import '../modify/error_modify.dart';
import '../view/error_view.dart';
import '../menu.dart';



class ErrorList extends StatefulWidget {

  @override
  _ErrorListState createState() => _ErrorListState();
}

Color  getColor(String status){
  switch(status) {
    case 'beseitigt': {
      return Colors.green;
    }
    break;

    case 'erkannt': {
      return Colors.black;
    }
    break;

    default: {
      return Colors.yellow;
    }
  }
}
IconData getIconForName(String iconName) {
  switch(iconName) {
    case 'beseitigt': {
      return Icons.check;
    }
    break;

    case 'erkannt': {
      return Icons.access_alarm;
    }
    break;

    default: {
      return Icons.favorite_border;
    }
  }
}



class _ErrorListState extends State<ErrorList> {
  NotesService get service => GetIt.I<NotesService>();
  APIResponse<List<ErrorModel>> _apiResponse;
  bool _isLoading = false;

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}.${dateTime.month}.${dateTime.year}';
  }



  @override
  void initState() {
    _fetchNotes();
    super.initState();
  }

  _fetchNotes()async{
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getErrorList();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('List of Errors'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.list),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => (  Menu() ))) .then((_) {
                  _fetchNotes();
                });
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => ErrorCreate()))
                .then((_) {
              _fetchNotes();
            });
          },
          child: Icon(Icons.add),
        ),
        body: Builder(
          builder: (_) {
            if (_isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (_apiResponse.error) {
              return Center(child: Text(_apiResponse.errorMessage));
            }

            return ListView.separated(

              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Colors.green),
              itemBuilder: (_, index) {
                return Dismissible(
                  key: ValueKey(_apiResponse.data[index].id),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {},
                  confirmDismiss: (direction) async {
                    final result = await showDialog(
                        context: context, builder: (_) => NoteDelete());
                    print(result);
                    if(result)
                    {
                      final deleteResult = await service.deleteError(_apiResponse.data[index].id);
                      var message;
                      if (deleteResult != null && deleteResult.data == true) {
                        message = 'The note was deleted successfully';
                      } else {
                        message = deleteResult?.errorMessage ?? 'An error occured';
                      }

                    }

                    return result;
                  },
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.only(left: 16),
                    child: Align(
                      child: Icon(Icons.delete, color: Colors.white),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  child: ListTile(

                    title: Text(
                      _apiResponse.data[index].key,
                      style: TextStyle(color: Colors.black),

                    ),
                      trailing:Icon(
                          getIconForName(_apiResponse.data[index].status)
                          , color:getColor(_apiResponse.data[index].status)
                      ),
                    subtitle: Text(
                        'Last edited on ${formatDateTime(_apiResponse.data[index].sw_datum ?? _apiResponse.data[index].sw_datum)}'),
                    onTap: () {

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ( UserModel.isSw ? ErrorModify(noteID: _apiResponse.data[index].id):
                          ErrorView(noteID: _apiResponse.data[index].id) ))) .then((_) {
                        _fetchNotes();
                      });
                    },
                  ),
                );
              },
              itemCount: _apiResponse.data.length,
            );
          },
        ));
  }
}