import 'package:flutter/material.dart';
import 'package:projet_note/interfaces/connexion.dart';
import 'package:projet_note/modeles/Utilisateur.dart';
import 'package:projet_note/services/database_manager.dart';
import 'package:projet_note/utils/colors.dart';

class InscriptionInterface extends StatefulWidget {
  const InscriptionInterface({super.key});

  @override
  State<InscriptionInterface> createState() => _InscriptionInterfaceState();
}

class _InscriptionInterfaceState extends State<InscriptionInterface> {
  final DatabaseManager _dbManager = DatabaseManager.instance;
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //Validateur du champs nom
  String? nomValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Le nom est obligatoire";
    }

    if (value.trim().length < 2) {
      return "Le nom est trop court";
    }

    return null;
  }

  //validateur du champs prenom
  String? prenomValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Le prenom est obligatoire";
    }

    if (value.trim().length < 2) {
      return "Le prenom est trop court";
    }

    return null;
  }

  // Validateur email
  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez entrer une adresse e-mail';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Veuillez entrer une adresse e-mail valide';
    }
    return null;
  }

  // Validateur mot de passe
  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est obligatoire';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  Future<void> _sinscrire() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Créer un nouvel utilisateur
      final nouvelUtilisateur = Utilisateur.sansId(
        _nomController.text.trim(),
        _prenomController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );
      await _dbManager.insertUtilisateur(nouvelUtilisateur);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Inscription réussie"),
          backgroundColor: Colors.green,
        ),
      );
      _allerVersConnexion();
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

  void _allerVersConnexion() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ConnexionInterface()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fond,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  // Conteneur avec le logo et le titre
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: AppColors.primaire,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/Logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'S\'INSCRIRE A NOTE',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaire,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 40),
                  //Champ nom
                  TextFormField(
                    controller: _nomController,
                    decoration: InputDecoration(
                      labelText: 'Nom',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.secondaire,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: nomValidator,
                  ),
                  const SizedBox(height: 16),
                  //Champ prenom
                  TextFormField(
                    controller: _prenomController,
                    decoration: InputDecoration(
                      labelText: 'Prénom',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.secondaire,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: prenomValidator,
                  ),
                  const SizedBox(height: 16),
                  // Champ Email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.secondaire,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: emailValidator,
                  ),
                  const SizedBox(height: 16),

                  // Champ Mot de passe
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.secondaire,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: passwordValidator,
                  ),
                  const SizedBox(height: 32),

                  // Bouton Connecter
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _sinscrire,
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
                          : const Text(
                              'S\'inscrire',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Lien vers inscription
                  GestureDetector(
                    onTap: _allerVersConnexion,
                    child: RichText(
                      text: const TextSpan(
                        style:
                            TextStyle(color: AppColors.texteGris, fontSize: 13),
                        children: [
                          TextSpan(text: "Vous avez deja un compte ? "),
                          TextSpan(
                            text: "Se connecter",
                            style: TextStyle(
                              color: AppColors.secondaire,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
