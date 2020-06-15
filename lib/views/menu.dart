import 'package:flutter/material.dart';
import 'package:resttutiral/views/view/compilation1_view.dart';
import 'package:resttutiral/views/view/compilation_2_view.dart';
import 'package:resttutiral/views/view/compilation_3_view.dart';

import 'list/category_error_list.dart';
import 'create/error_create.dart';
import 'list/component_list.dart';
import 'list/error_list.dart';
import 'list/project_list.dart';



class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('ListViews')),
        body: BodyLayout(),
    );
  }
}

class BodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }
}

// replace this function with the code in the examples
Widget _myListView(BuildContext context) {
  return ListView(
    children: <Widget>[
      ListTile(
        title: Text('Fehler'),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => ErrorList()));
          }
      ),
      ListTile(
        title: Text('Fehlerkategorien'),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => ErrorCategoryList()));
          }
      ),
      ListTile(
        title: Text('Fehlerursachenkategorien'),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => ErrorCategoryList(mode:"component")));
          }
      ),

      ListTile(
          title: Text('Projekte'),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProjectList()));
          }
      ),
      ListTile(
          title: Text('Komponente'),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => ComponentList()));
          }
      ),

      ListTile(
          title: Text('Zusammenstellung der Fehler nach Projekt / Komponente / Status Fehler (erkannt/beseitigt)'),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => Compilation1View()));
          }
      ),


      ListTile(
          title: Text('Zusammenstellung der beseitigten Fehler nach Projekt / Komponente / Zeitdifferenz Beseitigung - Erkennung'),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => Compilation2View()));
          }
      ),

      ListTile(
          title: Text('Zusammenstellung der Fehler nach Kategorie / Status Fehler (erkannt/beseitigt).'),
          onTap: (){
            print("Hallo");
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => Compilation3View()));
          }
      ),
    ],
  );
}