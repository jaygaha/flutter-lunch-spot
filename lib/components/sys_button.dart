import 'package:flutter/material.dart';

class SysButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SysButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: onPressed,
        color: Theme.of(context).colorScheme.primary,
        textColor: Colors.white,
        child: Text(text));
  }
}
