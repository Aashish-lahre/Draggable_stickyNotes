import 'package:flutter/material.dart';

class Notes extends StatefulWidget {
  final Widget child;
  const Notes(this.child, {super.key});


  @override
  State<Notes> createState() {
    return NotesState();
  }
}

class NotesState extends State<Notes> {
  final notes = [
    {
      'id': 1,
      'text': 'Note number : 1',
      'positionX' : 10,
      'positionY' : 20,
    },{
      'id': 2,
      'text': "Note number : 2",
      'positionX' : 40,
      'positionY' : 50,
    },
  ];

  void addNote(Map<String, Object> newNote) {

    setState(() {
      notes.add(newNote);
    });
  }

  void updateNotePosition(Map<String, Object> updatedNote) {

    setState(() {

      notes.replaceRange((updatedNote['id'] as int) - 1, updatedNote['id'] as int, [updatedNote]);

    });
  }
  @override
  Widget build(BuildContext context) {

    return InheritedNotes(notes: notes, addNote: addNote, updateNotePosition: updateNotePosition, child: widget.child);
  }
}

class InheritedNotes extends InheritedWidget {
  final List<Map<String, Object>> notes;
  final ValueChanged<Map<String, Object>> addNote;
  final ValueChanged<Map<String, Object>> updateNotePosition;
   const InheritedNotes({super.key, required this.notes, required this.addNote, required this.updateNotePosition, required super.child});

  static InheritedNotes of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<InheritedNotes>()!;


  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

}