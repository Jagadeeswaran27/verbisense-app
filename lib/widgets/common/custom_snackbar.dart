import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message,
    {bool error = false}) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        const Icon(
          Icons.info,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
    backgroundColor: error ? Colors.red : Colors.black,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    action: SnackBarAction(
      label: 'Undo',
      textColor: error ? Colors.white : Colors.blueAccent,
      onPressed: () {
        // Action when the button is pressed
      },
    ),
    duration: const Duration(milliseconds: 3000),
    padding: const EdgeInsets.symmetric(
        horizontal: 10, vertical: 7), // Reduced padding inside
    margin: const EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 8,
    ), // Reduced margin around snackbar
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
