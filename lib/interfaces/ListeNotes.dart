import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projet_note/interfaces/FormulaireNote.dart';
import 'package:projet_note/modeles/Note.dart';
import 'package:projet_note/modeles/Utilisateur.dart';
import 'package:projet_note/services/database_manager.dart';
import 'package:projet_note/utils/colors.dart';

class ListeNotesInterface extends StatefulWidget {
  final Utilisateur utilisateur;

  const ListeNotesInterface({super.key, required this.utilisateur});

  @override
  State<ListeNotesInterface> createState() => _ListeNotesInterfaceState();
}

class _ListeNotesInterfaceState extends State<ListeNotesInterface> {
  final DatabaseManager _dbManager = DatabaseManager.instance;
  List<Note> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _chargerNotes();
  }

  Future<void> _chargerNotes() async {
    setState(() {
      _isLoading = true;
    });

    final notes =
        await _dbManager.getNotesByUtilisateur(widget.utilisateur.id!);

    setState(() {
      _notes = notes;
      _isLoading = false;
    });
  }

  bool _estTronque(String contenu) {
    return contenu.length > 60;
  }

  void _afficherDetailsNote(Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          note.titre,
          style: const TextStyle(
            color: AppColors.primaire,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                note.contenu,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              Text(
                'Modifié le ${_formatDate(note.dateModification)}',
                style: const TextStyle(
                  color: AppColors.texteGris,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _ouvrirFormulaire(note: note);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.secondaire),
            child: const Text('Modifier'),
          ),
        ],
      ),
    );
  }

  Future<void> _supprimerNote(int id) async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Confirmation'),
        content: const Text('Voulez-vous vraiment supprimer cette note ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.erreur),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmation == true) {
      await _dbManager.deleteNote(id);
      _chargerNotes();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Note supprimée avec succès"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _ouvrirFormulaire({Note? note}) async {
    final resultat = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FormulaireNoteInterface(
          utilisateur: widget.utilisateur,
          note: note,
        ),
      ),
    );

    // Si le formulaire a renvoyé "true" (note ajoutée/modifiée), on recharge
    if (resultat == true) {
      _chargerNotes();
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _extrait(String contenu) {
    if (contenu.length <= 60) return contenu;
    return '${contenu.substring(0, 60)}...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'Mes Notes',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaire,
        centerTitle: true,
        leading:
            const Icon(Icons.menu_book_rounded, color: Colors.white, size: 32),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 32),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notes.isEmpty
              ? const Center(
                  child: Text(
                    "Aucune note pour le moment",
                    style: TextStyle(color: AppColors.texteGris, fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _chargerNotes,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      final note = _notes[index];
                      final tronque = _estTronque(note.contenu);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap:
                              tronque ? () => _afficherDetailsNote(note) : null,
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        note.titre,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaire,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: AppColors.secondaire,
                                              size: 25),
                                          onPressed: () =>
                                              _ouvrirFormulaire(note: note),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: AppColors.erreur,
                                              size: 25),
                                          onPressed: () =>
                                              _supprimerNote(note.id!),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _extrait(note.contenu),
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 13,
                                  ),
                                ),
                                if (tronque) ...[
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Voir plus',
                                    style: TextStyle(
                                      color: AppColors.secondaire,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 8),
                                Text(
                                  _formatDate(note.dateModification),
                                  style: const TextStyle(
                                    color: AppColors.texteGris,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: SizedBox(
        width: 64,
        height: 64,
        child: FloatingActionButton(
          backgroundColor: AppColors.secondaire,
          shape: const CircleBorder(),
          onPressed: () => _ouvrirFormulaire(),
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
    );
  }
}
