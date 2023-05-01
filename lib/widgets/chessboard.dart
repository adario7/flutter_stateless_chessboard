library flutter_chessboard;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/models/board.dart';
import 'package:flutter_stateless_chessboard/models/board_arrow.dart';
import 'package:flutter_stateless_chessboard/models/board_color.dart';
import 'package:flutter_stateless_chessboard/utils.dart';
import 'package:flutter_stateless_chessboard/widgets/arrow_painter.dart';
import 'package:flutter_stateless_chessboard/widgets/ui_square_layer.dart';
import 'package:provider/provider.dart';

class Chessboard extends StatefulWidget {
  final Board board;

  Chessboard({Key? key, 
    required String fen,
    required double size,
    BoardColor orientation = BoardColor.WHITE,
    Color lightSquareColor = const Color.fromRGBO(240, 217, 181, 1),
    Color darkSquareColor = const Color.fromRGBO(181, 136, 99, 1),
    Dests dests = const {},
    Moved onMove = noop1,
    Promoted onPromote = defaultPromoting,
    BuildPiece? buildPiece,
    BuildSquare? buildSquare,
    BuildCustomPiece? buildCustomPiece,
    Color lastMoveHighlightColor = const Color.fromRGBO(50, 200, 50, .3),
    Color selectionHighlightColor = const Color.fromRGBO(50, 50, 200, .5),
    Color selectionDestColor = const Color.fromRGBO(50, 50, 200, .2),
    Color checkColor = const Color.fromRGBO(230, 20, 20, .4),
    List<String> lastMove = const [],
    List<BoardArrow> arrows = const [],
  }) : board = Board(
    fen: fen,
    size: size,
    orientation: orientation,
    onMove: onMove,
    lightSquareColor: lightSquareColor,
    darkSquareColor: darkSquareColor,
    dests: dests,
    onPromote: onPromote,
    buildPiece: buildPiece,
    buildSquare: buildSquare,
    buildCustomPiece: buildCustomPiece,
    lastMove: lastMove,
    lastMoveHighlightColor: lastMoveHighlightColor,
    selectionHighlightColor: selectionHighlightColor,
    selectionDestColor: selectionDestColor,
    checkColor: checkColor,
    arrows: arrows,
  ), super(key: key);

  @override
  State<StatefulWidget> createState() => _ChessboardState();
}

class _ChessboardState extends State<Chessboard> {
  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: widget.board,
      child: SizedBox(
        width: widget.board.size,
        height: widget.board.size,
        child: Stack(
            alignment: AlignmentDirectional.topStart,
            textDirection: TextDirection.ltr,
            children: [
              UISquareLayer(),
              if (widget.board.arrows.isNotEmpty)
                IgnorePointer(
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: CustomPaint(
                      child: Container(),
                      painter: ArrowPainter(widget.board.arrows, widget.board.orientation),
                    ),
                  ),
                ),
            ]),
      ),
    );
  }
}
