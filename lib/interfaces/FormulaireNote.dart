import 'package:flutter/material.dart';
import 'package:projet_note/modeles/Note.dart';
import 'package:projet_note/modeles/Utilisateur.dart';
import 'package:projet_note/services/database_manager.dart';
import 'package:projet_note/utils/colors.dart';

class FormulaireNoteInterface extends StatefulWidget {
  final Utilisateur utilisateur;
  final Note? note; // null = ajout, non-null = modification

  const FormulaireNoteInterface({
    super.key,
    required this.utilisateur,
    this.note,
  });

  @override
  State<FormulaireNoteInterface> createState() =>
      _FormulaireNoteInterfaceState();
}

class _FormulaireNoteInterfaceState extends State<FormulaireNoteInterface> {
  final DatabaseManager _dbManager = DatabaseManager.instance;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titreController;
  late final TextEditingController _contenuController;

  bool _isLoading = false;

  bool get _estModification => widget.note != null;

  @override
  void initState() {
    super.initState();
    _titreController = TextEditingController(text: widget.note?.titre ?? '');
    _contenuController =
        TextEditingController(text: widget.note?.contenu ?? '');
  }

  @override
  void dispose() {
    _titreController.dispose();
    _contenuController.dispose();
    super.dispose();
  }

  // Validateur du titre
  String? titreValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Le titre est obligatoire";
    }
    if (value.trim().length < 2) {
      return "Le titre est trop court";
    }
    return null;
  }

  // Validateur du contenu
  String? contenuValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Le contenu est obligatoire";
    }
    return null;
  }

  Future<void> _enregistrerNote() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_estModification) {
        // Modification d'une note existante
        final noteModifiee = Note(
          id: widget.note!.id,
          titre: _titreController.text.trim(),
          contenu: _contenuController.text.trim(),
          utilisateurId: widget.utilisateur.id!,
          dateCreation: widget.note!.dateCreation,
          dateModification: DateTime.now(),
        );
        await _dbManager.updateNote(noteModifiee);
      } else {
        // Ajout d'une nouvelle note
        final nouvelleNote = Note(
          titre: _titreController.text.trim(),
          contenu: _contenuController.text.trim(),
          utilisateurId: widget.utilisateur.id!,
          dateCreation: DateTime.now(),
          dateModification: DateTime.now(),
        );
        await _dbManager.insertNote(nouvelleNote);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_estModification
              ? "Note modifiée avec succès"
              : "Note ajoutée avec succès"),
          backgroundColor: Colors.green,
        ),
      );

      // On renvoie "true" à ListeNotesInterface pour déclencher le rechargement
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.erreur,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.primaire,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        title: Text(
          _estModification ? 'Modifier la note' : 'Ajouter une note',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Champ Titre
              TextFormField(
                controller: _titreController,
                decoration: InputDecoration(
                  labelText: 'Titre',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: AppColors.secondaire, width: 2),
                  ),
                ),
                validator: titreValidator,
              ),
              const SizedBox(height: 16),

              // Champ contenu
              TextFormField(
                controller: _contenuController,
                maxLines: 12,
                minLines: 8,
                decoration: InputDecoration(
                  labelText: 'contenu',
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: AppColors.secondaire, width: 2),
                  ),
                ),
                validator: contenuValidator,
              ),
              const SizedBox(height: 24),

              // Bouton Ajouter / Modifier
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _enregistrerNote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaire,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _estModification ? 'Modifier' : 'Ajouter',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
