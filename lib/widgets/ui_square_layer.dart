import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/models/board.dart';
import 'package:flutter_stateless_chessboard/models/half_move.dart';
import 'package:flutter_stateless_chessboard/models/piece.dart';
import 'package:flutter_stateless_chessboard/models/short_move.dart';
import 'package:flutter_stateless_chessboard/widgets/ui_square.dart';
import 'package:fpdart/fpdart.dart' show Option;
import 'package:provider/provider.dart';

import '../models/square.dart';

class UISquareLayer extends StatefulWidget {
  @override
  State<UISquareLayer> createState() => _UISquareLayerState();
}

class _UISquareLayerState extends State<UISquareLayer> {
  Option<HalfMove> clickMove = Option.none();

  @override
  Widget build(BuildContext context) {
    final board = Provider.of<Board>(context);

    return Stack(
      children: board.squares
        .map((it) => UISquare(
          square: it,
          onClick: (m) => handleClick(board, m),
          onDrop: (hf) => handleDrop(board, hf),
          highlight: getHighlight(board, it)
        ))
        .toList(growable: false),
    );
  }

  Color? getHighlight(Board board, Square square) {
    return clickMove
      .filter((t) => t.square == square.name)
      .map((_) => board.selectionHighlightColor)
      .alt(() => Option.fromPredicate(
          board.lastMoveHighlightColor,
          (_) => board.lastMove.contains(square.name),
        ))
      .toNullable();
  }

  void handleDrop(Board board, ShortMove move) {
    board.makeMove(move).then((_) {
      clearClickMove();
    });
  }

  void handleClick(Board board, HalfMove halfMove) {
    clickMove.match(
      () => setClickMove(halfMove),
      (t) {
        final sameSquare = t.square == halfMove.square;
        final sameColorPiece = t.piece
            .map2<Piece, bool>(halfMove.piece, (t, r) => t.color == r.color)
            .getOrElse(() => false);

        if (sameSquare) {
          clearClickMove();
        } else if (sameColorPiece) {
          setClickMove(halfMove);
        } else {
          board.makeMove(ShortMove(
            from: t.square,
            to: halfMove.square,
          ));
          clearClickMove();
        }
      },
    );
  }

  void setClickMove(HalfMove halfMove) {
    setState(() {
      clickMove = Option.of(halfMove).flatMap((t) => t.piece.map((_) => t));
    });
  }

  void clearClickMove() {
    setState(() {
      clickMove = Option.none();
    });
  }
}
