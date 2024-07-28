
import 'dart:math';

import 'package:draggable_sticky_notes/data.dart';
import './utility.dart';
import 'package:flutter/material.dart';


class StickyNotesArea extends StatefulWidget {
  final Size screenSize;
   StickyNotesArea(  this.screenSize, {super.key});

  @override
  State<StickyNotesArea> createState() => _StickyNotesAreaState();
}

class _StickyNotesAreaState extends State<StickyNotesArea> {

  Offset extractOffsetForStickyWidgetArea(Offset globalOffset) {

    double positionX = ((globalOffset.dx / widget.screenSize.width) * 100).toInt().toDouble();
    double positionY = (((globalOffset.dy - (widget.screenSize.height * .2)) / (widget.screenSize.height * .8)) * 100).toInt().toDouble();

    return Offset(positionX, positionY);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double containerHeight = screenSize.height * .8;
    double containerWidth = screenSize.width;
    double stickyNoteWidth = containerWidth * .2;
    double stickyNoteHeight = containerHeight * .2;
    final notes = InheritedNotes.of(context).notes;



    return Container(
      color: const Color(0xFF163E52),
      // color: Colors.black45,
      width: containerWidth,
      height: containerHeight,
      child: Stack(
        children: notes.map((note) {
          return AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            left: containerWidth * (( note['positionX'] as double) / 100) ,
            top: containerHeight * (( note['positionY'] as double) / 100),
            child: Draggable<int>(

              feedback: Container(
                // color: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade50,
                  border: Border.all(color: Colors.black45, width: 1, style: BorderStyle.solid),
                ),
                width: stickyNoteWidth,
                height: stickyNoteHeight,
                child: Text(note['text'] as String, style: TextStyle(color: Colors.black, fontSize: 14),),
              ),
              // childWhenDragging: Container(
              //   // color: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
              //   decoration: BoxDecoration(
              //     color: Color(0x79776BFF),
              //     border: Border.all(color: Colors.black45, width: 1, style: BorderStyle.solid),
              //   ),
              //   width: stickyNoteWidth,
              //   height: stickyNoteHeight,
              //   child: Text(note['text'] as String),
              // ),
              child: Container(
                // color: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade50,
                  border: Border.all(color: Colors.black45, width: 1, style: BorderStyle.solid),
                ),
                width: stickyNoteWidth,
                height: stickyNoteHeight,
                child: Text(note['text'] as String),
              ),
              onDragEnd: (details) {

                Offset childOffset = Offset((note['positionX'] as int).toDouble(), (note['positionY'] as int).toDouble());
                Offset? offset = checkIfChosenOffsetIsValid(noteHeight: 20, noteWidth: 20, randomOffset: extractOffsetForStickyWidgetArea(details.offset), takenOffset: extractOffset(notes), childOffset: childOffset);

                  if(offset != null && offset.dx <= 80 && offset.dy <= 80) {


                    Map<String, Object> updatedNote = {
              'id' : note['id'] as int,
                'text': note['text'] as String,
                'positionX': offset.dx.toInt(),
                'positionY': offset.dy.toInt()
                };
                    InheritedNotes.of(context).updateNotePosition(updatedNote);
                  } else {
                    // do nothing....
                  }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
