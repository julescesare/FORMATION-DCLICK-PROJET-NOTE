# projet_note

Application Flutter de gestion de notes.

## Prérequis

- Git installé : https://git-scm.com/
- Flutter SDK installé : https://docs.flutter.dev/get-started/install
- Un appareil Android / iOS ou un émulateur/simulateur configuré
- Un éditeur compatible Flutter, comme VS Code ou Android Studio

## Clonage du dépôt

Clonez le dépôt GitHub suivant :

```powershell
git clone git@github.com:julescesare/FORMATION-DCLICK-PROJET-NOTE.git
cd FORMATION-DCLICK-PROJET-NOTE
```

## Installation

1. Vérifiez l'installation de Flutter
   ```powershell
   flutter doctor
   ```

2. Installez les dépendances du projet
   ```powershell
   flutter pub get
   ```

3. Connectez un appareil ou démarrez un émulateur
   - Sur Android : activez le mode développeur et le débogage USB, ou utilisez un émulateur Android.
   - Sur iOS : utilisez un simulateur iOS ou un appareil physique (macOS requis).

## Exécution

1. Lancer l'application
   ```powershell
   flutter run
   ```

2. Pour lancer sur un appareil ou un émulateur spécifique
   ```powershell
   flutter devices
   flutter run -d <device_id>
   ```

## Utilisation

- L'application permet de créer, consulter, modifier et supprimer des notes.
- Utilisez le formulaire d'inscription pour créer un compte ou la page de connexion si vous avez déjà un compte.
- Accédez à la liste des notes pour gérer vos notes personnelles.

## Structure du projet

- `lib/main.dart` : point d'entrée de l'application.
- `lib/interfaces/` : écrans et formulaires de l'application.
- `lib/modeles/` : classes de données pour les notes et utilisateurs.
- `lib/services/` : gestion de la base de données.
- `lib/utils/` : styles et constantes réutilisables.

## Structure de la base de données

La base de données SQLite est créée dans `lib/services/database_manager.dart`.

- Table `utilisateurs`
  - `id` : identifiant entier auto-incrémenté (clé primaire)
  - `nom` : nom de l'utilisateur
  - `prenom` : prénom de l'utilisateur
  - `email` : adresse email unique
  - `motDePasse` : mot de passe de l'utilisateur

- Table `notes`
  - `id` : identifiant entier auto-incrémenté (clé primaire)
  - `titre` : titre de la note
  - `contenu` : contenu texte de la note
  - `dateCreation` : date de création au format ISO 8601
  - `dateModification` : date de dernière modification au format ISO 8601
  - `utilisateurId` : identifiant de l'utilisateur qui possède la note

Relations :

- `notes.utilisateurId` référence `utilisateurs(id)`
- Suppression en cascade : si un utilisateur est supprimé, ses notes associées sont également supprimées

## Remarques

- Ce projet utilise Flutter et possède une structure prête pour mobile Android, iOS, Linux, macOS, Windows et Web.
- Si vous rencontrez des problèmes, exécutez `flutter clean` puis `flutter pub get`.
