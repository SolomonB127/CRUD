import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // get notes collection from DB
  final CollectionReference notes =
      FirebaseFirestore.instance.collection("notes");

  // CREATE: add a new note
  Future<void> addNote(String newNote) {
    return notes.add({"notes": newNote, "timestamp": Timestamp.now()});
  }

  // READ: get notes from Database
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream =
        notes.orderBy("timestamp", descending: true).snapshots();

    return notesStream;
  }

  // UPDATE: update notes given a doc id

  // DELETE: delete notes given a doc id
}
