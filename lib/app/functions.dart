import 'package:flutter/material.dart';

void showSuccessSnackBar(BuildContext context, String message) {
  SnackBar snackbar = SnackBar(
    content: Row(
      children: [
        const Icon(
          Icons.check, // Icon tick
          color: Colors.white, // Icon color
        ),
        const SizedBox(width: 10), // Space between the icon and the text
        Expanded(
          child: Text(
            message,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Text color
          ),
        ),
      ],
    ),
    backgroundColor: Colors.green, // Background color
    behavior: SnackBarBehavior.floating, // Makes the snackbar float above the bottom
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0), // Rounded corners
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
