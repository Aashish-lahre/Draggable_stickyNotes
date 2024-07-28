import 'dart:math';

import 'package:flutter/material.dart';

Offset? checkIfChosenOffsetIsValid({required Offset randomOffset, required List<Offset> takenOffset, required double noteWidth, required double noteHeight, Offset? childOffset}) {

  for (Offset itemOffset in takenOffset) {

    if(childOffset != null) {
      if(itemOffset == childOffset) {
        continue;
      }
    }

    if((max(itemOffset.dx, randomOffset.dx) - min(itemOffset.dx, randomOffset.dx)) >= noteWidth ) {

      continue;
    } else {
      if(max(itemOffset.dy, randomOffset.dy) - min(itemOffset.dy, randomOffset.dy) >= noteHeight) {
        // Offset in valid --> check for next offset
        continue;
      } else {
        // Not Valid, must reject the random Offset
        // print("$randomOffset is not valid");

        return null;
      }
    }
  }
  return randomOffset;

}

List<Offset> extractOffset( List<Map<String, Object>> notes) {
  final List<Offset> allOffsets = [];
  for(Map<String, Object> note in notes) {
    allOffsets.add(Offset(note['positionX'] as double, note['positionY'] as double));
  }
  return allOffsets;
}