class Note {
  final int? id;
  final String titre;
  final String Contenu;
  final DateTime? dateCreation;
  final DateTime? dateModification;

  Note({
    this.id,
    required this.titre,
    required this.Contenu,
    this.dateCreation,
    this.dateModification,
  });

  Note.sansId(String titre, String Contenu)
      : id = null,
        titre = titre,
        Contenu = Contenu,
        dateCreation = DateTime.now(),
        dateModification = DateTime.now();

  // Convertir un Map (de la base de données) en  Note
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
        id: map['id'] as int?,
        titre: map['titre'] as String,
        Contenu: map['Contenu'] as String,
        dateCreation: map['dateCreation'] != null
            ? DateTime.parse(map['dateCreation'])
            : null,
        dateModification: map['dateModification'] != null
            ? DateTime.parse(map['dateModification'])
            : null);
  }
  // Convertir un Note en Map (pour la base de données)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'Contenu': Contenu,
      'dateCreation': dateCreation,
      'dateModification': dateModification
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'Note(id: $id, titre: $titre, Contenu: $Contenu, dateCreation: $dateCreation, dateModification: $dateModification)';
  }
}
