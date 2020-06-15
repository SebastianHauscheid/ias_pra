import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:resttutiral/services/notes_service.dart';
import 'package:resttutiral/views/log_in.dart';
import 'file:///C:/Users/Win10/AndroidStudioProjects/ias_2020_p/lib/views/list/error_list.dart';
import 'package:resttutiral/views/menu.dart';


import 'models/user_model.dart';

void setupLocator(){
  GetIt.instance.registerLazySingleton(() => NotesService());
  //GetIt.instance<NotesService>();
}

void main() {
  //UserModel.userName = "Sebastian";
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Colors.amber),
      home: Login(),//ErrorList(),
    );
  }
}



