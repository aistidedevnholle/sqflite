import 'package:dark_side/person.dart';
import 'package:dark_side/sqflitebd.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DarkSide',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: DisplayPerson(),
    );
  }
}


class DisplayPerson extends StatefulWidget {
  @override
  _DisplayPersonState createState() => _DisplayPersonState();
}

class _DisplayPersonState extends State<DisplayPerson> {

  String newPerson;
  List<Person> persons = [];
  TextEditingController personCrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    retrievePersons();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SqfLite BD'),
      ),

      body: persons.isEmpty ?
      Center(
        child: Text('Aucune persone'),
      ) : ListView.builder(
        itemCount: persons.length,
        itemBuilder: (context, i){
          Person person = persons[i];

          return ListTile(
            leading: IconButton(icon: Icon(Icons.edit),
                onPressed: (){
                 return updatePerson(
                   person: person,
                     oldPerson: persons[i].name);
                }),
            title: Text(person.name),
            trailing: IconButton(icon: Icon(Icons.delete),
                onPressed: (){
              SqfLiteBd().deletePerson(person.id, 'person')
              .then((value) => retrievePersons());
            }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          return addPerson();
        },
        child: Icon(Icons.add),
      ),
    );
  }


  //AJOUTER UNE PERSON
  addPerson(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Ajouter'),
        content: TextField(
          decoration: InputDecoration(
            labelText: "Add",
            hintText: "ex: AriDev",
          ),
          onChanged: (String str){
            setState(() {
              newPerson = str;
            });
          },
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          },
              child: Text('Annuler')),

          TextButton(onPressed: (){
            Map<String, dynamic> map = {'name' : newPerson};
            Person person = Person();
            person.fromMap(map);
            SqfLiteBd().ajouter(person).
            then((p) {
              //UPDATE BD
              retrievePersons();
            });
            Navigator.pop(context);
            newPerson = null;
          },
              child: Text('Ajouter'))
        ],
      );
    });
  }

  //MISE A JOUR
  updatePerson({String oldPerson, Person person}){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Ajouter'),
        content: TextField(
          controller: personCrl..text = oldPerson,
          decoration: InputDecoration(
            labelText: "Add",
            hintText: "ex: AriDev",
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          },
              child: Text('Annuler')),

          TextButton(onPressed: (){
           person.name = personCrl.text;
           SqfLiteBd().update(person).
           then((p) {
             //UPDATE BD
             retrievePersons();
           });
            Navigator.pop(context);
          },
              child: Text('Modifier'))
        ],
      );
    });
  }

  //RECUPERER TOUTES LES PERSON
  void retrievePersons(){
    SqfLiteBd().allPerson().then((persons) => {
      setState((){
        this.persons = persons;
      })
    });
  }


  //FAIRE UN CHECKBOX PLUS SIMPLEMT

  Map list  = {
    "ORANGE": false,
    "FLUTTER": false,
  };
  List<Widget> checkBoxList(){
    List<Widget> checkBoxs = [];
    list.forEach((key, value) {
      Row checkBox = new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(key),
          Checkbox(value: value, onChanged: (bool b){
            setState(() {
              list[key]= b;
            });
          })
        ],
      );
      checkBoxs.add(checkBox);
    });
    return checkBoxs;
  }
}

