import 'package:flutter/material.dart';
import 'package:invite_friends/presentation/widgets/custom_elevated_button.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final String primaryButtonText;
  final VoidCallback primaryButtonAction;
  final String? secondaryButtonText;
  final VoidCallback? secondaryButtonAction;

  const CustomDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.primaryButtonText,
    required this.primaryButtonAction,
    this.secondaryButtonText,
    this.secondaryButtonAction,
  }) : super(key: key);

  /// Método estático para exibir o diálogo
  static void show(
    BuildContext context, {
    required String title,
    required String message,
    required String primaryButtonText,
    required VoidCallback primaryButtonAction,
    String? secondaryButtonText,
    VoidCallback? secondaryButtonAction,
  }) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: title,
        message: message,
        primaryButtonText: primaryButtonText,
        primaryButtonAction: primaryButtonAction,
        secondaryButtonText: secondaryButtonText,
        secondaryButtonAction: secondaryButtonAction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      content: Text(
        message,
        style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
      ),
      actions: [
        if (secondaryButtonText != null && secondaryButtonAction != null)
          TextButton(
            onPressed: () {
              secondaryButtonAction!();
              Navigator.pop(context);
            },
            child: Text(
              secondaryButtonText!,
              style: TextStyle(color: Colors.black87),
            ),
          ),
        CustomElevatedButton(
          onPressed: () {
            primaryButtonAction();
            Navigator.pop(context);
          },
          text: primaryButtonText,
        ),
      ],
    );
  }
}
