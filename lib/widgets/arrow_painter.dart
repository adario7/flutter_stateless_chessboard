/*
Adapted from https://github.com/deven98/flutter_chess_board/blob/97fe52c9a0c706b455b2162df55b050eb92ff70e/lib/src/chess_board.dart
*/
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/models/board_arrow.dart';
import 'package:flutter_stateless_chessboard/models/board_color.dart';

const files = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];

class ArrowPainter extends CustomPainter {
  List<BoardArrow> arrows;
  BoardColor orientation;

  ArrowPainter(this.arrows, this.orientation);

  @override
  void paint(Canvas canvas, Size size) {
    var blockSize = size.width / 8;
    var halfBlockSize = size.width / 16;

    final baseArrowLengthProportion = 0.6;

    for (var arrow in arrows) {
      var startFile = files.indexOf(arrow.from[0]);
      var startRank = int.parse(arrow.from[1]) - 1;
      var endFile = files.indexOf(arrow.to[0]);
      var endRank = int.parse(arrow.to[1]) - 1;

      int effectiveRowStart = 0;
      int effectiveColumnStart = 0;
      int effectiveRowEnd = 0;
      int effectiveColumnEnd = 0;

      if (orientation == BoardColor.BLACK) {
        effectiveColumnStart = 7 - startFile;
        effectiveColumnEnd = 7 - endFile;
        effectiveRowStart = startRank;
        effectiveRowEnd = endRank;
      } else {
        effectiveColumnStart = startFile;
        effectiveColumnEnd = endFile;
        effectiveRowStart = 7 - startRank;
        effectiveRowEnd = 7 - endRank;
      }

      var startOffset = Offset(
          ((effectiveColumnStart + 1) * blockSize) - halfBlockSize,
          ((effectiveRowStart + 1) * blockSize) - halfBlockSize);
      var endOffset = Offset(
          ((effectiveColumnEnd + 1) * blockSize) - halfBlockSize,
          ((effectiveRowEnd + 1) * blockSize) - halfBlockSize);

      var yDist = baseArrowLengthProportion * (endOffset.dy - startOffset.dy);
      var xDist = baseArrowLengthProportion * (endOffset.dx - startOffset.dx);

      var paint = Paint()
        ..strokeWidth = halfBlockSize * baseArrowLengthProportion
        ..color = arrow.color;

      canvas.drawLine(startOffset,
          Offset(startOffset.dx + xDist, startOffset.dy + yDist), paint);

      var slope =
          (endOffset.dy - startOffset.dy) / (endOffset.dx - startOffset.dx);

      var newLineSlope = -1 / slope;

      var points = _getNewPoints(
          Offset(startOffset.dx + xDist, startOffset.dy + yDist),
          newLineSlope,
          halfBlockSize);
      var newPoint1 = points[0];
      var newPoint2 = points[1];

      var path = Path();

      path.moveTo(endOffset.dx, endOffset.dy);
      path.lineTo(newPoint1.dx, newPoint1.dy);
      path.lineTo(newPoint2.dx, newPoint2.dy);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  List<Offset> _getNewPoints(Offset start, double slope, double length) {
    if (slope == double.infinity || slope == double.negativeInfinity) {
      return [
        Offset(start.dx, start.dy + length),
        Offset(start.dx, start.dy - length)
      ];
    }

    return [
      Offset(start.dx + (length / sqrt(1 + (slope * slope))),
          start.dy + ((length * slope) / sqrt(1 + (slope * slope)))),
      Offset(start.dx - (length / sqrt(1 + (slope * slope))),
          start.dy - ((length * slope) / sqrt(1 + (slope * slope)))),
    ];
  }

  @override
  bool shouldRepaint(ArrowPainter oldDelegate) {
    return arrows != oldDelegate.arrows;
  }
}