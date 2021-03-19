//ON CREER UNE CLASSE PERSON POUR AVOIR DE QUOI AJOUTER DANS
//BD
class Person{
  int id;
  String name;


  Person();

  //CE QUON RECOIS DE NOTRE BD EST UNE MAP
  void fromMap(Map<String, dynamic> map){
     this.id = map['id'];
     this.name = map['name'];
   }

   //CONVERTIR NOTRE PERSON EN UNE MAP
  //ON CREER UNE PERSONE GRACE A UNE MAP
  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      'name' : this.name,
    };

    if(id != null){
      map['id'] = this.id;
    }

    return map;
  }
}