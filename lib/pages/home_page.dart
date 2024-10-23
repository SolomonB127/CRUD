import 'package:firestore_db/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // firestore object
  final FirestoreService firestoreService = FirestoreService();

  // text controller
  final TextEditingController textController = TextEditingController();

//  open dialog method
  void openNoteDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
              ),
              actions: <Widget>[
                // save button
                ElevatedButton(
                  onPressed: () {
                    // add a new note
                    firestoreService.addNote(textController.text);

                    // clear controller
                    textController.clear();

                    // pop dialog
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "CRUD App",
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
