class Note {
  final int? id;
  final String titre;
  final String contenu;
  final int utilisateurId;
  final DateTime? dateCreation;
  final DateTime? dateModification;

  Note({
    this.id,
    required this.titre,
    required this.contenu,
    required this.utilisateurId,
    this.dateCreation,
    this.dateModification,
  });

  Note.sansId(String titre, String contenu, int utilisateurId)
      : id = null,
        titre = titre,
        contenu = contenu,
        utilisateurId = utilisateurId,
        dateCreation = DateTime.now(),
        dateModification = DateTime.now();

  // Convertir un Map (de la base de données) en  Note
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
        id: map['id'] as int?,
        titre: map['titre'] as String,
        contenu: map['contenu'] as String,
        utilisateurId: map['utilisateurId'] as int,
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
      'contenu': contenu,
      'utilisateurId': utilisateurId,
      'dateCreation': dateCreation?.toIso8601String(),
      'dateModification': dateModification?.toIso8601String()
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'Note(id: $id, titre: $titre, contenu: $contenu, utilisateurId: $utilisateurId, dateCreation: $dateCreation, dateModification: $dateModification)';
  }
}
