import 'package:draggable_sticky_notes/data.dart';
import './utility.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class InputWidget extends StatefulWidget {
    const InputWidget({super.key});




  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  final TextEditingController _controller = TextEditingController()..text = "";
  int retryOffsetLimit = 30;
  int offsetTried = 0;



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Offset randomOffset(int horizontalMin, int horizontalMax, int verticalMin, int verticalMax) {
    int dx = horizontalMin + Random().nextInt(horizontalMax - horizontalMin);
    int dy = verticalMin + Random().nextInt(verticalMax - verticalMin);

    return Offset(dx.toDouble(), dy.toDouble());
  }



  Future<Offset?> returnOffset({
    required double rightRangeLimit,
    required double stickyNoteWidth,
    required double stickyNoteHeight,
    required double topRangeLimit,
    required double bottomRangeLimit,
    required List<Offset> takenOffset,
  }) async {
    while (offsetTried <= retryOffsetLimit) {
      print('offsetTried : $offsetTried');
      Offset _randomOffset = randomOffset(0, 80, 0, 80);
      Offset? outputOffset = checkIfChosenOffsetIsValid(
        randomOffset:
          _randomOffset,
          takenOffset: takenOffset,
          noteWidth: stickyNoteWidth,
          noteHeight: stickyNoteHeight);
      if (outputOffset != null) {
        offsetTried = 0;
        return _randomOffset;
      } else {
        // Future.microtask(computation)
        // await Future.sync(() {
        // });
        //  Future.delayed(const Duration(milliseconds: 50), () {
        //   setState(() {
            offsetTried++;
        //     print("offset Tried : $offsetTried");
        //
        //   });
        //
        // });

      }
    }
    // No more space left to fit any more sticky notes.
    offsetTried = 0;
    return null;
  }



  int rebuilding = 0;
  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;

    double containerHeight = screenSize.height * .2;
    double containerWidth = screenSize.width;

    double stickyNoteWidth = 20;
    double stickyNoteHeight = 20;



    return Container(
      width: double.infinity,
      // color: Colors.red.shade400,
      height: containerHeight,
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               SizedBox(
                 width: 300,
                 child: TextField(
                   controller: _controller,
                   decoration: const InputDecoration(
                     hintText: 'Add a note...',
                     border: OutlineInputBorder(
                         borderSide: BorderSide(color: Colors.black, width: 2, style: BorderStyle.solid),
                     ),
                   ),
          ),),
              const SizedBox(width: 20,),
              ElevatedButton(onPressed: () async {

                Offset? offset = await returnOffset(rightRangeLimit: 80, stickyNoteWidth: stickyNoteWidth, stickyNoteHeight: stickyNoteHeight, topRangeLimit: 0, bottomRangeLimit: 80, takenOffset: extractOffset(InheritedNotes.of(context).notes));

                if(offset == null) {
                  // No more space has left to fit any more sticky notes
                  const snackbarWidget = SnackBar(
                    content: Text('No more space!!'),
                    backgroundColor: Colors.green,
                    elevation: 10,
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.all(5),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackbarWidget);
                } else {
                  InheritedNotes.of(context).addNote(
                      {
                        'id' : InheritedNotes.of(context).notes.length + 1,
                        'text': _controller.text,
                        'positionX': offset.dx,
                        'positionY': offset.dy,
                      }
                  );
                }



                }, child: Text("Add Note")),
            ],
          ),
          // const Text('Search for space Limit : 30'),
          // Text('Search Tried : $offsetTried')
        ],
      ),
    );
  }
}
