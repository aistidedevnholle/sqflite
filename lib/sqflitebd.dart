//SOTOCKER DES DONNEES PLUS COMMPLEXE DANS UN TABLE
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:dark_side/person.dart';


class SqfLiteBd {

  //ON CREER NOTRE BD DE FACON PRIVATE

  Database _database;

  //RECUPERER NOTRE DB
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      //ON CREER NOTRE DB
      _database = await createDb();

      return _database;
    }
  }

  Future createDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    //CHEMIN :directory.path dossiers de docs
    String dbDir = join(directory.path, 'database.db');
    var bdd = await openDatabase(dbDir, version: 1, onCreate: onCreate);

    return bdd;
  }

  Future onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE person (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL)
    ''');
  }

  //AJOUTER UNE PERSONE
  Future<Person> ajouter(Person person) async {
    //CHECK IF DB IS CREATED
    Database newDatabase = await database;
    person.id = await newDatabase.insert('person', person.toMap());
    return person;
  }
  
  //MISE A JOUR
  Future<int> update(Person person) async{
    Database dBase = await database;
    return dBase.update('person', person.toMap(), where: 'id = ?', whereArgs: [person.id]);
  }

  //RECUPERER LES PERSONE CREER
  Future<List<Person>> allPerson() async {
    Database newDatabase = await database;
    List<Map<String, dynamic>> results = await newDatabase.rawQuery(
        "SELECT * FROM person");
    List<Person> persons = [];
    results.forEach((map){
      Person person = Person();
      person.fromMap(map);
      persons.add(person);
    });

    return persons;
  }

  //SUPPRIMER UNE PERSONE
  Future<int> deletePerson(int personId, String table) async{
    Database dBase = await database;
    return await dBase.delete(table, where: 'id = ?', whereArgs: [personId]);
  }
}