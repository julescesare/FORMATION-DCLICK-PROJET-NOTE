class Utilisateur {
  final int? id;
  final String nom;
  final String prenom;
  final String email;
  final String motDePasse;

  Utilisateur(
      {this.id,
      required this.nom,
      required this.prenom,
      required this.email,
      required this.motDePasse});

  Utilisateur.sansId(String nom, String prenom, String email, String motDePasse)
      : id = null,
        nom = nom,
        prenom = prenom,
        email = email,
        motDePasse = motDePasse;

  // Convertir un Map (de la base de données) en  Utilisateur
  factory Utilisateur.fromMap(Map<String, dynamic> map) {
    return Utilisateur(
        id: map['id'] as int?,
        nom: map['nom'] as String,
        prenom: map['prenom'] as String,
        email: map['email'] as String,
        motDePasse: map['motDePasse'] as String);
  }
  // Convertir un Utilisateur en Map (pour la base de données)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'motDePasse': motDePasse
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'Utilisateur(id: $id, nom: $nom, prenom: $prenom, email: $email)';
  }
}
