import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:flutter/material.dart';

void challengDialogErrorBox(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  getFigmaColor("000000"),
                  getFigmaColor("006FCD")
                ])),
            child: Text("You have challenged this post already"),
          ),
        );
      });
}

void acceptDialogError(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  getFigmaColor("000000"),
                  getFigmaColor("006FCD")
                ])),
            child: Text("You have  accepted this chchallenge  already"),
          ),
        );
      });
}

void popUpMessages(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  getFigmaColor("000000"),
                  getFigmaColor("006FCD")
                ])),
            child: Text(message),
          ),
        );
      });
}

void showWinnersBadge(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            // decoration:
            //     BoxDecoration(image: DecorationImage(image: AssetImage(""))),
            child: Text(
              "THIS IS THE WINNER",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      });
}

void showLoosersBadge(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            // decoration:
            //     BoxDecoration(image: DecorationImage(image: AssetImage(""))),
            child: Text(
              "THIS IS THE Looser",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      });
}

void showDialogInforamtion(BuildContext context, {Function()? onPressed}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        // Set the background color to a dark shade
        backgroundColor: getFigmaColor("121212"),
        // Apply rounded corners to the dialog
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        content: Column(
          // Make the column take minimum space
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue[700],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 36,
              ),
            ),
            const SizedBox(height: 24),
            // "Challenge Sent" text
            const Text(
              'Stream has ended',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('close'),
              ),
            ),
          ],
        ),
      );
    },
  );
}
