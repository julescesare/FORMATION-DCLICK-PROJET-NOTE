import 'package:projet_note/modeles/Note.dart';
import 'package:projet_note/modeles/Utilisateur.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseManager {
  static final DatabaseManager instance = DatabaseManager._init();
  static Database? _database;

  DatabaseManager._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('noteDB.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    try {
      // Table utilisateurs
      await db.execute('''
      CREATE TABLE utilisateurs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        prenom TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        motDePasse TEXT NOT NULL
      )
    ''');

      // Table notes
      await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titre TEXT NOT NULL,
        contenu TEXT NOT NULL,
        dateCreation TEXT NOT NULL,
        dateModification TEXT NOT NULL,
        utilisateurId INTEGER NOT NULL,
        FOREIGN KEY (utilisateurId)
          REFERENCES utilisateurs(id)
          ON DELETE CASCADE
      )
    ''');
    } catch (e) {
      throw Exception("Erreur lors de la création des tables : $e");
    }
  }

  //CLOSE - Fermeture de la connexion à la base de données
  Future<void> close() async {
    final db = await database;
    db.close();
  }

  /**
   * 
   * CRUD pour la table utilisateurs
   * 
   */

  // CREATE - Insérer un utilisateur
  Future<int> insertUtilisateur(Utilisateur utilisateur) async {
    try {
      final db = await database;
      return await db.insert(
        'utilisateurs',
        utilisateur.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } on DatabaseException catch (e) {
      throw Exception("Impossible d'ajouter l'utilisateur : ${e.toString()}");
    }
  }

  // READ - Lire tous les utilisateurs
  Future<List<Utilisateur>> getAllUtilisateurs() async {
    final db = await database;
    final result = await db.query('utilisateurs', orderBy: 'nom');
    return result.map((map) => Utilisateur.fromMap(map)).toList();
  }

  // READ - Lire un utilisateur par ID
  Future<Utilisateur?> getUtilisateurById(int id) async {
    final db = await database;
    final result = await db.query(
      'utilisateurs',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Utilisateur.fromMap(result.first);
    }
    return null;
  }

  // READ - Lire un utilisateur par email
  Future<Utilisateur?> getUtilisateurByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'utilisateurs',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      return Utilisateur.fromMap(result.first);
    }
    return null;
  }

  // UPDATE - Mettre à jour un utilisateur
  Future<int> updateUtilisateur(Utilisateur utilisateur) async {
    final db = await database;
    return await db.update(
      'utilisateurs',
      utilisateur.toMap(),
      where: 'id = ?',
      whereArgs: [utilisateur.id],
    );
  }

  // DELETE - Supprimer un utilisateur
  Future<int> deleteUtilisateur(int id) async {
    final db = await database;
    return await db.delete(
      'utilisateurs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /**
   * 
   * CRUD pour la table notes
   * 
   */

  // CREATE - Insérer une note
  Future<int> insertNote(Note note) async {
    try {
      final db = await database;
      return await db.insert(
        'notes',
        note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } on DatabaseException catch (e) {
      throw Exception("Impossible d'ajouter la note : ${e.toString()}");
    }
  }

  // READ - Lire tous les notes
  Future<List<Note>> getAllNotes() async {
    final db = await database;
    final result = await db.query('notes', orderBy: 'titre');
    return result.map((map) => Note.fromMap(map)).toList();
  }

  // READ - Lire une note par ID
  Future<Note?> getNoteById(int id) async {
    final db = await database;
    final result = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Note.fromMap(result.first);
    }
    return null;
  }

  // READ - Lire toutes les notes d'un utilisateur
  Future<List<Note>> getNotesByUtilisateur(int utilisateurId) async {
    final db = await database;
    final result = await db.query(
      'notes',
      where: 'utilisateurId = ?',
      whereArgs: [utilisateurId],
      orderBy: 'dateCreation DESC',
    );
    return result.map((map) => Note.fromMap(map)).toList();
  }

  // UPDATE - Mettre à jour une note
  Future<int> updateNote(Note utilisateur) async {
    final db = await database;
    return await db.update(
      'notes',
      utilisateur.toMap(),
      where: 'id = ?',
      whereArgs: [utilisateur.id],
    );
  }

  // DELETE - Supprimer une note
  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
