import 'package:cloud_firestore/cloud_firestore.dart';
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
  void openNoteDialog({String? docID}) {
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
                    if (docID == null) {
                      firestoreService.addNote(textController.text);
                    } else {
                      // update an existing note
                      firestoreService.updateNotes(docID, textController.text);
                    }

                    // clear controller
                    textController.clear();

                    // pop dialog
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          // Check if snapshot is loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Show loading indicator
          }

          // Check if snapshot has data, then get docs
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            // Return a list view
            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                // Get individual doc
                DocumentSnapshot document = notesList[index];
                String docID = document.id;

                // Get note for each doc
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteText = data["notes"]; // Correct key name

                // Display list tile
                return ListTile(
                  title: Text(noteText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // update button
                      IconButton(
                          onPressed: () => openNoteDialog(docID: docID),
                          icon: const Icon(Icons.settings)),

                          // delete button
                      IconButton(
                          onPressed: () => firestoreService.deleteNote(docID),
                          icon: const Icon(Icons.delete)),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(
                child: Text(
                    "No notes...")); // Display message when no notes are found
          }
        },
      ),
    );
  }
}
