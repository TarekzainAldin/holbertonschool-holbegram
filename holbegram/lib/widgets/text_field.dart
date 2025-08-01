import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  // Attributs pour TextFieldInput
  final TextEditingController controller;
  final bool isPassword;
  final String hintText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;

  // Constructeur pour TextFieldInput
  const TextFieldInput({
    super.key,
    required this.controller,
    required this.isPassword,
    required this.hintText,
    this.suffixIcon,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      // Applique les propriétés
      keyboardType: keyboardType,
      controller: controller,
      cursorColor: const Color.fromARGB(218, 226, 37, 24),
      obscureText: isPassword,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        // Utilisation du hintText dans la décoration
        hintText:
            hintText, // Cette ligne est importante pour afficher le texte d'indication
        filled: true,
        contentPadding: const EdgeInsets.all(8),
        suffixIcon: suffixIcon,
        // Bordure par défaut lorsqu'il n'est pas sélectionné
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            style: BorderStyle.none,
          ),
        ),
        // Bordure quand le champ est sélectionné
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            style: BorderStyle.none,
          ),
        ),
        // Bordure quand le champ est activé mais pas sélectionné
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            style: BorderStyle.none,
          ),
        ),
      ),
    );
  }
}